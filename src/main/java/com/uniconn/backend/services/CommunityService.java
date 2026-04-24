package com.uniconn.backend.services;

import com.uniconn.backend.dtos.*;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.exception.*;
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
	private final CommunityTagService communityTagService;
	
	public CommunityService(CommunityRepository communityRepository, 
			CommunityMemberRepository communityMemberRepository, CommunityTagService communityTagService) {
		this.communityRepository = communityRepository;
		this.communityMemberRepository = communityMemberRepository;
		this.communityTagService = communityTagService;
	}
	
	@Transactional
	public CommunityResponseDTO createCommunity(CommunityDTO communityDTO) {
	    User currentUser = getAuthenticatedUser();
	    String normalizedName = communityDTO.getCommunityName().toLowerCase();

	    if (communityRepository.existsByCommunityNameIgnoreCase(normalizedName)) {
	        throw new ResourceAlreadyExistsException("Community name already taken: " + normalizedName);
	    }

	    Community community = new Community();
	    community.setCommunityName(normalizedName);
	    community.setDescription(communityDTO.getDescription());
	    community.setCreatedBy(currentUser);
	    community.setCategory(communityDTO.getCategory());
	    community.setCommunityPicture(communityDTO.getCommunityPicture());
	    community.setMemberCount(1);

	    Community saved = communityRepository.save(community);

	    List<String> tagNames = communityTagService.saveTags(saved, communityDTO.getTags());

	    communityMemberRepository.save(
	        new CommunityMember(saved, currentUser, CommunityMemberRole.ADMIN)
	    );

	    currentUser.setCommunityCount(currentUser.getCommunityCount() + 1);
	    userRepository.save(currentUser);

	    return mapToResponseDTO(saved, tagNames);
	}
	
	@Transactional
	public List<CommunityResponseDTO> getMyCommunities() {
		User currentUser = getAuthenticatedUser();
		return communityMemberRepository.findByUser_UserId(currentUser.getUserId())
			.stream()
			.map(member -> {
				Community c = member.getCommunity();
				List<String> tagNames = c.getTags().stream()
					.map(ct -> ct.getTag().getName())
					.collect(Collectors.toList());
				return mapToResponseDTO(c, tagNames);
			})
			.collect(Collectors.toList());
	}

	private CommunityResponseDTO mapToResponseDTO(Community community, List<String> tagNames) {
	    return new CommunityResponseDTO(
	        community.getCommunityId(),
	        community.getCommunityName(),
	        community.getDescription(),
	        community.getMemberCount(),
	        community.getCreatedAt(),
	        community.getCreatedBy().getUserId(),
	        community.getCreatedBy().getUsername(),
	        community.getCategory(),
	        community.getCommunityPicture(),
	        tagNames
	    );
	}
	
}
