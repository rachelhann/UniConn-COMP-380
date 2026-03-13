package com.uniconn.backend.entities;

import java.time.LocalDateTime;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import jakarta.persistence.*;

@Table(name = "post")
@Entity
public class Post {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id", nullable = false)
    private Integer postId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "author_id", referencedColumnName = "user_id", nullable = false)
	private User author;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "community_id", referencedColumnName = "community_id")
	private Community community;
	
	@Column(length = 200)
	private String title;
	
	@Column(length = 2000, nullable = false)
	private String contentText;
	
	@Column(nullable = false)
	@ColumnDefault("0")
	private int likeCount = 0;
	
	@Column(nullable = false)
	@ColumnDefault("0")
	private int commentCount = 0;
	
	@CreationTimestamp
	@Column(updatable = false)
	private LocalDateTime createdAt;
	
	@Column(nullable = false)
	@ColumnDefault("false")
	private boolean isDeleted = false;
	
	//getters&setters
	public User getAuthor() {
		return author;
	}

	public void setAuthor(User author) {
		this.author = author;
	}

	public Community getCommunity() {
		return community;
	}

	public void setCommunity(Community community) {
		this.community = community;
	}
	
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContentText() {
		return contentText;
	}

	public void setContentText(String contentText) {
		this.contentText = contentText;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}

	public int getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}

	public boolean isDeleted() {
		return isDeleted;
	}

	public void setDeleted(boolean isDeleted) {
		this.isDeleted = isDeleted;
	}

	public Integer getPostId() {
		return postId;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}
	
}
