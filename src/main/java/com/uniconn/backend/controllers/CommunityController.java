package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.*;
import com.uniconn.backend.services.CommunityService;

import jakarta.validation.Valid;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/community")
public class CommunityController {
	private final CommunityService communityService;
	
	public CommunityController(CommunityService communityService){
		this.communityService = communityService;
	}

	@PostMapping("/create")
    public ResponseEntity<CommunityResponseDTO> createCommunity(
            @Valid @RequestBody CommunityDTO communityDTO) {
        return ResponseEntity.status(201).body(communityService.createCommunity(communityDTO));
    }

	// ---------------------------------------------------------------
    // EXPLORE — no auth required
    // GET /api/community/all
    // GET /api/community/category/academics
    // ---------------------------------------------------------------
    @GetMapping("/all")
    public ResponseEntity<List<CommunityResponseDTO>> getAllCommunities() {
        return ResponseEntity.ok(communityService.getAllCommunities());
    }
 
    @GetMapping("/category/{category}")
    public ResponseEntity<List<CommunityResponseDTO>> getByCategory(
            @PathVariable String category) {
        return ResponseEntity.ok(communityService.getCommunitiesByCategory(category));
    }
 
    // ---------------------------------------------------------------
    // MY COMMUNITIES — auth required
    // GET /api/community/my-communities          -> all joined
    // GET /api/community/my-communities/created  -> created by me
    // GET /api/community/my-communities/joined   -> member of (not creator)
    // ---------------------------------------------------------------
    @GetMapping("/my-communities")
    public ResponseEntity<List<CommunityResponseDTO>> getMyCommunities() {
        return ResponseEntity.ok(communityService.getMyCommunities());
    }
 
    @GetMapping("/my-communities/created")
    public ResponseEntity<List<CommunityResponseDTO>> getCommunitiesCreatedByMe() {
        return ResponseEntity.ok(communityService.getCommunitiesCreatedByMe());
    }
 
    @GetMapping("/my-communities/joined")
    public ResponseEntity<List<CommunityResponseDTO>> getCommunitiesIJoined() {
        return ResponseEntity.ok(communityService.getCommunitiesIJoined());
    }    
    
    @GetMapping("/user/{userId}/communities")
    public ResponseEntity<List<CommunityResponseDTO>> getCommunitiesByUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(communityService.getCommunitiesByUserId(userId));
    }

    @GetMapping("/trending-tags")
    public ResponseEntity<List<String>> getTrendingTags() {
        return ResponseEntity.ok(communityService.getTrendingTags());
    }
    
    @GetMapping("/{communityName}")
    public ResponseEntity<CommunityResponseDTO> getCommunityByName(@PathVariable String communityName) {
        return ResponseEntity.ok(communityService.getCommunityByName(communityName));
    }

    @PatchMapping("/{communityId}/update")
    public ResponseEntity<CommunityResponseDTO> updateCommunity(
            @PathVariable Integer communityId,
            @RequestBody CommunityUpdateDTO request) {
        return ResponseEntity.ok(communityService.updateCommunity(communityId, request));
    }
    
    // ---------------------------------------------------------------
    // COMMUNITY PICTURE UPDATE - admin only
    // PATCH /api/community/{communityId}/picture
    // ---------------------------------------------------------------
    @PatchMapping("/{communityId}/picture")
    public ResponseEntity<CommunityResponseDTO> updateCommunityPicture(
            @PathVariable Integer communityId,
            @RequestBody Map<String, String> body) {
    	communityService.updateCommunityPicture(communityId, body.get("url"));
        return ResponseEntity.noContent().build();
    }
}
