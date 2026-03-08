package com.uniconn.backend.repositories;

import com.uniconn.backend.entities.Community;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

public interface CommunityRepository extends JpaRepository<Community, Integer> {
	boolean existsByCommunityName(String communityName);

    Optional<Community> findByCommunityName(String communityName);

}
