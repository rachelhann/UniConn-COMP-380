package com.uniconn.backend.dtos;

import java.util.List;
import com.uniconn.backend.validation.ValidTag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;

public class PostCreateDTO {
	private Integer communityId; // null = profile post

    @Size(max = 200, message = "Title must not exceed 200 characters")
    private String title; // required if communityId present, validated in service

    @NotBlank(message = "Content is required")
    @Size(max = 2000, message = "Content must not exceed 2000 characters")
    private String contentText;

    @Size(max = 5, message = "Maximum 5 tags allowed")
    @Valid
    private List<@NotBlank(message = "Tag cannot be blank")
                 @Size(max = 20, message = "Tag must not exceed 20 characters")
                 @ValidTag String> tags;
    
    @Pattern(regexp = "^https://media[0-9]*\\.giphy\\.com/.*$", message = "Invalid GIF URL")
    private String gifUrl;
    
    // getters & setters
	public Integer getCommunityId() {
		return communityId;
	}

	public void setCommunityId(Integer communityId) {
		this.communityId = communityId;
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

	public List<String> getTags() {
		return tags;
	}

	public void setTags(List<String> tags) {
		this.tags = tags;
	}    
	
	public String getGifUrl() {
		return gifUrl;
	}

	public void setGifUrl(String gifUrl) {
		this.gifUrl = gifUrl;
	}
	
}
