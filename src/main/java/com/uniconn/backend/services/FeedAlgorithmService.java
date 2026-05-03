package com.uniconn.backend.services;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.uniconn.backend.composite_keys.PostLikeId;
import com.uniconn.backend.dtos.PostSummaryDTO;
import com.uniconn.backend.entities.CommunityMemberRole;
import com.uniconn.backend.entities.Post;
import com.uniconn.backend.repositories.CommunityMemberRepository;
import com.uniconn.backend.repositories.PostLikeRepository;
import com.uniconn.backend.repositories.PostRepository;

@Service
@Transactional(readOnly = true)
public class FeedAlgorithmService extends BaseService {

    private final PostRepository postRepository;
    private final PostLikeRepository postLikeRepository;
    private final CommunityMemberRepository communityMemberRepository;

    private static final int DEFAULT_PAGE_SIZE = 20;
    private static final int TAG_DISCOVERY_CAP = 10;

    // Source priority bonuses
    private static final double BONUS_SOCIAL = 40.0;
    private static final double BONUS_OWN    = 10.0;

    // Fresh injection: every N slots, inject a recent post (<2h old)
    // so new content is always discoverable and the feed feels live
    private static final int FRESH_INJECTION_INTERVAL = 5;

    public FeedAlgorithmService(PostRepository postRepository,
                                PostLikeRepository postLikeRepository,
                                CommunityMemberRepository communityMemberRepository) {
        this.postRepository = postRepository;
        this.postLikeRepository = postLikeRepository;
        this.communityMemberRepository = communityMemberRepository;
    }

    // ---------------------------------------------------------------
    // MAIN ENTRY — auto-selects Algorithm 1 or 2
    // ---------------------------------------------------------------
    public List<PostSummaryDTO> getFeed(Integer userId, int page, int size) {
        long communities = communityMemberRepository
                .findByUser_UserId(userId).size();
        long following = userRepository.findById(userId)
                .map(u -> u.getFollowingCount())
                .orElse(0);

        if (communities == 0 && following == 0) {
            return getDefaultFeed(userId, page, size);
        }
        return getPersonalizedFeed(userId, page, size);
    }

    public List<PostSummaryDTO> getFeed(Integer userId) {
        return getFeed(userId, 0, DEFAULT_PAGE_SIZE);
    }

    // ---------------------------------------------------------------
    // FEED TYPE — returns "suggested" for Algorithm 1, "feed" for Algorithm 2
    // ---------------------------------------------------------------
    public String getFeedType(Integer userId) {
        long communities = communityMemberRepository
                .findByUser_UserId(userId).size();
        long following = userRepository.findById(userId)
                .map(u -> u.getFollowingCount())
                .orElse(0);
        return (communities == 0 && following == 0) ? "suggested" : "feed";
    }

    // ---------------------------------------------------------------
    // ALGORITHM 1 — Default feed for new users
    // Top 5 trending tags, posts ordered by createdAt DESC, deduplicated
    // ---------------------------------------------------------------
    public List<PostSummaryDTO> getDefaultFeed(Integer userId, int page, int size) {
        LocalDateTime since = LocalDateTime.now().minusDays(30);

        List<String> topTags = postRepository.findTrendingTagsRaw(since)
                .stream()
                .limit(5)
                .map(row -> (String) row[0])
                .collect(Collectors.toList());

        List<Post> feed = new ArrayList<>();
        Set<Integer> seenIds = new HashSet<>();

        for (String tag : topTags) {
            postRepository.findPostsByExactTag(tag).stream()
                    .filter(p -> seenIds.add(p.getPostId()))
                    .forEach(feed::add);
        }

        // Fallback: if no trending tags exist yet, show all non-deleted posts newest first
        if (feed.isEmpty()) {
            postRepository.findAll().stream()
                    .filter(p -> !p.isDeleted())
                    .forEach(feed::add);
        }

        feed.sort(Comparator.comparing(Post::getCreatedAt).reversed());

        int fromIndex = page * size;
        if (fromIndex >= feed.size()) return new ArrayList<>();
        int toIndex = Math.min(fromIndex + size, feed.size());

        return feed.subList(fromIndex, toIndex)
                .stream()
                .map(p -> toDTO(p, userId, true))
                .collect(Collectors.toList());
    }

