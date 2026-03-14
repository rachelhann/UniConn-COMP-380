package com.uniconn.backend.repositories;

import com.uniconn.backend.entities.User;
import com.uniconn.backend.entities.UserFollow;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
	Optional<User> findById(Integer userId);
	
    Optional<User> findByEmail(String email);
    
    Optional<User> findByUsername(String username);
    
}
