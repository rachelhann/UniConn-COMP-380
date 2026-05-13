// Lillian Foster - Register Request
package com.uniconn.backend.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/**
 * This is a DTO that carries registration form data from the frontend to the backend.
 * The fields need to match the registration form inputs submitted by a new user.
 * Validation annotations catch invalid input before it reaches the service layer.
 */
public class RegisterRequest {

    // only letters, numbers, underscores, hyphens — no spaces or special chars
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 30, message = "Username must be between 3 and 30 characters")
    @Pattern(regexp = "^[a-zA-Z0-9_-]+$", message = "Username can only contain letters, numbers, underscores, and hyphens")
    private String username;

    private String fullName;

    // must be a valid CSUN email address
    @NotBlank(message = "Email is required")
    @Pattern(regexp = "^[^@\\s]+@my\\.csun\\.edu$", message = "Email must be a valid @my.csun.edu address")
    private String csunEmail;

    // minimum 8 characters
    @NotBlank(message = "Password is required")
    @Size(min = 8, message = "Password must be at least 8 characters")
    private String password;

    @NotBlank(message = "Security question is required")
    private String secretQuestion;

    @NotBlank(message = "Security answer is required")
    private String secretAnswer;

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getCsunEmail() { return csunEmail; }
    public void setCsunEmail(String csunEmail) { this.csunEmail = csunEmail; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getSecretQuestion() { return secretQuestion; }
    public void setSecretQuestion(String secretQuestion) { this.secretQuestion = secretQuestion; }

    public String getSecretAnswer() { return secretAnswer; }
    public void setSecretAnswer(String secretAnswer) { this.secretAnswer = secretAnswer; }
}