package com.uniconn.backend.dtos;

import java.time.LocalDateTime;

public class CommentSummaryDTO {

    private Integer commentId;
    private Integer postId;
    private String authorUsername;
    private Integer authorId;
    private String contentText;
    private LocalDateTime createdAt;    
    private String gifUrl;
    private int likeCount;
    private boolean likedByCurrentUser;

    public CommentSummaryDTO() {}

    public CommentSummaryDTO(Integer commentId, Integer postId,
                              String authorUsername, Integer authorId,
                              String contentText, LocalDateTime createdAt, 
                              String gifUrl, int likeCount, boolean likedByCurrentUser) {
        this.commentId = commentId;
        this.postId = postId;
        this.authorUsername = authorUsername;
        this.authorId = authorId;
        this.contentText = contentText;
        this.createdAt = createdAt;
        this.gifUrl = gifUrl;
        this.likeCount = likeCount;
        this.likedByCurrentUser = likedByCurrentUser;
    }
    
    // getters
	public Integer getCommentId() {
		return commentId;
	}

	public Integer getPostId() {
		return postId;
	}

	public String getAuthorUsername() {
		return authorUsername;
	}

	public Integer getAuthorId() {
		return authorId;
	}

	public String getContentText() {
		return contentText;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public String getGifUrl() {
		return gifUrl;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public boolean isLikedByCurrentUser() {
		return likedByCurrentUser;
	}    
	
	
	
}