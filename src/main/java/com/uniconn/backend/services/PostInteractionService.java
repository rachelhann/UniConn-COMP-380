package com.uniconn.backend.services;

import com.uniconn.backend.composite_keys.CommentLikeId;
import com.uniconn.backend.composite_keys.PostLikeId;
import com.uniconn.backend.dtos.*;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.exception.*;
import com.uniconn.backend.repositories.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PostInteractionService extends BaseService {

    private final PostRepository postRepository;
    private final PostLikeRepository postLikeRepository;
    private final CommentRepository commentRepository;
    private final CommunityMemberRepository communityMemberRepository;
    private final CommentLikeRepository commentLikeRepository;

    public PostInteractionService(PostRepository postRepository,
                                  PostLikeRepository postLikeRepository,
                                  CommentRepository commentRepository,
                                  CommunityMemberRepository communityMemberRepository,
                                  CommentLikeRepository commentLikeRepository) {
        this.postRepository = postRepository;
        this.postLikeRepository = postLikeRepository;
        this.commentRepository = commentRepository;
        this.communityMemberRepository = communityMemberRepository;
        this.commentLikeRepository = commentLikeRepository;
    }

    // ---------------------------------------------------------------
    // LIKE POST
    // ---------------------------------------------------------------
    @Transactional
    public void likePost(Integer postId) {
        User currentUser = getAuthenticatedUser();

        Post post = postRepository.findById(postId)
            .orElseThrow(() -> new ResourceNotFoundException("Post not found: " + postId));

        if (post.isDeleted()) {
            throw new ResourceNotFoundException("Post not found: " + postId);
        }

        PostLikeId likeId = new PostLikeId(currentUser.getUserId(), postId);

        if (postLikeRepository.existsById(likeId)) {
            throw new ResourceAlreadyExistsException("You have already liked this post");
        }

        PostLike like = new PostLike();
        like.setId(likeId);
        like.setUser(currentUser);
        like.setPost(post);
        postLikeRepository.save(like);

        post.setLikeCount(post.getLikeCount() + 1);
        postRepository.save(post);
    }

    // ---------------------------------------------------------------
    // UNLIKE POST
    // ---------------------------------------------------------------
    @Transactional
    public void unlikePost(Integer postId) {
        User currentUser = getAuthenticatedUser();

        Post post = postRepository.findById(postId)
            .orElseThrow(() -> new ResourceNotFoundException("Post not found: " + postId));

        if (post.isDeleted()) {
            throw new ResourceNotFoundException("Post not found: " + postId);
        }

        PostLikeId likeId = new PostLikeId(currentUser.getUserId(), postId);

        if (!postLikeRepository.existsById(likeId)) {
            throw new ResourceNotFoundException("You have not liked this post");
        }

        postLikeRepository.deleteById(likeId);

        post.setLikeCount(Math.max(0, post.getLikeCount() - 1));
        postRepository.save(post);
    }

    // ---------------------------------------------------------------
    // COMMENT ON POST
    // ---------------------------------------------------------------
    @Transactional
    public CommentSummaryDTO createComment(CommentCreateDTO dto) {
        User currentUser = getAuthenticatedUser();

        Post post = postRepository.findById(dto.getPostId())
            .orElseThrow(() -> new ResourceNotFoundException("Post not found: " + dto.getPostId()));

        if (post.isDeleted()) {
            throw new ResourceNotFoundException("Post not found: " + dto.getPostId());
        }

        Comment comment = new Comment();
        comment.setPost(post);
        comment.setAuthor(currentUser);
        comment.setContentText(dto.getContentText());
        comment.setGifUrl(dto.getGifUrl());

        Comment saved = commentRepository.save(comment);

        post.setCommentCount(post.getCommentCount() + 1);
        postRepository.save(post);

        return mapToDTO(saved);
    }

    // ---------------------------------------------------------------
    // DELETE COMMENT
    // ---------------------------------------------------------------
    @Transactional
    public void deleteComment(Integer commentId) {
        User currentUser = getAuthenticatedUser();

        Comment comment = commentRepository.findById(commentId)
            .orElseThrow(() -> new ResourceNotFoundException("Comment not found: " + commentId));

        if (comment.isDeleted()) {
            throw new ResourceNotFoundException("Comment not found: " + commentId);
        }

        boolean isAuthor = comment.getAuthor().getUserId().equals(currentUser.getUserId());

        if (!isAuthor) {
            Post post = comment.getPost();
            if (post.getCommunity() == null) {
                // profile post — author only
                throw new UnauthorizedException("You are not allowed to delete this comment");
            }

            boolean isAdmin = communityMemberRepository
                .existsById_CommunityIdAndId_UserIdAndRole(
                    post.getCommunity().getCommunityId(),
                    currentUser.getUserId(),
                    CommunityMemberRole.ADMIN);

            if (!isAdmin) {
                throw new UnauthorizedException("You are not allowed to delete this comment");
            }
        }

        comment.setDeleted(true);
        commentRepository.save(comment);

        Post post = comment.getPost();
        post.setCommentCount(Math.max(0, post.getCommentCount() - 1));
        postRepository.save(post);
    }

    // ---------------------------------------------------------------
    // GET COMMENTS FOR POST
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<CommentSummaryDTO> getCommentsForPost(Integer postId) {
        if (!postRepository.existsById(postId)) {
            throw new ResourceNotFoundException("Post not found: " + postId);
        }
        return commentRepository.findByPostId(postId)
                .stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }
    
    // ---------------------------------------------------------------
    // LIKE COMMENT
    // ---------------------------------------------------------------
    @Transactional
    public void likeComment(Integer commentId) {
        User currentUser = getAuthenticatedUser();

        Comment comment = commentRepository.findById(commentId)
            .orElseThrow(() -> new ResourceNotFoundException("Comment not found: " + commentId));

        if (comment.isDeleted()) {
            throw new ResourceNotFoundException("Comment not found: " + commentId);
        }

        CommentLikeId likeId = new CommentLikeId(currentUser.getUserId(), commentId);

        if (commentLikeRepository.existsById(likeId)) {
            throw new ResourceAlreadyExistsException("You have already liked this comment");
        }

        CommentLike like = new CommentLike();
        like.setId(likeId);
        like.setUser(currentUser);
        like.setComment(comment);
        commentLikeRepository.save(like);

        comment.setLikeCount(comment.getLikeCount() + 1);
        commentRepository.save(comment);
    }

    // ---------------------------------------------------------------
    // UNLIKE COMMENT
    // ---------------------------------------------------------------
    @Transactional
    public void unlikeComment(Integer commentId) {
        User currentUser = getAuthenticatedUser();

        Comment comment = commentRepository.findById(commentId)
            .orElseThrow(() -> new ResourceNotFoundException("Comment not found: " + commentId));

        if (comment.isDeleted()) {
            throw new ResourceNotFoundException("Comment not found: " + commentId);
        }

        CommentLikeId likeId = new CommentLikeId(currentUser.getUserId(), commentId);

        if (!commentLikeRepository.existsById(likeId)) {
            throw new ResourceNotFoundException("You have not liked this comment");
        }

        commentLikeRepository.deleteById(likeId);

        comment.setLikeCount(Math.max(0, comment.getLikeCount() - 1));
        commentRepository.save(comment);
    }

    // ---------------------------------------------------------------
    // HELPER
    // ---------------------------------------------------------------
    private CommentSummaryDTO mapToDTO(Comment comment) {
        User currentUser = getAuthenticatedUser();
        boolean liked = commentLikeRepository.existsByComment_CommentIdAndUser_UserId(
            comment.getCommentId(), currentUser.getUserId()
        );
        return new CommentSummaryDTO(
            comment.getCommentId(),
            comment.getPost().getPostId(),
            comment.getAuthor().getUsername(),
            comment.getAuthor().getUserId(),
            comment.getContentText(),
            comment.getCreatedAt(),
            comment.getGifUrl(),
            comment.getLikeCount(),
            liked
        );
    }
}