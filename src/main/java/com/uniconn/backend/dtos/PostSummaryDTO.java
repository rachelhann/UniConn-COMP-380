package com.uniconn.backend.dtos;

import java.time.LocalDateTime;
import java.util.List;

public class PostSummaryDTO {
    private Integer postId;
    private String authorUsername;
    private Integer authorId;
    private String communityName;
    private Integer communityId;
    private String title;
    private String contentText;
    private int likeCount;
    private int commentCount;
    private LocalDateTime createdAt;
    private List<String> tags;
    private boolean isLikedByCurrentUser;
    private boolean canDelete;
    
    private String gifUrl;

    public PostSummaryDTO() {}

    public PostSummaryDTO(Integer postId, String authorUsername, Integer authorId,
                          String communityName, Integer communityId,
                          String title, String contentText,
                          int likeCount, int commentCount,
                          LocalDateTime createdAt, List<String> tags,
                          boolean isLikedByCurrentUser, boolean canDelete, String gifUrl) {
        this.postId = postId;
        this.authorUsername = authorUsername;
        this.authorId = authorId;
        this.communityName = communityName;
        this.communityId = communityId;
        this.title = title;
        this.contentText = contentText;
        this.likeCount = likeCount;
        this.commentCount = commentCount;
        this.createdAt = createdAt;
        this.tags = tags;
        this.isLikedByCurrentUser = isLikedByCurrentUser;
        this.canDelete = canDelete;
        this.gifUrl = gifUrl;
    }
    
    // getters
	public Integer getPostId() {
		return postId;
	}

	public String getAuthorUsername() {
		return authorUsername;
	}

	public Integer getAuthorId() {
		return authorId;
	}

	public String getCommunityName() {
		return communityName;
	}

	public Integer getCommunityId() {
		return communityId;
	}

	public String getTitle() {
		return title;
	}

	public String getContentText() {
		return contentText;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public int getCommentCount() {
		return commentCount;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public List<String> getTags() {
		return tags;
	}

	public boolean isLikedByCurrentUser() {
		return isLikedByCurrentUser;
	}

	public boolean isCanDelete() {
		return canDelete;
	}
	
	public String getGifUrl() {
		return gifUrl;
	} 
    
}