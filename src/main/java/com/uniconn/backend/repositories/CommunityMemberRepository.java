package com.uniconn.backend.repositories;

import com.uniconn.backend.entities.CommunityMember;
import com.uniconn.backend.entities.CommunityMemberRole;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.uniconn.backend.composite_keys.CommunityMemberId;

public interface CommunityMemberRepository extends JpaRepository<CommunityMember, CommunityMemberId> {
	boolean existsById(CommunityMemberId id);
	
	// Check member's role in community
	boolean existsById_CommunityIdAndId_UserIdAndRole(
		    Integer communityId, Integer userId, CommunityMemberRole role);
	
	// List of all community members
	List<CommunityMember> findByCommunity_CommunityId(Integer communityId);
	// List of all communities user is a member of
	List<CommunityMember> findByUser_UserId(Integer userId);
	
}
