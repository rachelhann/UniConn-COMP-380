package com.uniconn.backend.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.uniconn.backend.services.CommunityMemberService;

@RestController
@RequestMapping("/api/community")
public class CommunityMemberController {
	private final CommunityMemberService communityMemberService;
	
	public CommunityMemberController(CommunityMemberService communityMemberService) {
		this.communityMemberService = communityMemberService;
	}
	
	@PostMapping("/{communityId}/join")
	public ResponseEntity<?> joinCommunity(@PathVariable Integer communityId){
		try {
			return ResponseEntity.ok(communityMemberService.joinCommunity(communityId));
		} catch(RuntimeException e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	}
	
	@DeleteMapping("/{communityId}/leave")
	public ResponseEntity<?> leaveCommunity(@PathVariable Integer communityId){
		try {
			return ResponseEntity.ok(communityMemberService.leaveCommunity(communityId));
		} catch(RuntimeException e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	}
}
