package com.uniconn.backend.entities;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Date;

@Table(name = "users")
@Entity
public class User implements UserDetails {
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
	 
	 @Column(name= "user_bio", length = 150)
	 private String userBio;
	 
	 @Column(name = "profile_picture_path", length = 255)
	 private String profilePicture;
	 
	 @CreationTimestamp
	 @Column(updatable = false, name = "created_at")
	 private Date createdAt;
	 
	 @UpdateTimestamp
	 @Column(name = "updated_at")
	 private Date updatedAt;

	 @Column(name = "follower_count")
	 private int followerCount;
	 
	 @Column(name = "following_count")
	 private int followingCount;
	 
	 @Column(name = "community_count")
	 private int communityCount;
	 
	 @Column(name = "is_active", columnDefinition = "boolean default false")
	 private Boolean isActive;

	 public String getUsernameMain() {
		 return username;
	 }

	 public void setUsernameMain(String username) {
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

	 public Integer getUserId() {
		 return userId;
	 }

	 public Date getCreatedAt() {
		 return createdAt;
	 }

	 public Date getUpdatedAt() {
		 return updatedAt;
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
	 
	 	 
	 public Boolean getIsActive() {
		return isActive;
	}

	 public void setIsActive(Boolean isActive) {
		 this.isActive = isActive;
	 }

	 // most likely not needed
	 @Override
	 public Collection<? extends GrantedAuthority> getAuthorities() {
		// TODO Auto-generated method stub
		return null;
	 }

	 @Override
	 public String getUsername() {
		// TODO Auto-generated method stub
		return email;
	 }
	 
	 @Override
	 public boolean isAccountNonExpired() {
	    return true;
	 }

	 @Override
	 public boolean isAccountNonLocked() {
	    return true;
	 }

	 @Override
	 public boolean isCredentialsNonExpired() {
	    return true;
	 }

	 @Override
	 public boolean isEnabled() {
	    return true;
	 }
}
