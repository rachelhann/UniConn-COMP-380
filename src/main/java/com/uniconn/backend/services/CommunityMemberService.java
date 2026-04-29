package com.uniconn.backend.services;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.exception.*;
import com.uniconn.backend.repositories.*;
import org.springframework.transaction.annotation.Transactional;
import com.uniconn.backend.composite_keys.CommunityMemberId;

@Service
public class CommunityMemberService extends BaseService {
	private final CommunityMemberRepository communityMemberRepository;
	private final CommunityRepository communityRepository;
	
	public CommunityMemberService(CommunityMemberRepository communityMemberRepository,
            CommunityRepository communityRepository) {
        this.communityMemberRepository = communityMemberRepository;
        this.communityRepository = communityRepository;
    }
	
	@Transactional
	public String joinCommunity(Integer communityId) {
	    User currentUser = getAuthenticatedUser();

	    Community community = communityRepository.findById(communityId)
	            .orElseThrow(() -> new ResourceNotFoundException("Community with id " + communityId + " not found"));

	    CommunityMemberId memberId = new CommunityMemberId(communityId, currentUser.getUserId());

	    if (communityMemberRepository.existsById(memberId)) {
	        throw new ResourceAlreadyExistsException("You are already a member of this community");
	    }

	    communityMemberRepository.save(new CommunityMember(community, currentUser, CommunityMemberRole.REGULAR_MEMBER));
        adjustMembershipCounts(community, currentUser, +1);

        return "Joined community successfully";
	}

	@Transactional
    public String leaveCommunity(Integer communityId) {
        User currentUser = getAuthenticatedUser();

        CommunityMemberId memberId = new CommunityMemberId(communityId, currentUser.getUserId());

        CommunityMember member = communityMemberRepository.findById(memberId)
                .orElseThrow(() -> new ResourceNotFoundException("You are not a member of this community"));

        if (member.getRole() == CommunityMemberRole.ADMIN) {
            throw new UnauthorizedException("Admins cannot leave their own community");
        }

        Community community = member.getCommunity();
        communityMemberRepository.delete(member);
        adjustMembershipCounts(community, currentUser, -1);

        return "Left community successfully";
    }

    private void adjustMembershipCounts(Community community, User user, int delta) {
        community.setMemberCount(Math.max(0, community.getMemberCount() + delta));
        communityRepository.save(community);

        user.setCommunityCount(Math.max(0, user.getCommunityCount() + delta));
        userRepository.save(user); // inherited from BaseService
    }
}