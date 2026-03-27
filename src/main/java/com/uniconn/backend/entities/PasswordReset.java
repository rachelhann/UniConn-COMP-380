package com.uniconn.backend.entities;

import jakarta.persistence.*;

@Table(name = "password_reset")
@Entity
public class PasswordReset {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "password_reset_id", nullable = false)
    private Integer passwordResetId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(referencedColumnName = "user_id", nullable = false)
	private User userId;
	
	@Column(nullable = false)  
	private Integer questionId;
	
	// hashed answer
	@Column(nullable = false)  
	private String answer;
	
	// getters&setters
	public User getUserId() {
		return userId;
	}

	public void setUserId(User userId) {
		this.userId = userId;
	}

	public Integer getQuestionId() {
		return questionId;
	}

	public void setQuestionId(Integer questionId) {
		this.questionId = questionId;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public Integer getPasswordResetId() {
		return passwordResetId;
	}
	
	
}
