package com.uniconn.backend.entities;

import jakarta.persistence.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import java.time.LocalDateTime;
import java.util.Collection;

@Table(name = "users")
@Entity
public class User {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id", nullable = false)
    private Integer userId;
	
	 @Column(unique = true, length = 30, nullable = false)
	 private String username;
	 
	 @Column(length = 30)
	 private String name;
	 
	 @Column(unique = true, length = 100, nullable = false)
	 private String email;
	 
	 @Column(nullable = false)
	 private String password;
	 
	 @Column(length = 150)
	 private String userBio;
	 
	 @Column(name = "profile_picture_path", length = 255)
	 private String profilePicture;
	 
	 @CreationTimestamp
	 @Column(updatable = false)
	 private LocalDateTime createdAt;
	 
	 @UpdateTimestamp
	 @Column
	 private LocalDateTime updatedAt;

	 @Column(nullable = false)
	 @ColumnDefault("0")
	 private int followerCount = 0;
	 
	 @Column(nullable = false)
	 @ColumnDefault("0")
	 private int followingCount = 0;
	 
	 @Column(nullable = false)
	 @ColumnDefault("0")
	 private int communityCount = 0;
	 
	 @Column(nullable = false)
	 @ColumnDefault("false")
	 private boolean isActive = false;
	 
	//getters&setters
	 public Integer getUserId() {
		 return userId;
	 }
	 
	 public String getUsername() {
		 return username;
	 }

	 public void setUsername(String username) {
		 this.username = username;
	 }

	 public String getName() {
		 return name;
	 }

	 public void setName(String name) {
		 this.name = name;
	 }

	 public String getEmail() {
		 return email;
	 }

	 public void setEmail(String email) {
		 this.email = email;
	 }

	 public String getPassword() {
		 return password;
	 }

	 public void setPassword(String password) {
		 this.password = password;
	 }

	 public String getUserBio() {
		 return userBio;
	 }

	 public void setUserBio(String userBio) {
		 this.userBio = userBio;
	 }

	 public String getProfilePicture() {
		 return profilePicture;
	 }

	 public void setProfilePicture(String profilePicture) {
		 this.profilePicture = profilePicture;
	 }

	 public LocalDateTime getCreatedAt() {
		 return createdAt;
	 }

	 public LocalDateTime getUpdatedAt() {
		 return updatedAt;
	 }
	 
	 public int getFollowerCount() {
		 return followerCount;
	 }

	 public void setFollowerCount(int followerCount) {
		 this.followerCount = followerCount;
	 }

	 public int getFollowingCount() {
		 return followingCount;
	 }

	 public void setFollowingCount(int followingCount) {
		 this.followingCount = followingCount;
	 }

	 public int getCommunityCount() {
		 return communityCount;
	 }

	 public void setCommunityCount(int communityCount) {
		 this.communityCount = communityCount;
	 }

	 public boolean isActive() {
		 return isActive;
	 }

	 public void setActive(boolean isActive) {
		 this.isActive = isActive;
	 }

}
