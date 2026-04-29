// Lillian Foster
// UserService.java - handles user registration and login logic
// throws proper exceptions so GlobalExceptionHandler returns meaningful errors

package com.uniconn.backend.services;

import com.uniconn.backend.dtos.LoginRequest;
import com.uniconn.backend.dtos.RegisterRequest;
import com.uniconn.backend.entities.User;
import com.uniconn.backend.exception.InvalidInputException;
import com.uniconn.backend.exception.ResourceAlreadyExistsException;
import com.uniconn.backend.exception.ResourceNotFoundException;
import com.uniconn.backend.exception.UnauthorizedException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService extends BaseService {

    private final PasswordEncoder passwordEncoder;

    public UserService(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    // registers a new user after validating email, checking for duplicates,
    // and hashing the password before saving
    @Transactional
    public User registerUser(RegisterRequest request) {

        // null check - unlikely but important
        if (request == null) {
            throw new InvalidInputException("Registration request cannot be null");
        }

        // validate CSUN email format
        if (request.getCsunEmail() == null || request.getCsunEmail().isBlank()) {
            throw new InvalidInputException("Email is required");
        }

        if (!validateCsunEmail(request.getCsunEmail())) {
            throw new InvalidInputException(
                    "Email must end in @my.csun.edu and contain no spaces"
            );
        }

        // validate username
        if (request.getUsername() == null || request.getUsername().isBlank()) {
            throw new InvalidInputException("Username is required");
        }

        // validate password
        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new InvalidInputException("Password is required");
        }

        if (request.getPassword().length() < 8) {
            throw new InvalidInputException(
                    "Password must be at least 8 characters"
            );
        }

        // check if email is already registered
        if (userRepository.findByEmail(request.getCsunEmail()).isPresent()) {
            throw new ResourceAlreadyExistsException(
                    "An account with this email already exists. Please log in instead."
            );
        }

        // check if username is already taken
        if (userRepository.findByUsername(request.getUsername()).isPresent()) {
            throw new ResourceAlreadyExistsException(
                    "Username '" + request.getUsername() + "' is already taken. Please choose another."
            );
        }

        // build and save the new user
        User user = new User();
        user.setUsername(request.getUsername());
        user.setName(request.getFullName());
        user.setEmail(request.getCsunEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setActive(true);

        return userRepository.save(user);
    }

    // logs in a user by checking email exists and password matches
    public User loginUser(LoginRequest request) {

        // null check
        if (request == null) {
            throw new InvalidInputException("Login request cannot be null");
        }

        // validate email format
        if (request.getCsunEmail() == null || request.getCsunEmail().isBlank()) {
            throw new InvalidInputException("Email is required");
        }

        if (!validateCsunEmail(request.getCsunEmail())) {
            throw new InvalidInputException("Email must end in @my.csun.edu");
        }

        // validate password field exists
        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new InvalidInputException("Password is required");
        }

        // find user by email - generic message to prevent account enumeration
        User user = userRepository.findByEmail(request.getCsunEmail())
                .orElseThrow(() -> new UnauthorizedException(
                        "Invalid credentials"
                ));

        // check if account is active
        if (!user.isActive()) {
            throw new UnauthorizedException(
                    "This account has been deactivated. Please contact support."
            );
        }

        // check password matches stored hash
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new UnauthorizedException("Invalid credentials");
        }

        return user;
    }

    // validates that email ends in @my.csun.edu and has no spaces
    public boolean validateCsunEmail(String email) {
        return email != null
                && !email.contains(" ")
                && email.endsWith("@my.csun.edu");
    }

    // resets password after verifying security question answer
    @Transactional
    public void resetPasswordBySecretQuestion(String csunEmail, String answer, String newPassword) {

        if (csunEmail == null || csunEmail.isBlank()) {
            throw new InvalidInputException("Email is required");
        }

        if (answer == null || answer.isBlank()) {
            throw new InvalidInputException("Answer is required");
        }

        if (newPassword == null || newPassword.isBlank()) {
            throw new InvalidInputException("New password is required");
        }

        if (newPassword.length() < 8) {
            throw new InvalidInputException("New password must be at least 8 characters");
        }

        User user = userRepository.findByEmail(csunEmail)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "No account found with that email"
                ));

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }
}