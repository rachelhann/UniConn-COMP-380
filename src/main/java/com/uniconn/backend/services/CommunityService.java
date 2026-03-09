package com.uniconn.backend.services;

import com.uniconn.backend.dtos.*;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.repositories.*;
import com.uniconn.backend.composite_keys.CommunityMemberId;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class CommunityService {
	
	private final CommunityRepository communityRepository;
	private final CommunityMemberRepository communityMemberRepository;
	
	public CommunityService(CommunityRepository communityRepository, 
			CommunityMemberRepository communityMemberRepository) {
		this.communityRepository = communityRepository;
		this.communityMemberRepository = communityMemberRepository;
	}
	
	public CommunityResponseDTO createCommunity(CommunityDTO communityDTO) {
		User currentUser = (User) SecurityContextHolder.getContext()
				.getAuthentication()
				.getPrincipal();
		if (communityRepository.existsByCommunityName(communityDTO.getCommunityName())) {
			throw new RuntimeException("Community name already taken: " + communityDTO.getCommunityName());
		}
		
		if (communityDTO.getCommunityName().contains(" ")) {
			throw new RuntimeException("Community name must not contain spaces");
		}
		
		Community community = new Community();
		community.setCommunityName(communityDTO.getCommunityName());
		community.setDescription(communityDTO.getDescription());
		community.setCreatedBy(currentUser);		
		Community saved = communityRepository.save(community);
		
		CommunityMemberId memberId = new CommunityMemberId(saved.getCommunityId(), currentUser.getUserId());
		CommunityMember member = new CommunityMember();
		member.setId(memberId);
		member.setCommunity(saved);
		member.setUser(currentUser);
		communityMemberRepository.save(member);
		
		saved.setMemberCount(1);
		communityRepository.save(saved);
		
		return mapToResponseDTO(saved);
	}
	
	private CommunityResponseDTO mapToResponseDTO(Community community) {
		return new CommunityResponseDTO(
				community.getCommunityId(),
                community.getCommunityName(),
                community.getDescription(),
                community.getMemberCount(),
                community.getCreatedAt(),
                community.getCreatedBy().getUserId(),
                community.getCreatedBy().getUsername()
			);
	}
}
