// Lillian Foster
// UniConn - COMP 380
// ProfileData.java - DTO for user profile info
// This class is just a container that holds profile data to pass between
// the service and controller. No logic here, just fields + getters/setters.

package com.uniconn.backend.dtos;

import com.uniconn.backend.entities.Post;
import java.util.List;

public class ProfileData {

    private String username;
    private String name;
    private String email;
    private String userBio;
    private String profilePicture;
    private int followerCount;
    private int followingCount;
    private int communityCount;
    private List<String> communities;
    private List<Post> posts;

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getUserBio() { return userBio; }
    public void setUserBio(String userBio) { this.userBio = userBio; }

    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }

    public int getFollowerCount() { return followerCount; }
    public void setFollowerCount(int followerCount) { this.followerCount = followerCount; }

    public int getFollowingCount() { return followingCount; }
    public void setFollowingCount(int followingCount) { this.followingCount = followingCount; }

    public int getCommunityCount() { return communityCount; }
    public void setCommunityCount(int communityCount) { this.communityCount = communityCount; }

    public List<String> getCommunities() { return communities; }
    public void setCommunities(List<String> communities) { this.communities = communities; }

    public List<Post> getPosts() { return posts; }
    public void setPosts(List<Post> posts) { this.posts = posts; }
}