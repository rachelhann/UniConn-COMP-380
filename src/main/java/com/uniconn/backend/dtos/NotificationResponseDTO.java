package com.uniconn.backend.dtos;

import java.time.LocalDateTime;

public class NotificationResponseDTO {
	private Integer id;
	private String type;
	private String message;
	private String actorUsername;
	private String actorProfilePicture;
	private Integer postId;
	private Integer communityId;
	private boolean isRead;
	private LocalDateTime createdAt;

	// getters & setters
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}

	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}

	public String getActorUsername() {
		return actorUsername;
	}
	public void setActorUsername(String actorUsername) {
		this.actorUsername = actorUsername;
	}

	public String getActorProfilePicture() {
		return actorProfilePicture;
	}
	public void setActorProfilePicture(String actorProfilePicture) {
		this.actorProfilePicture = actorProfilePicture;
	}

	public Integer getPostId() {
		return postId;
	}
	public void setPostId(Integer postId) {
		this.postId = postId;
	}

	public Integer getCommunityId() {
		return communityId;
	}
	public void setCommunityId(Integer communityId) {
		this.communityId = communityId;
	}

	public boolean isRead() {
		return isRead;
	}
	public void setRead(boolean isRead) {
		this.isRead = isRead;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
}
