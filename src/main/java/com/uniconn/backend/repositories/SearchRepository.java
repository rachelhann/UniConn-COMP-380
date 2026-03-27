package com.uniconn.backend.repositories;

import com.uniconn.backend.entities.Community;
import com.uniconn.backend.entities.Post;
import com.uniconn.backend.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SearchRepository extends JpaRepository<User, Integer> {

    @Query("SELECT u FROM User u WHERE " +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(u.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(u.userBio) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<User> searchUsers(@Param("keyword") String keyword);

    @Query("SELECT c FROM Community c WHERE " +
           "LOWER(c.communityName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Community> searchCommunities(@Param("keyword") String keyword);

    @Query("SELECT p FROM Post p WHERE p.isDeleted = false AND (" +
           "LOWER(p.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(p.contentText) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Post> searchPosts(@Param("keyword") String keyword);
}