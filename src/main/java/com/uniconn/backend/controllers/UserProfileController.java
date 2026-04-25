// Lillian Foster
// UniConn - COMP 380
// UserProfileController.java - endpoints for profile picture upload
// and viewing any user's profile by username
// Hanna's ProfileController handles /api/profile/me and /api/profile/update

package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.ProfileData;
import com.uniconn.backend.services.ProfileService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/users")
public class UserProfileController {

    private final ProfileService profileService;

    public UserProfileController(ProfileService profileService) {
        this.profileService = profileService;
    }

    // GET /api/users/me
    // returns the current logged in user's full profile
    @GetMapping("/me")
    public ResponseEntity<?> getMyProfile() {
        ProfileData profile = profileService.getProfileData();
        return ResponseEntity.ok(profile);
    }

    // GET /api/users/{username}
    // returns any user's profile by username
    // follows u/username pattern
    @GetMapping("/{username}")
    public ResponseEntity<?> getProfileByUsername(@PathVariable String username) {
        ProfileData profile = profileService.getProfileByUsername(username);
        return ResponseEntity.ok(profile);
    }

    // POST /api/users/me/picture
    // uploads a profile picture
    // saves file to static/uploads and stores path in database
    @PostMapping("/me/picture")
    public ResponseEntity<?> uploadProfilePicture(@RequestParam("file") MultipartFile file) {
        String path = profileService.uploadProfilePicture(file);
        return ResponseEntity.ok(path);
    }
}