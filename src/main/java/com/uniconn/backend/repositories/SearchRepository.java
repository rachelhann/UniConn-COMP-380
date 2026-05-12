package com.uniconn.backend.repositories;

import com.uniconn.backend.entities.Community;
import com.uniconn.backend.entities.Post;
import com.uniconn.backend.entities.Tag;
import com.uniconn.backend.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SearchRepository extends JpaRepository<User, Integer> {

    // --- General user search ---
    @Query("SELECT u FROM User u WHERE " +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(u.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(u.userBio) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "ORDER BY " +
           "CASE WHEN LOWER(u.username) LIKE LOWER(CONCAT(:keyword, '%')) THEN 0 " +
           "     WHEN LOWER(u.name) LIKE LOWER(CONCAT(:keyword, '%')) THEN 1 " +
           "     ELSE 2 END, " +
           "u.username ASC")
    List<User> searchUsers(@Param("keyword") String keyword);

    // --- General community search ---
    @Query("SELECT c FROM Community c WHERE " +
           "LOWER(c.communityName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "ORDER BY " +
           "CASE WHEN LOWER(c.communityName) LIKE LOWER(CONCAT(:keyword, '%')) THEN 0 " +
           "     ELSE 1 END, " +
           "c.communityName ASC")
    List<Community> searchCommunities(@Param("keyword") String keyword);

    // --- General post search ---
    @Query("SELECT p FROM Post p JOIN FETCH p.author WHERE p.isDeleted = false AND (" +
           "LOWER(p.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(p.contentText) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY " +
           "CASE WHEN LOWER(p.title) LIKE LOWER(CONCAT(:keyword, '%')) THEN 0 " +
           "     ELSE 1 END, " +
           "p.createdAt DESC")
    List<Post> searchPosts(@Param("keyword") String keyword);

    // --- Explore communities search ---
    @Query("SELECT c FROM Community c WHERE " +
           "LOWER(c.communityName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "ORDER BY " +
           "CASE WHEN LOWER(c.communityName) LIKE LOWER(CONCAT(:keyword, '%')) THEN 0 " +
           "     ELSE 1 END, " +
           "c.communityName ASC")
    List<Community> searchCommunitiesForExplore(@Param("keyword") String keyword);

    // --- My communities search ---
    @Query("SELECT c FROM Community c JOIN CommunityMember cm ON cm.community = c " +
           "WHERE cm.user.userId = :userId AND (" +
           "LOWER(c.communityName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY " +
           "CASE WHEN LOWER(c.communityName) LIKE LOWER(CONCAT(:keyword, '%')) THEN 0 " +
           "     ELSE 1 END, " +
           "c.communityName ASC")
    List<Community> searchUserCommunities(@Param("userId") Integer userId, @Param("keyword") String keyword);

    // --- Following search ---
    @Query("SELECT u FROM User u JOIN UserFollow uf ON uf.following = u " +
           "WHERE uf.follower.userId = :userId AND (" +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(u.name) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY " +
           "CASE WHEN LOWER(u.username) LIKE LOWER(CONCAT(:keyword, '%')) THEN 0 " +
           "     ELSE 1 END, " +
           "u.username ASC")
    List<User> searchFollowing(@Param("userId") int userId, @Param("keyword") String keyword);

    // --- Followers search ---
    @Query("SELECT u FROM User u JOIN UserFollow uf ON uf.follower = u " +
           "WHERE uf.following.userId = :userId AND (" +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(u.name) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY " +
           "CASE WHEN LOWER(u.username) LIKE LOWER(CONCAT(:keyword, '%')) THEN 0 " +
           "     ELSE 1 END, " +
           "u.username ASC")
    List<User> searchFollowers(@Param("userId") int userId, @Param("keyword") String keyword);

    // --- Community members search ---
    @Query("SELECT u FROM User u JOIN CommunityMember cm ON cm.user = u " +
           "WHERE cm.community.communityId = :communityId AND (" +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(u.name) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY " +
           "CASE WHEN LOWER(u.username) LIKE LOWER(CONCAT(:keyword, '%')) THEN 0 " +
           "     ELSE 1 END, " +
           "u.username ASC")
    List<User> searchCommunityMembers(@Param("communityId") Integer communityId, @Param("keyword") String keyword);

    // --- Tag search ---
    @Query("SELECT t FROM Tag t WHERE " +
           "LOWER(t.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "ORDER BY " +
           "CASE WHEN LOWER(t.name) LIKE LOWER(CONCAT(:keyword, '%')) THEN 0 " +
           "     ELSE 1 END, " +
           "t.name ASC")
    List<Tag> searchTags(@Param("keyword") String keyword);


       // --- Communities by tag ---
       @Query("SELECT DISTINCT c FROM Community c JOIN c.tags ct JOIN ct.tag t WHERE " +
              "LOWER(t.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
              "ORDER BY c.communityName ASC")
       List<Community> searchCommunitiesByTag(@Param("keyword") String keyword);

       // --- Posts by tag ---
       @Query("SELECT DISTINCT p FROM Post p JOIN p.tags pt JOIN pt.tag t JOIN FETCH p.author " +
              "WHERE p.isDeleted = false AND " +
              "LOWER(t.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
              "ORDER BY p.createdAt DESC")
       List<Post> searchPostsByTag(@Param("keyword") String keyword);

}