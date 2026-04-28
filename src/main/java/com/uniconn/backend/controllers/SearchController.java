package com.uniconn.backend.controllers;

import com.uniconn.backend.services.SearchService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/search")
public class SearchController {

    private final SearchService searchService;

    public SearchController(SearchService searchService) {
        this.searchService = searchService;
    }

    // --- General Search ---
    @GetMapping
    public ResponseEntity<?> search(@RequestParam String q) {
        try {
            return ResponseEntity.ok(searchService.search(q));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- Explore Communities Search ---
    @GetMapping("/communities")
    public ResponseEntity<?> searchCommunities(@RequestParam String q) {
        try {
            return ResponseEntity.ok(searchService.searchCommunitiesForExplore(q));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- My Communities Search ---
    @GetMapping("/my-communities")
    public ResponseEntity<?> searchMyCommunities(@RequestParam String q) {
        try {
            return ResponseEntity.ok(searchService.searchMyCommunities(q));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- Following Search ---
    @GetMapping("/following")
    public ResponseEntity<?> searchFollowing(@RequestParam String q) {
        try {
            return ResponseEntity.ok(searchService.searchFollowing(q));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- Followers Search ---
    @GetMapping("/followers")
    public ResponseEntity<?> searchFollowers(@RequestParam String q) {
        try {
            return ResponseEntity.ok(searchService.searchFollowers(q));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- Community Members Search ---
    @GetMapping("/community/{communityId}/members")
    public ResponseEntity<?> searchCommunityMembers(
            @PathVariable Integer communityId,
            @RequestParam String q) {
        try {
            return ResponseEntity.ok(searchService.searchCommunityMembers(communityId, q));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- Tag Search ---
    @GetMapping("/tags")
    public ResponseEntity<?> searchTags(@RequestParam String q) {
        try {
            return ResponseEntity.ok(searchService.searchTags(q));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- Communities by Tag ---
    @GetMapping("/tags/communities")
    public ResponseEntity<?> searchCommunitiesByTag(@RequestParam String q) {
        try {
            return ResponseEntity.ok(searchService.searchCommunitiesByTag(q));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- Posts by Tag ---
    @GetMapping("/tags/posts")
    public ResponseEntity<?> searchPostsByTag(@RequestParam String q) {
        try {
            return ResponseEntity.ok(searchService.searchPostsByTag(q));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}