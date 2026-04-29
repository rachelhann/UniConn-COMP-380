package com.uniconn.backend.dtos;

public class CreatePostRequest {
    private String contentText;
    private String title;
    private Integer communityId;

    public String getContentText() { return contentText; }
    public void setContentText(String contentText) { this.contentText = contentText; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Integer getCommunityId() { return communityId; }
    public void setCommunityId(Integer communityId) { this.communityId = communityId; }
}
