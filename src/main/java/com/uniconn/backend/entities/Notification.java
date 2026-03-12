package com.uniconn.backend.entities;

import java.time.LocalDateTime;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import jakarta.persistence.*;

@Table(name = "notification", 
indexes = { @Index(name = "idx_recipient_id", columnList = "recipient_id") })
@Entity
public class Notification {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id",nullable = false)
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
		NEW_FOLLOWER, POST_LIKED, POST_COMMENTED, COMMENT_LIKED, NEW_COMMUNITY_MEMBER
	}
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "post_id", referencedColumnName = "post_id")
	private Post post;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "community_id", referencedColumnName = "community_id")
	private Community community;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "comment_id", referencedColumnName = "comment_id")
	private Comment comment;
	
	@Column(nullable = false)
	@ColumnDefault("false")
	private boolean isRead = false;
	
	@CreationTimestamp
	@Column(updatable = false)
	private LocalDateTime createdAt;
	
	//getters&setters
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

	public Post getPost() {
		return post;
	}

	public void setPost(Post post) {
		this.post = post;
	}

	public Community getCommunity() {
		return community;
	}

	public void setCommunity(Community community) {
		this.community = community;
	}	

	public Comment getComment() {
		return comment;
	}

	public void setComment(Comment comment) {
		this.comment = comment;
	}

	public boolean isRead() {
		return isRead;
	}

	public void setRead(boolean isRead) {
		this.isRead = isRead;
	}

	public Integer getNotificationId() {
		return notificationId;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}
		
}

