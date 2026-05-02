package com.uniconn.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import com.uniconn.backend.composite_keys.CommentLikeId;
import com.uniconn.backend.entities.CommentLike;

public interface CommentLikeRepository extends JpaRepository<CommentLike, CommentLikeId> {
	boolean existsByComment_CommentIdAndUser_UserId(Integer commentId, Integer userId);
}
