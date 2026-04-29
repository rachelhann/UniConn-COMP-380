package com.uniconn.backend.dtos;

import java.time.LocalDateTime;
import java.util.List;
import com.uniconn.backend.entities.*;

public class CommunityResponseDTO {
	
	private Integer communityId;
    private String communityName;
    private String description;
    private int memberCount;
    private LocalDateTime createdAt;
    private Integer createdById;
    private String createdByUsername;
    private CommunityCategory category;
    private String communityPicture;
    private List<String> tags;
    
    public CommunityResponseDTO() {}
        
    public CommunityResponseDTO(Integer communityId, String communityName, String description,
            	int memberCount, LocalDateTime createdAt, Integer createdById, String createdByUsername, 
            	CommunityCategory category, String communityPicture, List<String> tags) {
    	this.communityId = communityId;
    	this.communityName = communityName;
    	this.description = description;
    	this.memberCount = memberCount;
    	this.createdAt = createdAt;
    	this.createdById = createdById;
    	this.createdByUsername = createdByUsername;
    	this.category = category;
    	this.communityPicture = communityPicture;
    	this.tags = tags;
    }

	public Integer getCommunityId() {
		return communityId;
	}

	public String getCommunityName() {
		return communityName;
	}

	public String getDescription() {
		return description;
	}

	public int getMemberCount() {
		return memberCount;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public Integer getCreatedById() {
		return createdById;
	}

	public String getCreatedByUsername() {
		return createdByUsername;
	}

	public CommunityCategory getCategory() {
		return category;
	}

	public String getCommunityPicture() {
		return communityPicture;
	}

	public List<String> getTags() {
		return tags;
	}   
    
}
