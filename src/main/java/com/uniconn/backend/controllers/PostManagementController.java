package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.*;
import com.uniconn.backend.services.PostManagementService;

import jakarta.validation.Valid;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/posts")
public class PostManagementController {
    private final PostManagementService postManagementService;

    public PostManagementController(PostManagementService postManagementService) {
        this.postManagementService = postManagementService;
    }

    // ---------------------------------------------------------------
    // POST /api/posts
    // Create a post (community or profile)
    // ---------------------------------------------------------------
    @PostMapping
    public ResponseEntity<PostSummaryDTO> createPost(@RequestBody @Valid PostCreateDTO dto) {
        return ResponseEntity.status(201).body(postManagementService.createPost(dto));
    }

    // ---------------------------------------------------------------
    // DELETE /api/posts/{postId}
    // Soft delete - author always, community admin if community post
    // ---------------------------------------------------------------
    @DeleteMapping("/{postId}")
    public ResponseEntity<Void> deletePost(@PathVariable Integer postId) {
        postManagementService.deletePost(postId);
        return ResponseEntity.noContent().build();
    }
    
    // GET /api/posts/{postId}
    // Fetch a single post by ID (used to refresh modal state)
    @GetMapping("/{postId}")
    public ResponseEntity<PostSummaryDTO> getPost(@PathVariable Integer postId) {
    	return ResponseEntity.ok(postManagementService.getPost(postId));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/feed/{userId}
    // User feed: posts from followed users + member communities
    // ---------------------------------------------------------------
    @GetMapping("/feed/{userId}")
    public ResponseEntity<List<PostSummaryDTO>> getFeed(@PathVariable Integer userId) {
        return ResponseEntity.ok(postManagementService.getFeedForUser(userId));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/trending
    // Trending tags (last 30 days, ordered by post count desc)
    // ---------------------------------------------------------------
    @GetMapping("/trending")
    public ResponseEntity<List<TrendingTagDTO>> getTrendingTags() {
        return ResponseEntity.ok(postManagementService.getTrendingTags());
    }

    // ---------------------------------------------------------------
    // GET /api/posts/tag/{tagName}
    // All posts for an exact tag - for tag-click from trending or tag page
    // ---------------------------------------------------------------
    @GetMapping("/tag/{tagName}")
    public ResponseEntity<List<PostSummaryDTO>> getPostsByTag(@PathVariable String tagName) {
        return ResponseEntity.ok(postManagementService.getPostsByTag(tagName));
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
        return ResponseEntity.ok(postManagementService.searchPostsByTag(q));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/profile/{userId}
    // Profile posts (Twitter-style, no community) authored by a user
    // ---------------------------------------------------------------
    @GetMapping("/profile/{userId}")
    public ResponseEntity<List<PostSummaryDTO>> getProfilePosts(@PathVariable Integer userId) {
        return ResponseEntity.ok(postManagementService.getProfilePosts(userId));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/profile/by-username/{username}
    // Profile posts for any user by username (for viewing other profiles)
    // ---------------------------------------------------------------
    @GetMapping("/profile/by-username/{username}")
    public ResponseEntity<List<PostSummaryDTO>> getProfilePostsByUsername(@PathVariable String username) {
        return ResponseEntity.ok(postManagementService.getProfilePostsByUsername(username));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/user/{userId}/community
    // Posts a user authored inside communities
    // ---------------------------------------------------------------
    @GetMapping("/user/{userId}/community")
    public ResponseEntity<List<PostSummaryDTO>> getCommunityPostsByUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(postManagementService.getCommunityPostsByUser(userId));
    }
    
    // GET /api/posts/liked-by/{userId}
    // Posts user liked
    @GetMapping("/liked-by/{userId}")
    public ResponseEntity<List<PostSummaryDTO>> getPostsLikedByUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(postManagementService.getPostsLikedByUser(userId));
    }

    // ---------------------------------------------------------------
    // GET /api/posts/community/{communityId}
    // All posts inside a specific community
    // ---------------------------------------------------------------
    @GetMapping("/community/{communityId}")
    public ResponseEntity<List<PostSummaryDTO>> getPostsByCommunity(@PathVariable Integer communityId) {
        return ResponseEntity.ok(postManagementService.getPostsByCommunity(communityId));
    }
}