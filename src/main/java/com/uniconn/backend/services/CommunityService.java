package com.uniconn.backend.services;

import com.uniconn.backend.dtos.*;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.exception.*;
import com.uniconn.backend.repositories.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

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
    // CREATE COMMUNITY
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
	    community.setMemberCount(1);

	    Community saved = communityRepository.save(community);

	    List<String> tagNames = communityTagService.saveTags(saved, communityDTO.getTags());

	    communityMemberRepository.save(
	        new CommunityMember(saved, currentUser, CommunityMemberRole.ADMIN) // automatically is assigned as admin
	    );

	    currentUser.setCommunityCount(currentUser.getCommunityCount() + 1);
	    userRepository.save(currentUser);

	    return mapToResponseDTO(saved, tagNames);
	}
	
	
	// ---------------------------------------------------------------
    // UPDATE COMMUNITY - admin only
    // ---------------------------------------------------------------
	@Transactional
	public CommunityResponseDTO updateCommunity(Integer communityId, CommunityUpdateDTO dto) {
	    User currentUser = getAuthenticatedUser();

	    Community community = communityRepository.findById(communityId)
	        .orElseThrow(() -> new ResourceNotFoundException("Community not found: " + communityId));

	    boolean isAdmin = communityMemberRepository
	        .existsById_CommunityIdAndId_UserIdAndRole(
	            communityId, currentUser.getUserId(), CommunityMemberRole.ADMIN);

	    if (!isAdmin) {
	        throw new UnauthorizedException("Only the community admin can update this community");
	    }

	    if (dto.getCommunityName() != null) {
	        String normalizedName = dto.getCommunityName().toLowerCase();
	        if (!normalizedName.equals(community.getCommunityName())
	                && communityRepository.existsByCommunityNameIgnoreCase(normalizedName)) {
	            throw new ResourceAlreadyExistsException("Community name already taken: " + normalizedName);
	        }
	        community.setCommunityName(normalizedName);
	    }

	    if (dto.getDescription() != null) {
	        community.setDescription(dto.getDescription());
	    }
	    
	    if (dto.getCategory() != null) {
	        community.setCategory(dto.getCategory());
	    }

	    Community saved = communityRepository.save(community);

	    List<String> tagNames;
	    if (dto.getTags() != null) {
	        tagNames = communityTagService.updateTags(saved, dto.getTags());
	    } else {
	        tagNames = saved.getTags().stream()
	            .map(ct -> ct.getTag().getName())
	            .collect(Collectors.toList());
	    }

	    return mapToResponseDTO(saved, tagNames);
	}
	
	
	// ---------------------------------------------------------------
    // UPDATE COMMUNITY PICTURE - admin only
    // ---------------------------------------------------------------
	@Transactional
	public void updateCommunityPicture(Integer communityId, String url) {
		if(url == null || url.isBlank()) {
			throw new InvalidInputException("Image URL is required");
		}
		
		User currentUser = getAuthenticatedUser();
		
		Community community = communityRepository.findById(communityId)
		        .orElseThrow(() -> new ResourceNotFoundException("Community not found: " + communityId));

		    boolean isAdmin = communityMemberRepository
		        .existsById_CommunityIdAndId_UserIdAndRole(
		            communityId, currentUser.getUserId(), CommunityMemberRole.ADMIN);

		    if (!isAdmin) {
		        throw new UnauthorizedException("Only the community admin can update this community");
		    }
		    
		    community.setCommunityPicture(url);
		    communityRepository.save(community);
	}
	
	
	// ---------------------------------------------------------------
    // EXPLORE - all communities (no auth required)
    // ---------------------------------------------------------------
	@Transactional(readOnly = true)
	public List<CommunityResponseDTO> getAllCommunities() {
	    return communityRepository.findAllByOrderByCreatedAtDesc()
	            .stream()
	            .map(this::mapToResponseDTO)
	            .collect(Collectors.toList());
	}
 
    // Explore filtered by category - e.g. /explore-communities/academics
	@Transactional(readOnly = true)
	public List<CommunityResponseDTO> getCommunitiesByCategory(String categoryParam) {
	    CommunityCategory category = parseCategoryOrThrow(categoryParam);
	    return communityRepository.findByCategoryOrderByCreatedAtDesc(category)
	            .stream()
	            .map(this::mapToResponseDTO)
	            .collect(Collectors.toList());
	}
	
 
    // ---------------------------------------------------------------
    // MY COMMUNITIES - requires auth
    // ---------------------------------------------------------------
 
    // All communities the user has any membership in
	@Transactional(readOnly = true)
	public List<CommunityResponseDTO> getMyCommunities() {
	    User currentUser = getAuthenticatedUser();
	    Integer userId = currentUser.getUserId();
	    
	    return communityMemberRepository.findByUser_UserId(userId)
	            .stream()
	            .sorted(Comparator
	                .comparing((CommunityMember m) -> 
	                    m.getCommunity().getCreatedBy().getUserId().equals(userId) ? 0 : 1)
	                .thenComparing(CommunityMember::getJoinedAt, Comparator.reverseOrder()))
	            .map(member -> mapToResponseDTO(member.getCommunity()))
	            .collect(Collectors.toList());
	}

    @Transactional(readOnly = true)
    public List<CommunityResponseDTO> getCommunitiesByUserId(Integer userId) {
        return communityMemberRepository.findByUser_UserId(userId)
                .stream()
                .map(member -> mapToResponseDTO(member.getCommunity()))
                .collect(Collectors.toList());
    }

    // Only communities the user created (createdBy field)
	@Transactional(readOnly = true)
    public List<CommunityResponseDTO> getCommunitiesCreatedByMe() {
        User currentUser = getAuthenticatedUser();
        return communityRepository.findByCreatedBy_UserId(currentUser.getUserId())
                .stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }
 
    // Communities where user is a member but NOT the creator
    // (REGULAR_MEMBER or MODERATOR role)
	@Transactional(readOnly = true)
	public List<CommunityResponseDTO> getCommunitiesIJoined() {
	    User currentUser = getAuthenticatedUser();
	    return communityMemberRepository.findByUser_UserId(currentUser.getUserId())
	            .stream()
	            .filter(m -> m.getRole() != CommunityMemberRole.ADMIN)
	            .sorted(Comparator.comparing(CommunityMember::getJoinedAt, Comparator.reverseOrder()))
	            .map(member -> mapToResponseDTO(member.getCommunity()))
	            .collect(Collectors.toList());
	}
	
 
    // ---------------------------------------------------------------
    // TRENDING TAGS
    // ---------------------------------------------------------------
	@Transactional(readOnly = true)
	public List<String> getTrendingTags() {
        return communityTagService.getTrendingTags();
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
 
    // Overload - when tag names need to be passed in explicitly (create flow)
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
 
    // Overload - reads tags directly from the entity (all other flows)
    private CommunityResponseDTO mapToResponseDTO(Community community) {
        List<String> tagNames = community.getTags().stream()
            .map(ct -> ct.getTag().getName())
            .collect(Collectors.toList());
        return mapToResponseDTO(community, tagNames);
    }
    
    
    @Transactional(readOnly = true)
    public CommunityResponseDTO getCommunityByName(String communityName) {
        Community community = communityRepository.findByCommunityName(communityName)
                .orElseThrow(() -> new ResourceNotFoundException("Community not found: " + communityName));
        return mapToResponseDTO(community);
    }
}
