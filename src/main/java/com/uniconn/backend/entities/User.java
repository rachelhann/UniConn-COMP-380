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
    @Column(nullable = false)
    private Integer id;
	
	 @Column(unique = true, length = 30, nullable = false)
	 private String username;
	 
	 @Column(length = 30)
	 private String name;
	 
	 @Column(unique = true, length = 100, nullable = false)
	 private String email;
	 
	 @Column(nullable = false)
	 private String password;
	 
	 @Column(length = 150)
	 private String bio;
	 
	 @Column(name = "profile_picture_path", length = 255)
	 private String profilePicture;
	 
	 @CreationTimestamp
	 @Column(updatable = false, name = "created_at")
	 private Date createdAt;
	 
	 @UpdateTimestamp
	 @Column(name = "updated_at")
	 private Date updatedAt;

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

	 public String getBio() {
		 return bio;
	 }

	 public void setBio(String bio) {
		 this.bio = bio;
	 }

	 public String getProfilePicture() {
		 return profilePicture;
	 }

	 public void setProfilePicture(String profilePicture) {
		 this.profilePicture = profilePicture;
	 }

	 public Integer getId() {
		 return id;
	 }

	 public Date getCreatedAt() {
		 return createdAt;
	 }

	 public Date getUpdatedAt() {
		 return updatedAt;
	 }

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
