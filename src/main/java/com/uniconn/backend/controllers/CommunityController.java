package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.CommunityDTO;
import com.uniconn.backend.dtos.CommunityResponseDTO;
import com.uniconn.backend.services.CommunityService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/community")
public class CommunityController {
	private final CommunityService communityService;
	
	private CommunityController(CommunityService communityService){
		this.communityService = communityService;
	}
	
	@PostMapping("/create")
	public ResponseEntity<?> createCommunity(@RequestBody CommunityDTO communityDTO){
		try {
			CommunityResponseDTO response = communityService.createCommunity(communityDTO);
			return ResponseEntity.ok(response);
		} catch(RuntimeException e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	}
	
	//test
	@GetMapping("/all")
	public ResponseEntity<?> getAllCommunities() {
	    try {
	        List<CommunityResponseDTO> communities = communityService.getAllCommunities();
	        return ResponseEntity.ok(communities);
	    } catch (RuntimeException e) {
	        return ResponseEntity.badRequest().body(e.getMessage());
	    }
	}
}
