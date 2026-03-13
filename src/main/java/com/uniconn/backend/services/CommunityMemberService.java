package com.uniconn.backend.services;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.repositories.*;
import jakarta.transaction.Transactional;
import com.uniconn.backend.composite_keys.CommunityMemberId;

@Service
public class CommunityMemberService extends BaseService {
	private final CommunityMemberRepository communityMemberRepository;
	private final CommunityRepository communityRepository;
	private final UserRepository userRepository;
	
	public CommunityMemberService(CommunityMemberRepository communityMemberRepository, 
			CommunityRepository communityRepository, UserRepository userRepository) {
		this.communityMemberRepository = communityMemberRepository;
		this.communityRepository = communityRepository;
		this.userRepository = userRepository;
	}
	
	@Transactional
	public String joinCommunity(Integer communityId) {
		User currentUser = getAuthenticatedUser();
		
		Community community = communityRepository.findById(communityId)
				.orElseThrow(() -> new RuntimeException("Community not found"));
		
		CommunityMemberId memberId = new CommunityMemberId(communityId, currentUser.getUserId());
	
		if (communityMemberRepository.existsById(memberId)) {
            throw new RuntimeException("Already a member of this community");
        }
		
		CommunityMember member = new CommunityMember();
		member.setId(memberId);
		member.setCommunity(community);
		member.setUser(currentUser);
		communityMemberRepository.save(member);
		
		community.setMemberCount(community.getMemberCount() + 1);
		communityRepository.save(community);
		
		currentUser.setCommunityCount(currentUser.getCommunityCount() + 1);
		userRepository.save(currentUser);
				
		return "Joined community successfully!";
	}
	
	@Transactional
	public String leaveCommunity(Integer communityId) {
		User currentUser = getAuthenticatedUser();
		
		CommunityMemberId memberId = new CommunityMemberId(communityId, currentUser.getUserId());
		
		if(!communityMemberRepository.existsById(memberId)) {
			throw new RuntimeException("You are not a member of this community");
		}
		
		communityMemberRepository.deleteById(memberId);
		
		Community community = communityRepository.findById(communityId)
				.orElseThrow(() -> new RuntimeException("Community not found"));
		community.setMemberCount(Math.max(0, community.getMemberCount() - 1));
		communityRepository.save(community);
		
		currentUser.setCommunityCount(Math.max(0, currentUser.getCommunityCount() - 1));
		userRepository.save(currentUser);
		
		return "Left community successfully";
	}
}
