// Lillian Foster
// AuthController.java - handles login, registration, and forgot password endpoints
// no try/catch needed - GlobalExceptionHandler catches everything automatically

package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.AuthResponse;
import com.uniconn.backend.dtos.LoginRequest;
import com.uniconn.backend.dtos.RegisterRequest;
import com.uniconn.backend.dtos.ResetPasswordRequest;
import com.uniconn.backend.services.AuthService;
import com.uniconn.backend.services.PasswordResetService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;
    private final PasswordResetService passwordResetService;

    public AuthController(AuthService authService, PasswordResetService passwordResetService) {
        this.authService = authService;
        this.passwordResetService = passwordResetService;
    }

    // POST /api/auth/register
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ResponseEntity.ok(response);
    }

    // POST /api/auth/login
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }

    // GET /api/auth/logout
    @GetMapping("/logout")
    public ResponseEntity<String> logout() {
        return ResponseEntity.ok("Logged out successfully");
    }

    // GET /api/auth/forgot-password/question
    // public endpoint - user is not logged in yet
    @GetMapping("/forgot-password/question")
    public ResponseEntity<String> getSecurityQuestion(@RequestParam String csunEmail) {
        String question = passwordResetService.getSecurityQuestion(csunEmail);
        return ResponseEntity.ok(question);
    }

    // POST /api/auth/forgot-password/reset
    // public endpoint - user is not logged in yet
    @PostMapping("/forgot-password/reset")
    public ResponseEntity<String> resetPassword(@RequestBody ResetPasswordRequest request) {
        passwordResetService.resetPassword(
                request.getCsunEmail(),
                request.getAnswer(),
                request.getNewPassword()
        );
        return ResponseEntity.ok("Password reset successfully");
    }
}