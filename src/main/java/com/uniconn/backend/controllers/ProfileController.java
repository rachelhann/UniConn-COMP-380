package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.ProfileUpdateRequest;
import com.uniconn.backend.services.ProfileService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/profile")
public class ProfileController {

    private final ProfileService profileService;

    public ProfileController(ProfileService profileService) {
        this.profileService = profileService;
    }

    @GetMapping("/me")
    public ResponseEntity<?> getMyProfile() {
        try {
            return ResponseEntity.ok(profileService.getProfileData());
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PatchMapping("/me/picture")
    public ResponseEntity<?> updateProfilePicture(@RequestBody java.util.Map<String, String> body) {
        try {
            String url = body.get("url");
            if (url == null || url.isBlank()) return ResponseEntity.badRequest().body("URL is required");
            profileService.updateProfilePicture(url);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/{username}")
    public ResponseEntity<?> getProfileByUsername(@PathVariable String username) {
        try {
            return ResponseEntity.ok(profileService.getProfileDataByUsername(username));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/update")
    public ResponseEntity<?> updateProfile(@RequestBody ProfileUpdateRequest request) {
        try {
            profileService.updateProfile(request);
            return ResponseEntity.ok("Profile updated successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
