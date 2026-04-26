package com.uniconn.backend.controllers;

import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.uniconn.backend.services.UserFollowService;

@RestController
@RequestMapping("/api/user")
public class UserFollowController {
	private final UserFollowService userFollowService;
	
	private UserFollowController(UserFollowService userFollowService) {
		this.userFollowService = userFollowService;
	}
	
	@GetMapping("/following/ids")
	public ResponseEntity<List<Integer>> getFollowingIds() {
		return ResponseEntity.ok(userFollowService.getFollowingIds());
	}

	@PostMapping("/{userId}/follow")
	public ResponseEntity<?> followUser(@PathVariable Integer userId){
		try {
			return ResponseEntity.ok(userFollowService.followUser(userId));
		} catch(RuntimeException e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	}
	
	@DeleteMapping("/{userId}/unfollow")
	public ResponseEntity<?> unfollowUser(@PathVariable Integer userId){
		try {
			return ResponseEntity.ok(userFollowService.unfollowUser(userId));
		} catch(RuntimeException e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	}

}
