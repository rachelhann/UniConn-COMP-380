package com.uniconn.backend.events;

import org.springframework.context.ApplicationEvent;

// Domain event published whenever a new Post is created.
// Carries IDs only (not JPA entities) so listeners can run safely
// in a separate transaction or thread.
public class PostCreatedEvent extends ApplicationEvent {

    private final Integer postId;
    private final Integer communityId;   // null for profile (non-community) posts
    private final Integer authorId;

    public PostCreatedEvent(Object source, Integer postId, Integer communityId, Integer authorId) {
        super(source);
        this.postId = postId;
        this.communityId = communityId;
        this.authorId = authorId;
    }

    public Integer getPostId() {
        return postId;
    }

    public Integer getCommunityId() {
        return communityId;
    }

    public Integer getAuthorId() {
        return authorId;
    }
}
