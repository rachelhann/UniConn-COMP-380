package com.uniconn.backend.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.uniconn.backend.dtos.UserSummaryDTO;
import com.uniconn.backend.services.UserFollowService;

@RestController
@RequestMapping("/api/users")
public class UserFollowController {
	private final UserFollowService userFollowService;
	
	public UserFollowController(UserFollowService userFollowService) {
		this.userFollowService = userFollowService;
	}
	
	// -------------------------------------------------------------------------------
    // FOLLOWERS POPUP - returns follower list (optionally filter with ?search=daria)
    // GET /api/users/{userId}/followers
	// -------------------------------------------------------------------------------
	@GetMapping("/{userId}/followers")
	public ResponseEntity<List<UserSummaryDTO>> getFollowers(
			@PathVariable Integer userId,
			@RequestParam(required = false) String search) {
		List<UserSummaryDTO> result = userFollowService.getFollowers(userId);
		if(search != null && !search.isBlank()) {
			String q = search.toLowerCase();
			result = result.stream()
					.filter(u -> u.getUsername().toLowerCase().contains(q)
							|| u.getName().toLowerCase().contains(q))
					.collect(Collectors.toList());
		}
		return ResponseEntity.ok(result);		
	}
	
	// --------------------------------------------------------------------------------
    // FOLLOWING POPUP - returns following list (optionally filter with ?search=daria)
    // GET /api/users/{userId}/following
	// --------------------------------------------------------------------------------
	@GetMapping("/{userId}/following")
    public ResponseEntity<List<UserSummaryDTO>> getFollowing(
            @PathVariable Integer userId,
            @RequestParam(required = false) String search) {
        List<UserSummaryDTO> result = userFollowService.getFollowing(userId);
        if (search != null && !search.isBlank()) {
            String q = search.toLowerCase();
            result = result.stream()
                    .filter(u -> u.getUsername().toLowerCase().contains(q)
                            || u.getName().toLowerCase().contains(q))
                    .collect(Collectors.toList());
        }
        return ResponseEntity.ok(result);
    }
	
	// GET /api/users/following/ids - internal use (feed filtering etc.)
	@GetMapping("/following/ids")
    public ResponseEntity<List<Integer>> getFollowingIds() {
        return ResponseEntity.ok(userFollowService.getFollowingIds());
    }
	
	// ---------------------------------------------------------------
    // FOLLOW USER 
    // POST /api/users/{userId}/follow
	// ---------------------------------------------------------------
	@PostMapping("/{userId}/follow")
    public ResponseEntity<String> followUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(userFollowService.followUser(userId));
    }
	
	// ---------------------------------------------------------------
    // UNFOLLOW USER 
    // DELETE /api/users/{userId}/unfollow
	// ---------------------------------------------------------------
	@DeleteMapping("/{userId}/unfollow")
    public ResponseEntity<String> unfollowUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(userFollowService.unfollowUser(userId));
    }

}
