package com.uniconn.backend.dtos;

public class TrendingTagDTO {

    private String tagName;
    private long postCount;

    public TrendingTagDTO(String tagName, long postCount) {
        this.tagName = tagName;
        this.postCount = postCount;
    }

    public String getTagName()  { return tagName; }
    public long getPostCount()  { return postCount; }
}