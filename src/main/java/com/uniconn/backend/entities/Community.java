package com.uniconn.backend.entities;

import jakarta.persistence.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.time.LocalDateTime;
import java.util.*;

@Table(name = "community")
@Entity
public class Community {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_id",nullable = false)
    private Integer communityId;
	
	// length = 30, no special chars/spaces (nums, "." and "_" allowed)
	 @Column(unique = true, length = 30, nullable = false)
	 private String communityName;
	 
	 // length = 300 
	 @Column(length = 300, nullable = false)
	 private String description;	 
	 
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "created_by", referencedColumnName = "user_id", nullable = false)
	 private User createdBy;
	 
	 @Column(nullable = false)
	 private int memberCount = 0;
	 
	 @CreationTimestamp
	 @Column(updatable = false)
	 private LocalDateTime createdAt;
	 
	 // required
	 @Enumerated(EnumType.STRING)
	 @Column(name = "category", length = 50, nullable = false)
	 private CommunityCategory category;
	 
	 @UpdateTimestamp
	 @Column
	 private LocalDateTime updatedAt;
	 
	 @Column(name = "community_picture_path", length = 255)
	 private String communityPicture;
	 
	 // optional
	 @OneToMany(mappedBy = "community", cascade = CascadeType.ALL, orphanRemoval = true)
	 private List<CommunityTag> tags = new ArrayList<>();
	 
	//getters&setters
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


	 public User getCreatedBy() { 
		 return createdBy; 
	 }
	 
	 public void setCreatedBy(User createdBy) {
		 this.createdBy = createdBy; 
	 }

	 public int getMemberCount() {
		 return memberCount;
	 }

	 public void setMemberCount(int memberCount) {
		 this.memberCount = memberCount;
	 }

	 public Integer getCommunityId() {
		 return communityId;
	 }

	 public LocalDateTime getCreatedAt() {
		 return createdAt;
	 }

	 public CommunityCategory getCategory() {
		 return category;
	 }

	 public void setCategory(CommunityCategory category) {
		 this.category = category;
	 }

	 public String getCommunityPicture() {
		 return communityPicture;
	 }

	 public void setCommunityPicture(String communityPicture) {
		 this.communityPicture = communityPicture;
	 }

	 public List<CommunityTag> getTags() {
		 return tags;
	 }

	 public void setTags(List<CommunityTag> tags) {
		 this.tags = tags;
	 }

	 public LocalDateTime getUpdatedAt() {
		 return updatedAt;
	 }	 	 
	 
}
