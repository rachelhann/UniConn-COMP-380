package com.uniconn.backend.services;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
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
    public List<PostSummaryDTO> getFeedForAuthenticatedUser() {
        Integer userId = getAuthenticatedUser().getUserId();
        return getFeed(userId);
    }

    public List<PostSummaryDTO> getFeed(Integer userId) {
        long communities = communityMemberRepository
                .findByUser_UserId(userId).size();
        long following = userRepository.findById(userId)
                .map(u -> u.getFollowingCount())
                .orElse(0);

        if (communities == 0 && following == 0) {
            return getDefaultFeed(userId);
        }
        return getPersonalizedFeed(userId);
    }

    // ---------------------------------------------------------------
    // ALGORITHM 1 — Default feed for new users
    // Uses existing findFeedPostsForUser but falls back to ALL posts
    // if user has nothing — 80% community posts, 20% profile posts
    // newest first, NEVER empty
    // ---------------------------------------------------------------
    public List<PostSummaryDTO> getDefaultFeed(Integer userId) {
        // Try to get all posts — order by popular community first, then newest
        List<Post> allPosts = postRepository.findAll()
                .stream()
                .filter(p -> !p.isDeleted())
                .sorted(Comparator
                        .comparingInt((Post p) -> p.getCommunity() != null
                                ? p.getCommunity().getMemberCount() : 0)
                        .reversed()
                        .thenComparing(Comparator.comparing(Post::getCreatedAt).reversed()))
                .collect(Collectors.toList());

        // 80% community posts, 20% profile posts
        List<Post> communityPosts = allPosts.stream()
                .filter(p -> p.getCommunity() != null)
                .collect(Collectors.toList());

        List<Post> profilePosts = allPosts.stream()
                .filter(p -> p.getCommunity() == null)
                .collect(Collectors.toList());

        int total = Math.min(allPosts.size(), 50);
        int communityTarget = (int) (total * 0.8);
        int profileTarget = total - communityTarget;

        List<Post> feed = new ArrayList<>();
        feed.addAll(communityPosts.stream().limit(communityTarget).collect(Collectors.toList()));
        feed.addAll(profilePosts.stream().limit(profileTarget).collect(Collectors.toList()));

        // Final sort: newest first
        feed.sort(Comparator.comparing(Post::getCreatedAt).reversed());

        // Fallback: never empty
        if (feed.isEmpty()) feed = allPosts.stream().limit(50).collect(Collectors.toList());

        return feed.stream()
                .map(p -> toDTO(p, userId))
                .collect(Collectors.toList());
    }

    // ---------------------------------------------------------------
    // ALGORITHM 2 — Personalized feed for active users
    // Uses existing findFeedPostsForUser as base, adds scoring layer
    // + tag interest discovery, 85/15 split, never empty
    // ---------------------------------------------------------------
    public List<PostSummaryDTO> getPersonalizedFeed(Integer userId) {
        // Base: posts from communities + following (reuse teammate's query)
        List<Post> personalizedPosts = postRepository.findFeedPostsForUser(userId);

        // Interest tags from posts user liked
        List<String> interestTags = getInterestTags(userId);

        // Discovery posts by interest tags
        List<Post> tagPosts = new ArrayList<>();
        if (!interestTags.isEmpty()) {
            Set<Integer> seenIds = personalizedPosts.stream()
                    .map(Post::getPostId)
                    .collect(Collectors.toSet());

            for (String tag : interestTags) {
                postRepository.findPostsByExactTag(tag).stream()
                        .filter(p -> !seenIds.contains(p.getPostId()))
                        .forEach(p -> { tagPosts.add(p); seenIds.add(p.getPostId()); });
            }
        }

        // Score personalized posts
        List<ScoredPost> scoredPersonal = personalizedPosts.stream()
                .map(p -> new ScoredPost(p, scorePost(p, true)))
                .sorted(Comparator.comparingDouble(ScoredPost::score).reversed())
                .collect(Collectors.toList());

        // Score discovery posts
        List<ScoredPost> scoredDiscovery = tagPosts.stream()
                .map(p -> new ScoredPost(p, scorePost(p, false)))
                .sorted(Comparator.comparingDouble(ScoredPost::score).reversed())
                .collect(Collectors.toList());

        // 85% personalized, 15% discovery
        int total = Math.min(scoredPersonal.size() + scoredDiscovery.size(), 50);
        int personalTarget = (int) (total * 0.85);
        int discoveryTarget = total - personalTarget;

        List<Post> finalFeed = new ArrayList<>();
        scoredPersonal.stream().limit(personalTarget).forEach(sp -> finalFeed.add(sp.post()));
        scoredDiscovery.stream().limit(discoveryTarget).forEach(sp -> finalFeed.add(sp.post()));

        // Final sort: newest first
        finalFeed.sort(Comparator.comparing(Post::getCreatedAt).reversed());

        // Fallback: never empty
        if (finalFeed.isEmpty()) return getDefaultFeed(userId);

        return finalFeed.stream()
                .map(p -> toDTO(p, userId))
                .collect(Collectors.toList());
    }

    // ---------------------------------------------------------------
    // SCORING
    // ---------------------------------------------------------------
    private double scorePost(Post p, boolean isPersonalized) {
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

        if (isPersonalized) score += 20;
        return score;
    }

    // ---------------------------------------------------------------
    // GET INTEREST TAGS FROM LIKED POSTS
    // ---------------------------------------------------------------
        private List<String> getInterestTags(Integer userId) {
        return postLikeRepository.findByIdUserId(userId)
                .stream()
                .flatMap(pl -> pl.getPost().getTags().stream()
                        .map(pt -> pt.getTag().getName()))
                .distinct()
                .collect(Collectors.toList());
        }

    // ---------------------------------------------------------------
    // HELPER RECORD
    // ---------------------------------------------------------------
    private record ScoredPost(Post post, double score) {}

    // ---------------------------------------------------------------
    // DTO MAPPER — matches PostManagementService exactly
    // ---------------------------------------------------------------
    private PostSummaryDTO toDTO(Post post, Integer currentUserId) {
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
                canDelete
        );
    }
}