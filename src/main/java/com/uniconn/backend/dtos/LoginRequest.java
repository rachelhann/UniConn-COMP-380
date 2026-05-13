// Lillian Foster - Login Request
package com.uniconn.backend.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * This is a DTO that carries login data from the frontend to the backend.
 * It only needs email and password to authenticate an existing user.
 * Validation annotations catch invalid input before it reaches the service layer.
 */
public class LoginRequest {

    // must be a valid CSUN email address
    @NotBlank(message = "Email is required")
    @Pattern(regexp = "^[^@\\s]+@my\\.csun\\.edu$", message = "Email must be a valid @my.csun.edu address")
    private String csunEmail;

    @NotBlank(message = "Password is required")
    private String password;

    public String getCsunEmail() { return csunEmail; }
    public void setCsunEmail(String csunEmail) { this.csunEmail = csunEmail; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}