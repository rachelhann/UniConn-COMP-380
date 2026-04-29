package com.uniconn.backend.services;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import com.uniconn.backend.composite_keys.UserFollowId;
import com.uniconn.backend.dtos.UserSummaryDTO;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.exception.*;
import com.uniconn.backend.repositories.*;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserFollowService extends BaseService {
	private final UserRepository userRepository;
	private final UserFollowRepository userFollowRepository;
	
	public UserFollowService(UserRepository userRepository, 
			UserFollowRepository userFollowRepository) {
		this.userRepository = userRepository;
		this.userFollowRepository = userFollowRepository;
	}
	
	// ---------------------------------------------------------------
    // FOLLOW USER
    // ---------------------------------------------------------------
	@Transactional
	public String followUser(Integer userId) {
		User currentUser = getAuthenticatedUser();
		
		if (currentUser.getUserId().equals(userId)) {
		    throw new InvalidInputException("You cannot follow yourself");
		}
		
		User following = userRepository.findById(userId)
				.orElseThrow(() -> new ResourceNotFoundException("User with id " + userId + " not found"));
		
		if (!following.isActive()) {
			throw new ResourceNotFoundException("User with id " + userId + " not found");
		}
		
		UserFollowId followId = new UserFollowId(currentUser.getUserId(), userId);
		
		if (userFollowRepository.existsById(followId)) {
			throw new ResourceAlreadyExistsException("Already following this user");
        }
		
		UserFollow follow = new UserFollow();
        follow.setId(followId);
        follow.setFollower(currentUser);
        follow.setFollowing(following);
        userFollowRepository.save(follow);
		
		currentUser.setFollowingCount(currentUser.getFollowingCount() + 1);
		userRepository.save(currentUser);
		
		following.setFollowerCount(following.getFollowerCount() + 1);
		userRepository.save(following);
		
		return "Followed user successfully!";
	}
	
	// ---------------------------------------------------------------
    // UNFOLLOW USER
    // ---------------------------------------------------------------
	@Transactional
	public String unfollowUser(Integer userId) {
		User currentUser = getAuthenticatedUser();
		
		UserFollowId followId = new UserFollowId(currentUser.getUserId(), userId);
		
		if(!userFollowRepository.existsById(followId)) {
			throw new ResourceNotFoundException("You are not following this user");
		}
		
		userFollowRepository.deleteById(followId);
		
		User following = userRepository.findById(userId)
				.orElseThrow(() -> new ResourceNotFoundException("User with id " + userId + " not found"));
		
		if (!following.isActive()) {
		    throw new RuntimeException("User not found");
		}
		
		currentUser.setFollowingCount(Math.max(0, currentUser.getFollowingCount() - 1));
		userRepository.save(currentUser);
		
		following.setFollowerCount(Math.max(0, following.getFollowerCount() - 1));
		userRepository.save(following);
		
		return "Unfollowed user successfully!";
	}
	
	// ---------------------------------------------------------------------
    // FOLLOWING POPUP - full user details of everyone current user follows 
    // ---------------------------------------------------------------------
	@Transactional(readOnly = true)
	public List<UserSummaryDTO> getFollowing(Integer userId) {
		return userFollowRepository.findByFollower_UserId(userId)
				.stream()
				.map(f -> toSummary(f.getFollowing()))
				.collect(Collectors.toList());		
	}
	
	// -------------------------------------------------------------------------
    // FOLLOWERS POPUP - full user details of everyone following the given user
    // -------------------------------------------------------------------------
	@Transactional(readOnly = true)
	public List<UserSummaryDTO> getFollowers(Integer userId) {
		return userFollowRepository.findByFollowing_UserId(userId)
				.stream()
				.map(f -> toSummary(f.getFollower()))
				.collect(Collectors.toList());		
	}
	
	// just IDs - used internally (e.g. feed filtering)
	@Transactional(readOnly = true)
	public List<Integer> getFollowingIds() {
        User currentUser = getAuthenticatedUser();
        return userFollowRepository.findByFollower_UserId(currentUser.getUserId())
                .stream()
                .map(f -> f.getFollowing().getUserId())
                .collect(Collectors.toList());
    }
	
	private UserSummaryDTO toSummary(User user) {
		UserSummaryDTO dto = new UserSummaryDTO();
		dto.setUserId(user.getUserId());
		dto.setUsername(user.getUsername());
		dto.setName(user.getName());
		dto.setProfilePicture(user.getProfilePicture());
		return dto;
	}
	
}
