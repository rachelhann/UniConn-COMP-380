package com.uniconn.backend.services;

import com.uniconn.backend.composite_keys.CommunityMemberId;
import com.uniconn.backend.composite_keys.PostLikeId;
import com.uniconn.backend.dtos.*;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.exception.*;
import com.uniconn.backend.repositories.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PostManagementService extends BaseService {

    private final PostRepository postRepository;
    private final CommunityRepository communityRepository;
    private final CommunityMemberRepository communityMemberRepository;
    private final PostTagService postTagService;
    private final PostLikeRepository postLikeRepository;

    public PostManagementService(PostRepository postRepository,
                                 CommunityRepository communityRepository,
                                 CommunityMemberRepository communityMemberRepository,
                                 PostTagService postTagService,
                                 PostLikeRepository postLikeRepository) {
        this.postRepository = postRepository;
        this.communityRepository = communityRepository;
        this.communityMemberRepository = communityMemberRepository;
        this.postTagService = postTagService;
        this.postLikeRepository = postLikeRepository;
    }

    // ---------------------------------------------------------------
    // CREATE
    // ---------------------------------------------------------------
    @Transactional
    public PostSummaryDTO createPost(PostCreateDTO dto) {
        User currentUser = getAuthenticatedUser();

        Post post = new Post();
        post.setAuthor(currentUser);
        post.setContentText(dto.getContentText());
        post.setGifUrl(dto.getGifUrl());

        if (dto.getCommunityId() != null) {
            Community community = communityRepository.findById(dto.getCommunityId())
                .orElseThrow(() -> new ResourceNotFoundException(
                    "Community not found: " + dto.getCommunityId()));

            boolean isMember = communityMemberRepository.existsById(
                new CommunityMemberId(dto.getCommunityId(), currentUser.getUserId()));
            if (!isMember) {
                throw new UnauthorizedException("You must be a member to post in this community");
            }

            if (dto.getTitle() == null || dto.getTitle().isBlank()) {
                throw new InvalidInputException("Title is required for community posts");
            }

            post.setCommunity(community);
            post.setTitle(dto.getTitle());
        }

        Post saved = postRepository.save(post);
        List<String> tagNames = postTagService.saveTags(saved, dto.getTags());

        // freshly created post: not liked yet, author can always delete own post
        return mapToSummaryDTO(saved, tagNames, currentUser.getUserId());
    }

    // ---------------------------------------------------------------
    // DELETE
    // ---------------------------------------------------------------
    @Transactional
    public void deletePost(Integer postId) {
        User currentUser = getAuthenticatedUser();

        Post post = postRepository.findById(postId)
            .orElseThrow(() -> new ResourceNotFoundException("Post not found: " + postId));

        if (post.isDeleted()) {
            throw new ResourceNotFoundException("Post not found: " + postId);
        }

        boolean isAuthor = post.getAuthor().getUserId().equals(currentUser.getUserId());

        if (!isAuthor) {
            if (post.getCommunity() == null) {
                throw new UnauthorizedException("You are not allowed to delete this post");
            }
            boolean isAdmin = communityMemberRepository
                .existsById_CommunityIdAndId_UserIdAndRole(
                    post.getCommunity().getCommunityId(),
                    currentUser.getUserId(),
                    CommunityMemberRole.ADMIN);
            if (!isAdmin) {
                throw new UnauthorizedException("You are not allowed to delete this post");
            }
        }

        post.setDeleted(true);
        postRepository.save(post);
    }
    
    // post for postcard
    @Transactional(readOnly = true)
    public PostSummaryDTO getPost(Integer postId) {
        User currentUser = getAuthenticatedUser();
        Post post = postRepository.findByIdWithTags(postId)
        	    .orElseThrow(() -> new ResourceNotFoundException("Post not found: " + postId));
        if (post.isDeleted()) {
            throw new ResourceNotFoundException("Post not found: " + postId);
        }
        return mapToSummaryDTO(post, currentUser.getUserId());
    }

    // ---------------------------------------------------------------
    // FEED
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<PostSummaryDTO> getFeedForUser(Integer userId) {
        User currentUser = getAuthenticatedUser();
        return postRepository.findFeedPostsForUser(userId)
                .stream()
                .map(p -> mapToSummaryDTO(p, currentUser.getUserId()))
                .collect(Collectors.toList());
    }

    // ---------------------------------------------------------------
    // TRENDING TAGS (last 30 days)
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<TrendingTagDTO> getTrendingTags() {
        LocalDateTime since = LocalDateTime.now().minusDays(30);
        return postRepository.findTrendingTagsRaw(since)
                .stream()
                .map(row -> new TrendingTagDTO((String) row[0], (Long) row[1]))
                .collect(Collectors.toList());
    }

    // ---------------------------------------------------------------
    // POSTS BY EXACT TAG
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<PostSummaryDTO> getPostsByTag(String tagName) {
        User currentUser = getAuthenticatedUser();
        return postRepository.findPostsByExactTag(tagName)
                .stream()
                .map(p -> mapToSummaryDTO(p, currentUser.getUserId()))
                .collect(Collectors.toList());
    }

    // ---------------------------------------------------------------
    // SEARCH BY TAG
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<PostSummaryDTO> searchPostsByTag(String query) {
        User currentUser = getAuthenticatedUser();
        return postRepository.findPostsByTagContaining(query.trim())
                .stream()
                .map(p -> mapToSummaryDTO(p, currentUser.getUserId()))
                .collect(Collectors.toList());
    }

    // ---------------------------------------------------------------
    // PROFILE POSTS
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<PostSummaryDTO> getProfilePosts(Integer userId) {
        User currentUser = getAuthenticatedUser();
        return postRepository.findProfilePostsByUser(userId)
                .stream()
                .map(p -> mapToSummaryDTO(p, currentUser.getUserId()))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PostSummaryDTO> getProfilePostsByUsername(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + username));
        return getProfilePosts(user.getUserId());
    }

    // ---------------------------------------------------------------
    // COMMUNITY POSTS BY USER
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<PostSummaryDTO> getCommunityPostsByUser(Integer userId) {
        User currentUser = getAuthenticatedUser();
        return postRepository.findCommunityPostsByUser(userId)
                .stream()
                .map(p -> mapToSummaryDTO(p, currentUser.getUserId()))
                .collect(Collectors.toList());
    }

    // ---------------------------------------------------------------
    // ALL POSTS IN A COMMUNITY
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<PostSummaryDTO> getPostsByCommunity(Integer communityId) {
        User currentUser = getAuthenticatedUser();
        return postRepository.findPostsByCommunity(communityId)
                .stream()
                .map(p -> mapToSummaryDTO(p, currentUser.getUserId()))
                .collect(Collectors.toList());
    }
    
    // ---------------------------------------------------------------
    // POSTS USER LIKED
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<PostSummaryDTO> getPostsLikedByUser(Integer userId) {
        User currentUser = getAuthenticatedUser();
        return postRepository.findPostsLikedByUser(userId)
                .stream()
                .map(p -> mapToSummaryDTO(p, currentUser.getUserId()))
                .collect(Collectors.toList());
    }

    // ---------------------------------------------------------------
    // HELPERS
    // ---------------------------------------------------------------

    // used for read queries - tags fetched from already-loaded post.getTags()
    private PostSummaryDTO mapToSummaryDTO(Post post, Integer currentUserId) {
        List<String> tagNames = post.getTags()
                .stream()
                .map(pt -> pt.getTag().getName())
                .collect(Collectors.toList());
        return mapToSummaryDTO(post, tagNames, currentUserId);
    }

    // used for createPost - tags passed in directly from postTagService
    private PostSummaryDTO mapToSummaryDTO(Post post, List<String> tagNames, Integer currentUserId) {
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
            post.getCommunity() != null ? post.getCommunity().getCommunityId()   : null,
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