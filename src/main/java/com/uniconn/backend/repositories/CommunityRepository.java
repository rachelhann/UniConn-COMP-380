package com.uniconn.backend.repositories;

import com.uniconn.backend.entities.Community;
import com.uniconn.backend.entities.CommunityCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommunityRepository extends JpaRepository<Community, Integer> {
	boolean existsByCommunityName(String communityName);

    Optional<Community> findByCommunityName(String communityName);
    
    List<Community> findByCategory(CommunityCategory category);

    boolean existsByCommunityNameIgnoreCase(String communityName);
}
