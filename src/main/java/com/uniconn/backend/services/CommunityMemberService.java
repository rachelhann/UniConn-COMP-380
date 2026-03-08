package com.uniconn.backend.services;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import com.uniconn.backend.entities.Community;
import com.uniconn.backend.entities.User;
import com.uniconn.backend.entities.CommunityMember;
import com.uniconn.backend.repositories.CommunityRepository;
import com.uniconn.backend.repositories.CommunityMemberRepository;
import com.uniconn.backend.composite_keys.CommunityMemberId;

@Service
public class CommunityMemberService {
	private final CommunityMemberRepository communityMemberRepository;
	private final CommunityRepository communityRepository;
	
	public CommunityMemberService(CommunityMemberRepository communityMemberRepository, 
			CommunityRepository communityRepository) {
		this.communityMemberRepository = communityMemberRepository;
		this.communityRepository = communityRepository;
	}
	
	public String joinCommunity(Integer communityId) {
		User currentUser = (User) SecurityContextHolder.getContext()
				.getAuthentication()
				.getPrincipal();
		
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
		
		return "Joined community successfully!";
	}
	
	public String leaveCommunity(Integer communityId) {
		User currentUser = (User) SecurityContextHolder.getContext()
				.getAuthentication()
				.getPrincipal();
		
		CommunityMemberId memberId = new CommunityMemberId(communityId, currentUser.getUserId());
		
		if(!communityMemberRepository.existsById(memberId)) {
			throw new RuntimeException("You are not a member of this community");
		}
		
		communityMemberRepository.deleteById(memberId);
		
		Community community = communityRepository.findById(communityId)
				.orElseThrow(() -> new RuntimeException("Community not found"));
		community.setMemberCount(Math.max(0, community.getMemberCount() - 1));
		communityRepository.save(community);
		
		return "Left community successfully";
	}
}
