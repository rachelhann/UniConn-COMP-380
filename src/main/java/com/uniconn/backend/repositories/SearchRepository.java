package com.uniconn.backend.repositories;

import com.uniconn.backend.entities.Community;
import com.uniconn.backend.entities.CommunityMember;
import com.uniconn.backend.entities.Post;
import com.uniconn.backend.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SearchRepository extends JpaRepository<User, Integer> {

    // --- General Search ---
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

    // --- Explore Communities Search ---
    @Query("SELECT c FROM Community c WHERE " +
           "LOWER(c.communityName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "ORDER BY c.memberCount DESC")
    List<Community> searchCommunitiesForExplore(@Param("keyword") String keyword);

    // --- My Communities Search (scoped to logged in user) ---
    @Query("SELECT cm.community FROM CommunityMember cm WHERE " +
           "cm.user.userId = :userId AND (" +
           "LOWER(cm.community.communityName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(cm.community.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Community> searchUserCommunities(@Param("userId") Integer userId,
                                          @Param("keyword") String keyword);

    // --- Following Search (users that current user follows) ---
    @Query("SELECT uf.following FROM UserFollow uf WHERE " +
           "uf.follower.userId = :userId AND (" +
           "LOWER(uf.following.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(uf.following.name) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<User> searchFollowing(@Param("userId") Integer userId,
                               @Param("keyword") String keyword);

    // --- Followers Search (users that follow current user) ---
    @Query("SELECT uf.follower FROM UserFollow uf WHERE " +
           "uf.following.userId = :userId AND (" +
           "LOWER(uf.follower.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(uf.follower.name) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<User> searchFollowers(@Param("userId") Integer userId,
                               @Param("keyword") String keyword);

    // --- Community Members Search ---
    @Query("SELECT cm.user FROM CommunityMember cm WHERE " +
           "cm.community.communityId = :communityId AND (" +
           "LOWER(cm.user.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(cm.user.name) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<User> searchCommunityMembers(@Param("communityId") Integer communityId,
                                      @Param("keyword") String keyword);
}