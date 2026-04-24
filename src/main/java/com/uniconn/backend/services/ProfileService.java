// Lillian Foster
// UniConn - COMP 380
// ProfileService.java - handles all the business logic for the profile page
// Extends BaseService so we get getAuthenticatedUser() and userRepository for free

package com.uniconn.backend.services;

import com.uniconn.backend.dtos.ProfileData;
import com.uniconn.backend.dtos.ProfileUpdateRequest;
import com.uniconn.backend.entities.User;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class ProfileService extends BaseService {

    // Gets the currently logged in user's profile data
    // Called by ProfileController when someone visits /profile
    public ProfileData getProfileData() {

        // BaseService gives us this method — finds the logged in user
        User user = getAuthenticatedUser();

        // Map the user's fields into a ProfileData object to send back
        return mapToProfileData(user);
    }

    @Transactional
    public void updateProfile(ProfileUpdateRequest request) {
        User user = getAuthenticatedUser();
        user.setName(request.getName());
        user.setUserBio(request.getUserBio());
        userRepository.save(user);
    }

    // Helper method — copies fields from User entity into ProfileData DTO
    // We do this so we never accidentally expose sensitive fields
    // like the password hash to the frontend
    private ProfileData mapToProfileData(User user) {

        ProfileData data = new ProfileData();

        data.setUsername(user.getUsername());
        data.setName(user.getName());
        data.setEmail(user.getEmail());
        data.setUserBio(user.getUserBio());
        data.setProfilePicture(user.getProfilePicture());
        data.setFollowerCount(user.getFollowerCount());
        data.setFollowingCount(user.getFollowingCount());
        data.setCommunityCount(user.getCommunityCount());

        return data;
    }
}