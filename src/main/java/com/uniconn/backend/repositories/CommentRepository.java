package com.uniconn.backend.repositories;

import com.uniconn.backend.entities.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Integer> {

    // All non-deleted comments for a post, oldest first
    @Query("""
        SELECT c FROM Comment c
        LEFT JOIN FETCH c.author
        WHERE c.post.postId = :postId
          AND c.isDeleted = false
        ORDER BY c.createdAt ASC
    """)
    List<Comment> findByPostId(@Param("postId") Integer postId);
}