    public List<PostSummaryDTO> getDefaultFeed(Integer userId) {
        return getDefaultFeed(userId, 0, DEFAULT_PAGE_SIZE);
    }

    // ---------------------------------------------------------------
    // ALGORITHM 2 — Interest-based feed, interleaved 60/40
    //
    // Four scored buckets split by post type:
    //   Bucket A  — community posts from social graph (60% of slots)
    //   Bucket B  — profile posts from social graph   (40% of slots)
    //   Bucket CA — community filler (discovery + DB fallback, community type)
    //   Bucket CB — profile filler   (discovery + DB fallback, profile type)
    //
    // Every FRESH_INJECTION_INTERVAL slots, the highest-scored post
    // from the last 2 hours is injected so new content is always visible.
    //
    // Within each bucket posts rank by score (likes x2, comments x3,
    // recency bonus) so engaging posts rise to the top of their bucket.
    // ---------------------------------------------------------------
    public List<PostSummaryDTO> getPersonalizedFeed(Integer userId, int page, int size) {
        Set<Integer> seenIds = new HashSet<>();

        List<ScoredPost> bucketA  = new ArrayList<>(); // community posts — social graph
        List<ScoredPost> bucketB  = new ArrayList<>(); // profile posts   — social graph
        List<ScoredPost> bucketCA = new ArrayList<>(); // community filler
        List<ScoredPost> bucketCB = new ArrayList<>(); // profile filler

        // -- Tier 1: social graph posts (followed users + joined communities)
        // Split by type into A (community) and B (profile)
        List<Post> socialPosts = postRepository.findFeedPostsForUser(userId);
        for (Post p : socialPosts) {
            if (seenIds.add(p.getPostId())) {
                ScoredPost sp = new ScoredPost(p, scorePost(p) + BONUS_SOCIAL);
                if (p.getCommunity() != null) {
                    bucketA.add(sp);
                } else {
                    bucketB.add(sp);
                }
            }
        }

        // -- Tier 2: own posts → always profile → bucket B
        List<Post> ownPosts = postRepository.findProfilePostsByUser(userId);
        for (Post p : ownPosts) {
            if (seenIds.add(p.getPostId())) {
                bucketB.add(new ScoredPost(p, scorePost(p) + BONUS_OWN));
            }
        }

        // -- Tier 3: tag discovery → split by type into CA or CB
        List<Post> likedPosts = postRepository.findPostsLikedByUser(userId);
        List<String> interestTags = getInterestTags(likedPosts, ownPosts);
        for (String tag : interestTags) {
            postRepository.findPostsByExactTag(tag).stream()
                    .filter(p -> seenIds.add(p.getPostId()))
                    .limit(TAG_DISCOVERY_CAP)
                    .forEach(p -> {
                        ScoredPost sp = new ScoredPost(p, scorePost(p));
                        if (p.getCommunity() != null) {
                            bucketCA.add(sp);
                        } else {
                            bucketCB.add(sp);
                        }
                    });
        }

        // -- Tier 4: DB fallback → split by type into CA or CB
        postRepository.findAll().stream()
                .filter(p -> !p.isDeleted())
                .filter(p -> seenIds.add(p.getPostId()))
                .forEach(p -> {
                    ScoredPost sp = new ScoredPost(p, scorePost(p));
                    if (p.getCommunity() != null) {
                        bucketCA.add(sp);
                    } else {
                        bucketCB.add(sp);
                    }
                });

        // Fallback to Algorithm 1 if everything is empty
        if (bucketA.isEmpty() && bucketB.isEmpty()
                && bucketCA.isEmpty() && bucketCB.isEmpty()) {
            return getDefaultFeed(userId, page, size);
        }

        // Sort each bucket by score descending
        bucketA.sort(Comparator.comparingDouble(ScoredPost::score).reversed());
        bucketB.sort(Comparator.comparingDouble(ScoredPost::score).reversed());
        bucketCA.sort(Comparator.comparingDouble(ScoredPost::score).reversed());
        bucketCB.sort(Comparator.comparingDouble(ScoredPost::score).reversed());

        // ---------------------------------------------------------------
        // FRESH INJECTION POOL
        // Posts created in the last 2 hours, not yet in seenIds,
        // sorted by score DESC. Every FRESH_INJECTION_INTERVAL slots
        // we inject the next fresh post so new content always surfaces.
        // ---------------------------------------------------------------
        LocalDateTime twoHoursAgo = LocalDateTime.now().minusHours(2);
        List<ScoredPost> freshPool = postRepository.findAll().stream()
                .filter(p -> !p.isDeleted())
                .filter(p -> p.getCreatedAt() != null
                        && p.getCreatedAt().isAfter(twoHoursAgo))
                .filter(p -> !seenIds.contains(p.getPostId()))
                .map(p -> new ScoredPost(p, scorePost(p)))
                .sorted(Comparator.comparingDouble(ScoredPost::score).reversed())
                .collect(Collectors.toList());

        Set<Integer> freshInjected = new HashSet<>();

        // ---------------------------------------------------------------
        // SLOT PATTERN — 60/40 community vs profile
        // Per 10 slots: 6 community (A), 4 profile (B)
        // Community slot falls through: A → CA → CB
        // Profile slot falls through:   B → CB → CA
        // Pattern index: 0=community slot, 1=profile slot
        // ---------------------------------------------------------------
        int[] pattern = {0, 1, 0, 1, 0, 0, 1, 0, 1, 0};
        // 6 zeros (community) and 4 ones (profile) per 10 slots = 60/40

        int idxA  = 0;
        int idxB  = 0;
        int idxCA = 0;
        int idxCB = 0;
        int freshIdx = 0;

        int needed = (page + 1) * size;
        List<ScoredPost> interleaved = new ArrayList<>();

        int slot = 0;
        while (interleaved.size() < needed) {
            boolean allEmpty = idxA  >= bucketA.size()
                    && idxB  >= bucketB.size()
                    && idxCA >= bucketCA.size()
                    && idxCB >= bucketCB.size();
            if (allEmpty) break;

            // Fresh injection every FRESH_INJECTION_INTERVAL slots
            if (slot > 0
                    && slot % FRESH_INJECTION_INTERVAL == 0
                    && freshIdx < freshPool.size()) {
                ScoredPost fresh = freshPool.get(freshIdx);
                if (freshInjected.add(fresh.post().getPostId())) {
                    interleaved.add(fresh);
                    freshIdx++;
                    slot++;
                    continue;
                }
            }

            int slotType = pattern[slot % pattern.length]; // 0=community, 1=profile
            boolean added = false;

            if (slotType == 0) {
                // Community slot: prefer A, fall through to CA, then CB
                if (idxA < bucketA.size()) {
                    interleaved.add(bucketA.get(idxA++));
                    added = true;
                } else if (idxCA < bucketCA.size()) {
                    interleaved.add(bucketCA.get(idxCA++));
                    added = true;
                } else if (idxCB < bucketCB.size()) {
                    interleaved.add(bucketCB.get(idxCB++));
                    added = true;
                } else if (idxB < bucketB.size()) {
                    // Last resort — use profile if no community content left
                    interleaved.add(bucketB.get(idxB++));
                    added = true;
                }
            } else {
                // Profile slot: prefer B, fall through to CB, then CA
                if (idxB < bucketB.size()) {
                    interleaved.add(bucketB.get(idxB++));
                    added = true;
                } else if (idxCB < bucketCB.size()) {
                    interleaved.add(bucketCB.get(idxCB++));
                    added = true;
                } else if (idxCA < bucketCA.size()) {
                    interleaved.add(bucketCA.get(idxCA++));
                    added = true;
                } else if (idxA < bucketA.size()) {
                    // Last resort — use community if no profile content left
                    interleaved.add(bucketA.get(idxA++));
                    added = true;
                }
            }

            if (!added) break;
            slot++;
        }

        // Paginate
        int fromIndex = page * size;
        if (fromIndex >= interleaved.size()) return new ArrayList<>();
        int toIndex = Math.min(fromIndex + size, interleaved.size());

        return interleaved.subList(fromIndex, toIndex)
                .stream()
                .map(sp -> toDTO(sp.post(), userId, false))
                .collect(Collectors.toList());
    }

