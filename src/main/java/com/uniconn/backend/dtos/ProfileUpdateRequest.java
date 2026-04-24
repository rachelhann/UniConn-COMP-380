package com.uniconn.backend.dtos;

public class ProfileUpdateRequest {
    private String name;
    private String userBio;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getUserBio() { return userBio; }
    public void setUserBio(String userBio) { this.userBio = userBio; }
}
