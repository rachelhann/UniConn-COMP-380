package com.uniconn.backend.entities;

import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;
import com.uniconn.backend.composite_keys.CommentLikeId;
import jakarta.persistence.*;

@Table(name = "comment_like")
@Entity
public class CommentLike {
	@EmbeddedId
	private CommentLikeId id;
	
	@ManyToOne
	@MapsId("userId")
	@JoinColumn(name = "user_id")
	private User user;
	
	@ManyToOne
	@MapsId("commentId")
	@JoinColumn(name = "comment_id")
	private Comment comment;
	
	@CreationTimestamp
	@Column(updatable = false)
	private LocalDateTime createdAt;
	
	public CommentLike () {}

	public CommentLikeId getId() {
		return id;
	}

	public void setId(CommentLikeId id) {
		this.id = id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Comment getComment() {
		return comment;
	}

	public void setComment(Comment comment) {
		this.comment = comment;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}	
	
}
