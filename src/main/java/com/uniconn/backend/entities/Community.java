package com.uniconn.backend.entities;

import jakarta.persistence.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Table(name = "community")
@Entity
public class Community {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_id",nullable = false)
    private Integer communityId;
	
	// NO spaces in communityName
	 @Column(unique = true, length = 50, nullable = false)
	 private String communityName;
	 
	 @Column(length = 500, nullable = false)
	 private String description;
	 
	 /*@Column(name = "category", length = 50)
	 private String category;*/
	 
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "created_by", referencedColumnName = "user_id", nullable = false)
	 private User createdBy;
	 
	 @Column(nullable = false)
	 @ColumnDefault("0")
	 private int memberCount = 0;
	 
	 @CreationTimestamp
	 @Column(updatable = false)
	 private LocalDateTime createdAt;
	 
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

}
