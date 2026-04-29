// Lillian Foster
// UniConn - COMP 380
// ProfileData.java - DTO (Data Transfer Object) for user profile info
// This class is just a container that holds profile data to pass between
// the service and controller. No logic here, just fields + getters/setters.

package com.uniconn.backend.dtos;

public class ProfileData {

    // These fields match exactly what's in the User entity
    private Integer userId;
    private String username;
    private String name;       // display name (not the same as username)
    private String email;
    private String userBio;    // short bio the user writes about themselves
    private String profilePicture; // stores the file path to their profile pic
    private int followerCount;
    private int followingCount;
    private int communityCount; // how many communities they've joined

    // --- Getters (used to READ the values) ---

    public Integer getUserId() { return userId; }

    public String getUsername() { return username; }

    public String getName() { return name; }

    public String getEmail() { return email; }

    public String getUserBio() { return userBio; }

    public String getProfilePicture() { return profilePicture; }

    public int getFollowerCount() { return followerCount; }

    public int getFollowingCount() { return followingCount; }

    public int getCommunityCount() { return communityCount; }

    // --- Setters (used to SET/update the values) ---

    public void setUserId(Integer userId) { this.userId = userId; }

    public void setUsername(String username) { this.username = username; }

    public void setName(String name) { this.name = name; }

    public void setEmail(String email) { this.email = email; }

    public void setUserBio(String userBio) { this.userBio = userBio; }

    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }

    public void setFollowerCount(int followerCount) { this.followerCount = followerCount; }

    public void setFollowingCount(int followingCount) { this.followingCount = followingCount; }

    public void setCommunityCount(int communityCount) { this.communityCount = communityCount; }
}