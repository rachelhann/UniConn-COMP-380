package com.uniconn.backend.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping("/")
    public String home() {
        return "login/login";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login/login";
    }

    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        return "login/forgotPassword";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "login/register";
    }

    @GetMapping("/feed")
    public String feedPage() {
        return "userFeed/userFeed";
    }
    
    @GetMapping("/profile")
    public String profilePage() {
        return "profile/profile";
    }

    @GetMapping("/profile/{username}")
    public String userProfilePage() {
        return "profile/userProfile";
    }
    
    @GetMapping("/post/createPost")
    public String createPostPage() {
        return "post/createPost";
    }
    
    
    
    // Explore page — all communities (category filter handled by same template)
    @GetMapping("/communities")
    public String communitiesPage() {
        return "communities/communities";
    }

    @GetMapping("/my-communities")
    public String myCommunitiesPage() {
        return "communities/myCommunities";
    }

    @GetMapping("/community/{communityName}")
    public String communityDetailPage() {
        return "communities/communityDetail";
    }

}
