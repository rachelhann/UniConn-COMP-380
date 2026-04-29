// Lillian Foster
// ResetPasswordRequest.java - DTO for forgot password step 2
// user submits their email, security question answer, and new password

package com.uniconn.backend.dtos;

public class ResetPasswordRequest {

    private String csunEmail;
    private String answer;
    private String newPassword;

    public String getCsunEmail() {
        return csunEmail;
    }

    public void setCsunEmail(String csunEmail) {
        this.csunEmail = csunEmail;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
}