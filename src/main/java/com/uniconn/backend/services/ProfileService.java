// Lillian Foster
// UniConn - COMP 380
// ProfileService.java - handles all business logic for the profile page
// Extends BaseService so we get getAuthenticatedUser() and userRepository for free

package com.uniconn.backend.services;

import com.uniconn.backend.dtos.ProfileData;
import com.uniconn.backend.dtos.ProfileUpdateRequest;
import com.uniconn.backend.entities.Post;
import com.uniconn.backend.entities.User;
import com.uniconn.backend.exception.InvalidInputException;
import com.uniconn.backend.exception.ResourceNotFoundException;
import com.uniconn.backend.repositories.CommunityMemberRepository;
import com.uniconn.backend.repositories.PostRepository;
import com.uniconn.backend.repositories.UserFollowRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class ProfileService extends BaseService {

    private final UserFollowRepository userFollowRepository;
    private final CommunityMemberRepository communityMemberRepository;
    private final PostRepository postRepository;

    public ProfileService(UserFollowRepository userFollowRepository,
                          CommunityMemberRepository communityMemberRepository,
                          PostRepository postRepository) {
        this.userFollowRepository = userFollowRepository;
        this.communityMemberRepository = communityMemberRepository;
        this.postRepository = postRepository;
    }

    // gets the currently logged in user's full profile data
    public ProfileData getProfileData() {
        User user = getAuthenticatedUser();
        return mapToProfileData(user);
    }

    // gets any user's profile by username
    public ProfileData getProfileByUsername(String username) {
        if (username == null || username.isBlank()) {
            throw new InvalidInputException("Username is required");
        }

        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "No user found with username: " + username
                ));

        return mapToProfileData(user);
    }

    // updates the current user's name and bio
    @Transactional
    public void updateProfile(ProfileUpdateRequest request) {

        if (request == null) {
            throw new InvalidInputException("Update request cannot be null");
        }

        User user = getAuthenticatedUser();

        if (request.getName() != null && !request.getName().isBlank()) {
            if (request.getName().length() > 30) {
                throw new InvalidInputException("Name cannot exceed 30 characters");
            }
            user.setName(request.getName());
        }

        if (request.getUserBio() != null) {
            if (request.getUserBio().length() > 150) {
                throw new InvalidInputException("Bio cannot exceed 150 characters");
            }
            user.setUserBio(request.getUserBio());
        }

        userRepository.save(user);
    }

    // handles profile picture file upload
    // saves file to static/uploads folder and stores path in database
    @Transactional
    public String uploadProfilePicture(MultipartFile file) {

        if (file == null || file.isEmpty()) {
            throw new InvalidInputException("Please select a file to upload");
        }

        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new InvalidInputException("Only image files are allowed");
        }

        if (file.getSize() > 5 * 1024 * 1024) {
            throw new InvalidInputException("File size cannot exceed 5MB");
        }

        User user = getAuthenticatedUser();

        try {
            Path uploadDir = Paths.get("src/main/resources/static/uploads");
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }

            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String newFilename = UUID.randomUUID().toString() + extension;

            Path filePath = uploadDir.resolve(newFilename);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            String profilePicturePath = "/uploads/" + newFilename;
            user.setProfilePicture(profilePicturePath);
            userRepository.save(user);

            return profilePicturePath;

        } catch (IOException e) {
            throw new RuntimeException("Failed to upload profile picture. Please try again.");
        }
    }

    // maps user entity to profile DTO
    private ProfileData mapToProfileData(User user) {

        ProfileData data = new ProfileData();

        data.setUsername(user.getUsername());
        data.setName(user.getName());
        data.setEmail(user.getEmail());
        data.setUserBio(user.getUserBio());
        data.setProfilePicture(user.getProfilePicture());

        // follower count — how many people follow this user
        int followerCount = userFollowRepository
                .findByFollowing_UserId(user.getUserId()).size();
        data.setFollowerCount(followerCount);

        // following count — how many people this user follows
        int followingCount = userFollowRepository
                .findByFollower_UserId(user.getUserId()).size();
        data.setFollowingCount(followingCount);

        // communities this user belongs to
        List<String> communities = communityMemberRepository
                .findByUser_UserId(user.getUserId())
                .stream()
                .map(cm -> cm.getCommunity().getCommunityName())
                .collect(Collectors.toList());
        data.setCommunities(communities);
        data.setCommunityCount(communities.size());

        // all posts by this user
        List<Post> posts = postRepository.findProfilePostsByUser(user.getUserId());
        data.setPosts(posts);

        return data;
    }
}