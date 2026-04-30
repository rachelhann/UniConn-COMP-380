package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.PostSummaryDTO;
import com.uniconn.backend.services.FeedAlgorithmService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/feed")
public class FeedController {

    private final FeedAlgorithmService feedAlgorithmService;

    public FeedController(FeedAlgorithmService feedAlgorithmService) {
        this.feedAlgorithmService = feedAlgorithmService;
    }

    /**
     * GET /api/feed
     * Auto-selects Algorithm 1 or 2 based on user activity.
     * Requires JWT token.
     */
    @GetMapping
    public ResponseEntity<?> getFeed() {
        try {
            List<PostSummaryDTO> feed = feedAlgorithmService.getFeedForAuthenticatedUser();
            return ResponseEntity.ok(feed);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    /**
     * GET /api/feed/default
     * Forces Algorithm 1 — explore/discovery feed.
     * No auth required.
     */
    @GetMapping("/default/{userId}")
    public ResponseEntity<?> getDefaultFeed(@PathVariable Integer userId) {
        try {
            List<PostSummaryDTO> feed = feedAlgorithmService.getDefaultFeed(userId);
            return ResponseEntity.ok(feed);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
