package com.uniconn.backend.entities;

import java.time.LocalDateTime;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import jakarta.persistence.*;

@Table(name = "comment")
@Entity
public class Comment {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "comment_id",nullable = false)
    private Integer commentId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "post_id", referencedColumnName = "post_id", nullable = false)
	private Post post;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "author_id", referencedColumnName = "user_id", nullable = false)
	private User author;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "parent_comment_id", referencedColumnName = "comment_id")
	private Comment parentComment;
	
	@Column(length = 1000, nullable = false)
	private String contentText;
	
	@Column(nullable = false)
	@ColumnDefault("0")
	private int likeCount = 0;
	
	@CreationTimestamp
	@Column(updatable = false)
	private LocalDateTime createdAt;
	
	@Column(nullable = false)
	@ColumnDefault("false")
	private boolean isDeleted = false;
	
	//getters&setters
	public Integer getCommentId() {
		return commentId;
	}

	public void setCommentId(Integer commentId) {
		this.commentId = commentId;
	}

	public Post getPost() {
		return post;
	}

	public void setPost(Post post) {
		this.post = post;
	}

	public User getAuthor() {
		return author;
	}

	public void setAuthor(User author) {
		this.author = author;
	}

	public Comment getParentComment() {
		return parentComment;
	}

	public void setParentComment(Comment parentComment) {
		this.parentComment = parentComment;
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

	public boolean isDeleted() {
		return isDeleted;
	}

	public void setDeleted(boolean isDeleted) {
		this.isDeleted = isDeleted;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

}
