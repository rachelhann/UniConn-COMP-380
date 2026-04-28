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
	
	// ---------------------------------------------------------------
    // CREATE
    // ---------------------------------------------------------------
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
	
	// ---------------------------------------------------------------
    // EXPLORE — all communities (no auth required)
    // ---------------------------------------------------------------
    @Transactional
    public List<CommunityResponseDTO> getAllCommunities() {
        return communityRepository.findAll()
                .stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }
 
    // Explore filtered by category — e.g. /explore-communities/academics
    @Transactional
    public List<CommunityResponseDTO> getCommunitiesByCategory(String categoryParam) {
        CommunityCategory category = parseCategoryOrThrow(categoryParam);
        return communityRepository.findByCategory(category)
                .stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }
 
    // ---------------------------------------------------------------
    // MY COMMUNITIES — requires auth
    // ---------------------------------------------------------------
 
    // All communities the user has any membership in
    @Transactional
    public List<CommunityResponseDTO> getMyCommunities() {
        User currentUser = getAuthenticatedUser();
        return communityMemberRepository.findByUser_UserId(currentUser.getUserId())
                .stream()
                .map(member -> mapToResponseDTO(member.getCommunity()))
                .collect(Collectors.toList());
    }
 
    // Only communities the user created (createdBy field)
    @Transactional
    public List<CommunityResponseDTO> getCommunitiesCreatedByMe() {
        User currentUser = getAuthenticatedUser();
        return communityRepository.findByCreatedBy_UserId(currentUser.getUserId())
                .stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }
 
    // Communities where user is a member but NOT the creator
    // (REGULAR_MEMBER or MODERATOR role)
    @Transactional
    public List<CommunityResponseDTO> getCommunitiesIJoined() {
        User currentUser = getAuthenticatedUser();
        return communityMemberRepository.findByUser_UserId(currentUser.getUserId())
                .stream()
                .filter(m -> m.getRole() != CommunityMemberRole.ADMIN)
                .map(member -> mapToResponseDTO(member.getCommunity()))
                .collect(Collectors.toList());
    }
 
    // ---------------------------------------------------------------
    // HELPERS
    // ---------------------------------------------------------------
    private CommunityCategory parseCategoryOrThrow(String param) {
        // Accept both "academics" and "ACADEMICS"
        try {
            return CommunityCategory.valueOf(param.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new InvalidInputException("Unknown category: " + param +
                ". Valid values: ACADEMICS, CAREER, SOCIAL, CAMPUS_AND_EVENTS, OTHER");
        }
    }
 
    // Overload — when tag names need to be passed in explicitly (create flow)
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
 
    // Overload — reads tags directly from the entity (all other flows)
    private CommunityResponseDTO mapToResponseDTO(Community community) {
        List<String> tagNames = community.getTags().stream()
            .map(ct -> ct.getTag().getName())
            .collect(Collectors.toList());
        return mapToResponseDTO(community, tagNames);
    }
    
    @Transactional
    public CommunityResponseDTO getCommunityByName(String communityName) {
        Community community = communityRepository.findByCommunityName(communityName)
                .orElseThrow(() -> new ResourceNotFoundException("Community not found: " + communityName));
        return mapToResponseDTO(community);
    }
}
