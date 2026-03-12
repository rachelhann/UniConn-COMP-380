package com.uniconn.backend.services;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import com.uniconn.backend.composite_keys.UserFollowId;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.repositories.*;
import jakarta.transaction.Transactional;

@Service
public class UserFollowService extends BaseService {
	private final UserRepository userRepository;
	private final UserFollowRepository userFollowRepository;
	
	public UserFollowService(UserRepository userRepository, 
			UserFollowRepository userFollowRepository) {
		this.userRepository = userRepository;
		this.userFollowRepository = userFollowRepository;
	}
	
	@Transactional
	public String followUser(Integer userId) {
		User currentUser = getAuthenticatedUser();
		
		if (currentUser.getUserId().equals(userId)) {
		    throw new RuntimeException("You cannot follow yourself");
		}
		
		User following = userRepository.findById(userId)
				.orElseThrow(() -> new RuntimeException("User not found"));
		
		if (!following.isActive()) {
		    throw new RuntimeException("User not found");
		}
		
		UserFollowId followId = new UserFollowId(currentUser.getUserId(), userId);
		
		if (userFollowRepository.existsById(followId)) {
            throw new RuntimeException("Already following this user");
        }
		
		UserFollow follower = new UserFollow();
		follower.setId(followId);
		follower.setFollower(currentUser);
		follower.setFollowing(following);
		userFollowRepository.save(follower);
		
		currentUser.setFollowingCount(currentUser.getFollowingCount() + 1);
		userRepository.save(currentUser);
		
		following.setFollowerCount(following.getFollowerCount() + 1);
		userRepository.save(following);
		
		return "Followed user successfully!";
	}
	
	@Transactional
	public String unfollowUser(Integer userId) {
		User currentUser = getAuthenticatedUser();
		
		UserFollowId followId = new UserFollowId(currentUser.getUserId(), userId);
		
		if(!userFollowRepository.existsById(followId)) {
			throw new RuntimeException("You are not following this user");
		}
		
		userFollowRepository.deleteById(followId);
		
		User following = userRepository.findById(userId)
				.orElseThrow(() -> new RuntimeException("User not found"));
		
		if (!following.isActive()) {
		    throw new RuntimeException("User not found");
		}
		
		currentUser.setFollowingCount(Math.max(0, currentUser.getFollowingCount() - 1));
		userRepository.save(currentUser);
		
		following.setFollowerCount(Math.max(0, following.getFollowerCount() - 1));
		userRepository.save(following);
		
		return "Unfollowed user successfully!";
	}
	
}
