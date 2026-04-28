package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.*;
import com.uniconn.backend.services.PostService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/posts")
public class PostController {

    private final PostService postService;

    public PostController(PostService postService) {
        this.postService = postService;
    }

    // ---------------------------------------------------------------
    // GET /api/posts/feed/{userId}
    // User feed: posts from followed users + member communities
    // ---------------------------------------------------------------
    @GetMapping("/feed/{userId}")
    public ResponseEntity<List<PostSummaryDTO>> getFeed(@PathVariable Integer userId) {
        return ResponseEntity.ok(postService.getFeedForUser(userId));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/trending
    // Trending tags (last 30 days, ordered by post count desc)
    // ---------------------------------------------------------------
    @GetMapping("/trending")
    public ResponseEntity<List<TrendingTagDTO>> getTrendingTags() {
        return ResponseEntity.ok(postService.getTrendingTags());
    }

    // ---------------------------------------------------------------
    // GET /api/posts/tag/{tagName}
    // All posts for an exact tag — for tag-click from trending or tag page
    // ---------------------------------------------------------------
    @GetMapping("/tag/{tagName}")
    public ResponseEntity<List<PostSummaryDTO>> getPostsByTag(@PathVariable String tagName) {
        return ResponseEntity.ok(postService.getPostsByTag(tagName));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/search?q=python
    // Search posts by tag name (contains match, case-insensitive)
    // ---------------------------------------------------------------
    @GetMapping("/search")
    public ResponseEntity<List<PostSummaryDTO>> searchByTag(@RequestParam String q) {
        if (q == null || q.isBlank()) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(postService.searchPostsByTag(q));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/profile/{userId}
    // Profile posts (Twitter-style, no community) authored by a user
    // ---------------------------------------------------------------
    @GetMapping("/profile/{userId}")
    public ResponseEntity<List<PostSummaryDTO>> getProfilePosts(@PathVariable Integer userId) {
        return ResponseEntity.ok(postService.getProfilePosts(userId));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/user/{userId}/community
    // Posts a user authored inside communities
    // ---------------------------------------------------------------
    @GetMapping("/user/{userId}/community")
    public ResponseEntity<List<PostSummaryDTO>> getCommunityPostsByUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(postService.getCommunityPostsByUser(userId));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/community/{communityId}
    // All posts inside a specific community
    // ---------------------------------------------------------------
    @GetMapping("/community/{communityId}")
    public ResponseEntity<List<PostSummaryDTO>> getPostsByCommunity(@PathVariable Integer communityId) {
        return ResponseEntity.ok(postService.getPostsByCommunity(communityId));
    }
}