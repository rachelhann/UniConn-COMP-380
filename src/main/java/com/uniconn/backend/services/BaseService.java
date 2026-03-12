package com.uniconn.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import com.uniconn.backend.entities.User;
import com.uniconn.backend.repositories.UserRepository;

@Service
public abstract class BaseService {
	
	@Autowired
	protected UserRepository userRepository;
	
	protected User getAuthenticatedUser () {
		Integer currentUserId = ((User) SecurityContextHolder.getContext()
                .getAuthentication()
                .getPrincipal())
                .getUserId();
		
		return userRepository.findById(currentUserId)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
	}

}
