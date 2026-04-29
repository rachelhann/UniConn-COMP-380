package com.uniconn.backend.repositories;

import com.uniconn.backend.composite_keys.PostLikeId;
import com.uniconn.backend.entities.PostLike;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostLikeRepository extends JpaRepository<PostLike, PostLikeId> {
	
}