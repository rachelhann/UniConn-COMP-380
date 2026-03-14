package com.uniconn.backend.services;

import com.uniconn.backend.dtos.*;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.repositories.*;
import jakarta.transaction.Transactional;
import com.uniconn.backend.composite_keys.CommunityMemberId;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class CommunityService extends BaseService {
	
	private final CommunityRepository communityRepository;
	private final CommunityMemberRepository communityMemberRepository;
	
	public CommunityService(CommunityRepository communityRepository, 
			CommunityMemberRepository communityMemberRepository) {
		this.communityRepository = communityRepository;
		this.communityMemberRepository = communityMemberRepository;
	}
	
	@Transactional
	public CommunityResponseDTO createCommunity(CommunityDTO communityDTO) {
		User currentUser = getAuthenticatedUser();
		
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
		
		currentUser.setCommunityCount(currentUser.getCommunityCount() + 1);
		userRepository.save(currentUser);
		
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
	
	// test
	@Transactional
	public List<CommunityResponseDTO> getAllCommunities() {
	    return communityRepository.findAll()
	        .stream()
	        .map(community -> new CommunityResponseDTO(community.getCommunityId(),
	                community.getCommunityName(),
	                community.getDescription(),
	                community.getMemberCount(),
	                community.getCreatedAt(),
	                community.getCreatedBy().getUserId(),
	                community.getCreatedBy().getUsername()
	                ))
	        .collect(Collectors.toList());
	}
}
