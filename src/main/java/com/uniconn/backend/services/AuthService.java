// Lillian Foster
// AuthService.java - handles login and registration
// saves security question to password_reset table on registration

package com.uniconn.backend.services;

import com.uniconn.backend.dtos.AuthResponse;
import com.uniconn.backend.dtos.LoginRequest;
import com.uniconn.backend.dtos.RegisterRequest;
import com.uniconn.backend.entities.PasswordReset;
import com.uniconn.backend.entities.User;
import com.uniconn.backend.exception.InvalidInputException;
import com.uniconn.backend.exception.UnauthorizedException;
import com.uniconn.backend.repositories.PasswordResetRepository;
import com.uniconn.backend.utils.JwtUtil;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final UserService userService;
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;
    private final PasswordResetRepository passwordResetRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UserService userService, JwtUtil jwtUtil,
                       AuthenticationManager authenticationManager,
                       PasswordResetRepository passwordResetRepository,
                       PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.jwtUtil = jwtUtil;
        this.authenticationManager = authenticationManager;
        this.passwordResetRepository = passwordResetRepository;
        this.passwordEncoder = passwordEncoder;
    }

    // registers a new user and returns a JWT token
    // saves security question to password_reset table
    @Transactional
    public AuthResponse register(RegisterRequest request) {

        if (request == null) {
            throw new InvalidInputException("Registration request cannot be null");
        }

        // validate security question fields
        if (request.getSecretQuestion() == null || request.getSecretQuestion().isBlank()) {
            throw new InvalidInputException("Security question is required");
        }

        if (request.getSecretAnswer() == null || request.getSecretAnswer().isBlank()) {
            throw new InvalidInputException("Security answer is required");
        }

        // use UserService to register - it handles all validation
        User user = userService.registerUser(request);

        // save security question to password_reset table
        PasswordReset passwordReset = new PasswordReset();
        passwordReset.setUserId(user);
        // store question as ID - find matching question ID from PasswordResetService map
        passwordReset.setQuestionId(getQuestionId(request.getSecretQuestion()));
        // hash the answer before saving - trim and lowercase for consistent matching
        passwordReset.setAnswer(passwordEncoder.encode(request.getSecretAnswer().toLowerCase().trim()));
        passwordResetRepository.save(passwordReset);

        // generate JWT token for the new user
        String token = jwtUtil.generateToken(user.getEmail());

        return new AuthResponse(token);
    }

    // maps question text to question ID using PasswordResetService map
    private Integer getQuestionId(String questionText) {
        for (java.util.Map.Entry<Integer, String> entry : com.uniconn.backend.services.PasswordResetService.SECURITY_QUESTIONS.entrySet()) {
            if (entry.getValue().equalsIgnoreCase(questionText.trim())) {
                return entry.getKey();
            }
        }
        // if question text doesn't match, default to question 1
        return 1;
    }

    // logs in a user by verifying credentials via Spring Security
    // then generating and returning a JWT token
    public AuthResponse login(LoginRequest request) {

        if (request == null) {
            throw new InvalidInputException("Login request cannot be null");
        }

        if (request.getCsunEmail() == null || request.getCsunEmail().isBlank()) {
            throw new InvalidInputException("Email is required");
        }

        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new InvalidInputException("Password is required");
        }

        try {
            // Spring Security verifies email and password against the database
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getCsunEmail(),
                            request.getPassword()
                    )
            );
        } catch (BadCredentialsException e) {
            throw new UnauthorizedException("Invalid credentials");
        } catch (DisabledException e) {
            throw new UnauthorizedException(
                    "This account has been deactivated. Please contact support."
            );
        } catch (Exception e) {
            throw new UnauthorizedException("Login failed. Please try again.");
        }

        // credentials valid - generate token
        String token = jwtUtil.generateToken(request.getCsunEmail());

        return new AuthResponse(token);
    }
}