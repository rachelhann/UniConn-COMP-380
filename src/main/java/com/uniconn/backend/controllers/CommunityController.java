package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.CommunityDTO;
import com.uniconn.backend.dtos.CommunityResponseDTO;
import com.uniconn.backend.services.CommunityService;

import jakarta.validation.Valid;

import java.util.List;
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

	@GetMapping("/my-communities")
	public ResponseEntity<List<CommunityResponseDTO>> getMyCommunities() {
		return ResponseEntity.ok(communityService.getMyCommunities());
	}

}
