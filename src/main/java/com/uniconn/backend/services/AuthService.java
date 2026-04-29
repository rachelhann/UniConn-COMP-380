// Lillian Foster
// AuthService.java - handles login and registration with JWT token generation
// throws proper exceptions so GlobalExceptionHandler returns meaningful errors

package com.uniconn.backend.services;

import com.uniconn.backend.dtos.AuthResponse;
import com.uniconn.backend.dtos.LoginRequest;
import com.uniconn.backend.dtos.RegisterRequest;
import com.uniconn.backend.entities.User;
import com.uniconn.backend.exception.InvalidInputException;
import com.uniconn.backend.exception.UnauthorizedException;
import com.uniconn.backend.utils.JwtUtil;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserService userService;
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;

    public AuthService(UserService userService, JwtUtil jwtUtil,
                       AuthenticationManager authenticationManager) {
        this.userService = userService;
        this.jwtUtil = jwtUtil;
        this.authenticationManager = authenticationManager;
    }

    // registers a new user and returns a JWT token
    // so they are logged in immediately after signing up
    @Transactional
    public AuthResponse register(RegisterRequest request) {

        if (request == null) {
            throw new InvalidInputException("Registration request cannot be null");
        }

        // use UserService to register - it handles all validation
        User user = userService.registerUser(request);

        // generate JWT token for the new user
        String token = jwtUtil.generateToken(user.getEmail());

        return new AuthResponse(token);
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
            // wrong password or email not found
            throw new UnauthorizedException("Invalid credentials");
        } catch (DisabledException e) {
            // account has been deactivated
            throw new UnauthorizedException(
                    "This account has been deactivated. Please contact support."
            );
        } catch (Exception e) {
            // anything else unexpected
            throw new UnauthorizedException("Login failed. Please try again.");
        }

        // credentials valid - generate token
        String token = jwtUtil.generateToken(request.getCsunEmail());

        return new AuthResponse(token);
    }
}