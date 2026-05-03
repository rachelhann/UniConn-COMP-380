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

    private static final int DEFAULT_PAGE_SIZE = 20;

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
    // ALGORITHM 1 — Default feed for new users
    // 80% community posts, 20% profile posts, newest first, NEVER empty
    // ---------------------------------------------------------------
    public List<PostSummaryDTO> getDefaultFeed(Integer userId, int page, int size) {
        List<Post> allPosts = postRepository.findAll()
                .stream()
                .filter(p -> !p.isDeleted())
                .sorted(Comparator
                        .comparingInt((Post p) -> p.getCommunity() != null
                                ? p.getCommunity().getMemberCount() : 0)
                        .reversed()
                        .thenComparing(Comparator.comparing(Post::getCreatedAt).reversed()))
                .collect(Collectors.toList());

        List<Post> communityPosts = allPosts.stream()
                .filter(p -> p.getCommunity() != null)
                .collect(Collectors.toList());

        List<Post> profilePosts = allPosts.stream()
                .filter(p -> p.getCommunity() == null)
                .collect(Collectors.toList());

        int total = allPosts.size();
        int communityTarget = (int) (total * 0.8);
        int profileTarget = total - communityTarget;

        List<Post> feed = new ArrayList<>();
        feed.addAll(communityPosts.stream().limit(communityTarget).collect(Collectors.toList()));
        feed.addAll(profilePosts.stream().limit(profileTarget).collect(Collectors.toList()));

        feed.sort(Comparator.comparing(Post::getCreatedAt).reversed());

        if (feed.isEmpty()) feed = allPosts;

        int fromIndex = page * size;
        if (fromIndex >= feed.size()) return new ArrayList<>();
        int toIndex = Math.min(fromIndex + size, feed.size());

        return feed.subList(fromIndex, toIndex)
                .stream()
                .map(p -> toDTO(p, userId))
                .collect(Collectors.toList());
    }

    public List<PostSummaryDTO> getDefaultFeed(Integer userId) {
        return getDefaultFeed(userId, 0, DEFAULT_PAGE_SIZE);
    }

    // ---------------------------------------------------------------
    // ALGORITHM 2 — Personalized feed, newest first, deduplicated
    // ---------------------------------------------------------------
    public List<PostSummaryDTO> getPersonalizedFeed(Integer userId, int page, int size) {
        List<Post> personalizedPosts = new ArrayList<>(postRepository.findFeedPostsForUser(userId));

        // Add own posts
        List<Post> ownPosts = postRepository.findProfilePostsByUser(userId);
        Set<Integer> seenIds = personalizedPosts.stream()
                .map(Post::getPostId)
                .collect(Collectors.toSet());
        for (Post p : ownPosts) {
            if (seenIds.add(p.getPostId())) {
                personalizedPosts.add(p);
            }
        }

        // Add tag discovery posts
        List<String> interestTags = getInterestTags(userId);
        if (!interestTags.isEmpty()) {
            for (String tag : interestTags) {
                postRepository.findPostsByExactTag(tag).stream()
                        .filter(p -> seenIds.add(p.getPostId()))
                        .forEach(personalizedPosts::add);
            }
        }

        // Sort strictly newest first
        personalizedPosts.sort(Comparator.comparing(Post::getCreatedAt).reversed());

        if (personalizedPosts.isEmpty()) return getDefaultFeed(userId, page, size);

        // Paginate
        int fromIndex = page * size;
        if (fromIndex >= personalizedPosts.size()) return new ArrayList<>();
        int toIndex = Math.min(fromIndex + size, personalizedPosts.size());

        return personalizedPosts.subList(fromIndex, toIndex)
                .stream()
                .map(p -> toDTO(p, userId))
                .collect(Collectors.toList());
    }

    public List<PostSummaryDTO> getPersonalizedFeed(Integer userId) {
        return getPersonalizedFeed(userId, 0, DEFAULT_PAGE_SIZE);
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
    // DTO MAPPER
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
                canDelete,
                post.getGifUrl()
        );
    }
}