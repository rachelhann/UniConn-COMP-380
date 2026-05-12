package com.uniconn.backend.repositories;

import com.uniconn.backend.composite_keys.PostLikeId;
import com.uniconn.backend.entities.PostLike;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PostLikeRepository extends JpaRepository<PostLike, PostLikeId> {
    List<PostLike> findByIdUserId(Integer userId);
}