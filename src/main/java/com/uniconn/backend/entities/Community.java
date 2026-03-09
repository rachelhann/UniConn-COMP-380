package com.uniconn.backend.entities;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import java.util.Date;

@Table(name = "community")
@Entity
public class Community {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_id", nullable = false)
    private Integer communityId;
	
	// NO spaces in communityName
	 @Column(name = "community_name", unique = true, length = 50, nullable = false)
	 private String communityName;
	 
	 @Column(name = "description", length = 500, nullable = false)
	 private String description;
	 
	 /*@Column(name = "category", length = 50)
	 private String category;*/
	 
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "created_by", referencedColumnName = "user_id", nullable = false)
	 private User createdBy;
	 
	 @Column(name = "member_count")
	 private int memberCount;
	 
	 @CreationTimestamp
	 @Column(name = "created_at", updatable = false)
	 private Date createdAt;
	 
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

	 public Date getCreatedAt() {
		 return createdAt;
	 }	 	 

}
