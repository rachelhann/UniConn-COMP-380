package com.uniconn.backend.dtos;

import java.time.LocalDateTime;

public class CommunityResponseDTO {
	
	private Integer communityId;
    private String communityName;
    private String description;
    private int memberCount;
    private LocalDateTime createdAt;
    private Integer createdById;
    private String createdByUsername;
    
    public CommunityResponseDTO(Integer communityId, String communityName, String description,
            	int memberCount, LocalDateTime createdAt, Integer createdById, String createdByUsername) {
    	this.communityId = communityId;
    	this.communityName = communityName;
    	this.description = description;
    	this.memberCount = memberCount;
    	this.createdAt = createdAt;
    	this.createdById = createdById;
    	this.createdByUsername = createdByUsername;
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
    

}
