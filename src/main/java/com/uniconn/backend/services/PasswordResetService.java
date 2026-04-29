// Lillian Foster
// PasswordResetService.java - handles all forgot password logic
// security questions defined here in service layer per Daria's instruction
// throws proper exceptions so GlobalExceptionHandler returns meaningful errors

package com.uniconn.backend.services;

import com.uniconn.backend.entities.PasswordReset;
import com.uniconn.backend.entities.User;
import com.uniconn.backend.exception.InvalidInputException;
import com.uniconn.backend.exception.ResourceNotFoundException;
import com.uniconn.backend.exception.UnauthorizedException;
import com.uniconn.backend.repositories.PasswordResetRepository;
import com.uniconn.backend.repositories.UserRepository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class PasswordResetService {

    private final PasswordResetRepository passwordResetRepository;
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public PasswordResetService(PasswordResetRepository passwordResetRepository,
                                UserRepository userRepository) {
        this.passwordResetRepository = passwordResetRepository;
        this.userRepository = userRepository;
    }

    // security questions defined in service layer as Daria instructed
    public static final Map<Integer, String> SECURITY_QUESTIONS = new LinkedHashMap<>();
    static {
        SECURITY_QUESTIONS.put(1, "What was the name of your first pet?");
        SECURITY_QUESTIONS.put(2, "What city were you born in?");
        SECURITY_QUESTIONS.put(3, "What is your mother's maiden name?");
        SECURITY_QUESTIONS.put(4, "What was the name of your elementary school?");
        SECURITY_QUESTIONS.put(5, "What was the make of your first car?");
    }

    // step 1 of forgot password
    // takes email and returns the security question for that user
    public String getSecurityQuestion(String csunEmail) {

        // validate input
        if (csunEmail == null || csunEmail.isBlank()) {
            throw new InvalidInputException("Email is required");
        }

        // find user by email
        User user = userRepository.findByEmail(csunEmail)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "No account found with that email"
                ));

        // check account is active
        if (!user.isActive()) {
            throw new UnauthorizedException(
                    "This account has been deactivated"
            );
        }

        // find their password reset record
        PasswordReset record = passwordResetRepository.findByUserId(user)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "No security question set up for this account. " +
                                "Please contact support."
                ));

        // get question text from map using stored question id
        Integer questionId = record.getQuestionId();
        if (questionId == null) {
            throw new InvalidInputException(
                    "Security question not configured properly. Please contact support."
            );
        }

        String question = SECURITY_QUESTIONS.get(questionId);
        if (question == null) {
            throw new InvalidInputException(
                    "Invalid security question ID. Please contact support."
            );
        }

        return question;
    }

    // step 2 of forgot password
    // verifies the answer and resets the password
    @Transactional
    public void resetPassword(String csunEmail, String answer, String newPassword) {

        // validate all inputs
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
            throw new InvalidInputException(
                    "New password must be at least 8 characters"
            );
        }

        // find user by email
        User user = userRepository.findByEmail(csunEmail)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "No account found with that email"
                ));

        // check account is active
        if (!user.isActive()) {
            throw new UnauthorizedException(
                    "This account has been deactivated"
            );
        }

        // find password reset record
        PasswordReset record = passwordResetRepository.findByUserId(user)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "No security question set up for this account. " +
                                "Please contact support."
                ));

        // verify the answer matches the stored hashed answer
        // answer is trimmed and lowercased before comparing
        if (record.getAnswer() == null) {
            throw new InvalidInputException(
                    "Security answer not configured. Please contact support."
            );
        }

        if (!passwordEncoder.matches(answer.toLowerCase().trim(), record.getAnswer())) {
            throw new UnauthorizedException(
                    "Incorrect answer to security question. Please try again."
            );
        }

        // answer correct - hash and save the new password
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }
}