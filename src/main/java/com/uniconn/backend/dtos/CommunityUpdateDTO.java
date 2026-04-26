package com.uniconn.backend.dtos;

import java.util.List;

import com.uniconn.backend.entities.CommunityCategory;
import com.uniconn.backend.validation.ValidTag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;

public class CommunityUpdateDTO {
	@Size(max = 30, message = "Name must not exceed 30 characters")
    @Pattern(
        regexp = "^[a-z0-9._]+$",
        message = "Only lowercase letters, digits, dots, and underscores are allowed"
    )
    @NotBlank(message = "Community name cannot be blank")
    private String communityName;

    @NotBlank(message = "Description cannot be blank")
    @Size(max = 300, message = "Description must not exceed 300 characters")
    private String description;

    @NotBlank(message = "Community picture cannot be blank")
    private String communityPicture;
    
    @NotNull(message = "Category is required")
    private CommunityCategory category;

    @Size(max = 5, message = "Maximum 5 tags allowed")
    @Valid
    private List<@NotBlank(message = "Tag cannot be blank")
                 @Size(max = 20, message = "Tag must not exceed 20 characters")
                 @ValidTag String> tags;
    
    // getters & setters
	public String getCommunityName() {
		return communityName;
	}

	public void setCommunityName(String communityName) {
		this.communityName = communityName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getCommunityPicture() {
		return communityPicture;
	}

	public void setCommunityPicture(String communityPicture) {
		this.communityPicture = communityPicture;
	}

	public CommunityCategory getCategory() {
		return category;
	}

	public void setCategory(CommunityCategory category) {
		this.category = category;
	}

	public List<String> getTags() {
		return tags;
	}

	public void setTags(List<String> tags) {
		this.tags = tags;
	}    
    
}
