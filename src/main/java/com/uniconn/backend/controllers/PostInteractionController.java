package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.*;
import com.uniconn.backend.services.PostInteractionService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/posts")
public class PostInteractionController {

    private final PostInteractionService postInteractionService;

    public PostInteractionController(PostInteractionService postInteractionService) {
        this.postInteractionService = postInteractionService;
    }

    // POST /api/posts/{postId}/like
    @PostMapping("/{postId}/like")
    public ResponseEntity<Void> likePost(@PathVariable Integer postId) {
        postInteractionService.likePost(postId);
        return ResponseEntity.noContent().build();
    }

    // DELETE /api/posts/{postId}/like
    @DeleteMapping("/{postId}/like")
    public ResponseEntity<Void> unlikePost(@PathVariable Integer postId) {
        postInteractionService.unlikePost(postId);
        return ResponseEntity.noContent().build();
    }

    // POST /api/posts/comments
    @PostMapping("/comments")
    public ResponseEntity<CommentSummaryDTO> createComment(@RequestBody @Valid CommentCreateDTO dto) {
        return ResponseEntity.status(201).body(postInteractionService.createComment(dto));
    }

    // DELETE /api/posts/comments/{commentId}
    @DeleteMapping("/comments/{commentId}")
    public ResponseEntity<Void> deleteComment(@PathVariable Integer commentId) {
        postInteractionService.deleteComment(commentId);
        return ResponseEntity.noContent().build();
    }

    // GET /api/posts/{postId}/comments
    @GetMapping("/{postId}/comments")
    public ResponseEntity<List<CommentSummaryDTO>> getComments(@PathVariable Integer postId) {
        return ResponseEntity.ok(postInteractionService.getCommentsForPost(postId));
    }
    
    // POST /api/posts/comments/{commentId}/like
    @PostMapping("/comments/{commentId}/like")
    public ResponseEntity<Void> likeComment(@PathVariable Integer commentId) {
        postInteractionService.likeComment(commentId);
        return ResponseEntity.noContent().build();
    }

    // DELETE /api/posts/comments/{commentId}/like
    @DeleteMapping("/comments/{commentId}/like")
    public ResponseEntity<Void> unlikeComment(@PathVariable Integer commentId) {
        postInteractionService.unlikeComment(commentId);
        return ResponseEntity.noContent().build();
    }
}