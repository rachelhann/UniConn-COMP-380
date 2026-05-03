package com.uniconn.backend.entities;

import java.time.LocalDateTime;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import jakarta.persistence.*;

@Table(name = "notification")
@Entity
public class Notification {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "notification_id", nullable = false)
	private Integer notificationId;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "recipient_id", referencedColumnName = "user_id", nullable = false)
	private User recipient;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "sender_id", referencedColumnName = "user_id")
	private User sender;

	@Enumerated(EnumType.STRING)
	@Column(nullable = false)
	private NotificationType type;

	public enum NotificationType {
		FOLLOW, LIKE, COMMENT, USER_JOINED_COMMUNITY
	}

	@Column(name = "post_id")
	private Integer postId;

	@Column(name = "comment_id")
	private Integer commentId;

	@Column(name = "community_id")
	private Integer communityId;

	@Column(nullable = false, length = 255)
	private String message;

	@Column(nullable = false)
	@ColumnDefault("false")
	private boolean isRead = false;

	@CreationTimestamp
	@Column(updatable = false)
	private LocalDateTime createdAt;

	// getters & setters
	public Integer getNotificationId() {
		return notificationId;
	}

	public User getRecipient() {
		return recipient;
	}

	public void setRecipient(User recipient) {
		this.recipient = recipient;
	}

	public User getSender() {
		return sender;
	}

	public void setSender(User sender) {
		this.sender = sender;
	}

	public NotificationType getType() {
		return type;
	}

	public void setType(NotificationType type) {
		this.type = type;
	}

	public Integer getPostId() {
		return postId;
	}

	public void setPostId(Integer postId) {
		this.postId = postId;
	}

	public Integer getCommentId() {
		return commentId;
	}

	public void setCommentId(Integer commentId) {
		this.commentId = commentId;
	}

	public Integer getCommunityId() {
		return communityId;
	}

	public void setCommunityId(Integer communityId) {
		this.communityId = communityId;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
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
}
