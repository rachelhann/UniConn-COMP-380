// Lillian Foster
// ForgotPasswordRequest.java - DTO for forgot password step 1
// user submits their email to start the forgot password flow

package com.uniconn.backend.dtos;

public class ForgotPasswordRequest {

    private String csunEmail;

    public String getCsunEmail() {
        return csunEmail;
    }

    public void setCsunEmail(String csunEmail) {
        this.csunEmail = csunEmail;
    }
}