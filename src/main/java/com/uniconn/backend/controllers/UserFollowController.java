package com.uniconn.backend.controllers;

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