    public List<PostSummaryDTO> getPersonalizedFeed(Integer userId) {
        return getPersonalizedFeed(userId, 0, DEFAULT_PAGE_SIZE);
    }

    // ---------------------------------------------------------------
    // SCORING
    // Engagement: likes x2, comments x3
    // Recency:    <24h +50, <72h +25, <1 week +10
    // Source bonus applied by caller
    // ---------------------------------------------------------------
    private double scorePost(Post p) {
        double score = 0;
        score += p.getLikeCount() * 2.0;
        score += p.getCommentCount() * 3.0;

        if (p.getCreatedAt() != null) {
            long hoursOld = java.time.Duration.between(
                    p.getCreatedAt(), LocalDateTime.now()).toHours();
            if (hoursOld <= 24)       score += 50;
            else if (hoursOld <= 72)  score += 25;
            else if (hoursOld <= 168) score += 10;
        }

        return score;
    }

    // ---------------------------------------------------------------
    // GET INTEREST TAGS
    // Sources: posts the user liked + posts the user authored
    // ---------------------------------------------------------------
    private List<String> getInterestTags(List<Post> likedPosts, List<Post> ownPosts) {
        Set<String> seen = new HashSet<>();
        List<String> allTags = new ArrayList<>();

        for (Post p : likedPosts) {
            for (var pt : p.getTags()) {
                String name = pt.getTag().getName();
                if (seen.add(name)) allTags.add(name);
            }
        }

        for (Post p : ownPosts) {
            for (var pt : p.getTags()) {
                String name = pt.getTag().getName();
                if (seen.add(name)) allTags.add(name);
            }
        }

        return allTags;
    }

