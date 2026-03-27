package com.uniconn.backend.dtos;

import com.uniconn.backend.entities.Community;
import com.uniconn.backend.entities.Post;
import com.uniconn.backend.entities.User;
import java.util.List;

public class SearchResultDTO {

    private List<UserResult> users;
    private List<CommunityResult> communities;
    private List<PostResult> posts;

    public SearchResultDTO(List<UserResult> users, List<CommunityResult> communities, List<PostResult> posts) {
        this.users = users;
        this.communities = communities;
        this.posts = posts;
    }

    public List<UserResult> getUsers() { return users; }
    public List<CommunityResult> getCommunities() { return communities; }
    public List<PostResult> getPosts() { return posts; }

    // Nested DTO for User
    public static class UserResult {
        private Integer userId;
        private String username;
        private String name;
        private String userBio;
        private int followerCount;

        public UserResult(User u) {
            this.userId = u.getUserId();
            this.username = u.getUsername();
            this.name = u.getName();
            this.userBio = u.getUserBio();
            this.followerCount = u.getFollowerCount();
        }

        public Integer getUserId() { return userId; }
        public String getUsername() { return username; }
        public String getName() { return name; }
        public String getUserBio() { return userBio; }
        public int getFollowerCount() { return followerCount; }
    }

    // Nested DTO for Community
    public static class CommunityResult {
        private Integer communityId;
        private String communityName;
        private String description;
        private int memberCount;

        public CommunityResult(Community c) {
            this.communityId = c.getCommunityId();
            this.communityName = c.getCommunityName();
            this.description = c.getDescription();
            this.memberCount = c.getMemberCount();
        }

        public Integer getCommunityId() { return communityId; }
        public String getCommunityName() { return communityName; }
        public String getDescription() { return description; }
        public int getMemberCount() { return memberCount; }
    }

    // Nested DTO for Post
    public static class PostResult {
        private Integer postId;
        private String title;
        private String contentText;
        private int likeCount;
        private int commentCount;
        private String authorUsername;

        public PostResult(Post p) {
            this.postId = p.getPostId();
            this.title = p.getTitle();
            this.contentText = p.getContentText();
            this.likeCount = p.getLikeCount();
            this.commentCount = p.getCommentCount();
            this.authorUsername = p.getAuthor().getUsername();
        }

        public Integer getPostId() { return postId; }
        public String getTitle() { return title; }
        public String getContentText() { return contentText; }
        public int getLikeCount() { return likeCount; }
        public int getCommentCount() { return commentCount; }
        public String getAuthorUsername() { return authorUsername; }
    }
}