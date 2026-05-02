package com.uniconn.backend.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class CommentCreateDTO {

    @NotNull(message = "Post ID is required")
    private Integer postId;

    @NotBlank(message = "Content is required")
    @Size(max = 1000, message = "Comment must not exceed 1000 characters")
    private String contentText;
    
    @Pattern(regexp = "^https://media[0-9]*\\.giphy\\.com/.*$", message = "Invalid GIF URL")
    private String gifUrl;
    
    // getters & setters
	public Integer getPostId() {
		return postId;
	}

	public void setPostId(Integer postId) {
		this.postId = postId;
	}

	public String getContentText() {
		return contentText;
	}

	public void setContentText(String contentText) {
		this.contentText = contentText;
	}

	public String getGifUrl() {
		return gifUrl;
	}

	public void setGifUrl(String gifUrl) {
		this.gifUrl = gifUrl;
	}
	
    
}