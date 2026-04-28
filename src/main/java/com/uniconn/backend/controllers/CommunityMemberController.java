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
	public ResponseEntity<String> joinCommunity(@PathVariable Integer communityId) {
		return ResponseEntity.ok(communityMemberService.joinCommunity(communityId));
	}

	@DeleteMapping("/{communityId}/leave")
	public ResponseEntity<String> leaveCommunity(@PathVariable Integer communityId) {
		return ResponseEntity.ok(communityMemberService.leaveCommunity(communityId));
	}
}