    // ---------------------------------------------------------------
    // HELPER RECORD
    // ---------------------------------------------------------------
    private record ScoredPost(Post post, double score) {}

    // ---------------------------------------------------------------
    // DTO MAPPER — isSuggested flag controls Algorithm 1 vs 2
    // ---------------------------------------------------------------
    private PostSummaryDTO toDTO(Post post, Integer currentUserId, boolean isSuggested) {
        List<String> tagNames = post.getTags().stream()
                .map(pt -> pt.getTag().getName())
                .collect(Collectors.toList());

        boolean liked = postLikeRepository.existsById(
                new PostLikeId(currentUserId, post.getPostId()));

        boolean canDelete = post.getAuthor().getUserId().equals(currentUserId)
                || (post.getCommunity() != null
                    && communityMemberRepository.existsById_CommunityIdAndId_UserIdAndRole(
                        post.getCommunity().getCommunityId(),
                        currentUserId,
                        CommunityMemberRole.ADMIN));

        return new PostSummaryDTO(
                post.getPostId(),
                post.getAuthor().getUsername(),
                post.getAuthor().getUserId(),
                post.getCommunity() != null ? post.getCommunity().getCommunityName() : null,
                post.getCommunity() != null ? post.getCommunity().getCommunityId() : null,
                post.getTitle(),
                post.getContentText(),
                post.getLikeCount(),
                post.getCommentCount(),
                post.getCreatedAt(),
                tagNames,
                liked,
                canDelete,
                post.getGifUrl(),
                isSuggested
        );
    }
}