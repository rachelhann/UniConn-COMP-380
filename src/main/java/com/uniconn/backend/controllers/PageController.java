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

    @GetMapping("/communities")
    public String communitiesPage() {
        return "communities/communities";
    }

    @GetMapping("/my-communities")
    public String myCommunitiesPage() {
        return "communities/myCommunities";
    }

    @GetMapping("/post/createPost")
    public String createPostPage() {
        return "post/createPost";
    }

    @GetMapping("/community/{id}")
    public String communityDetailPage() {
        return "communities/communityDetail";
    }

    @GetMapping("/profile")
    public String profilePage() {
        return "profile/profile";
    }

}
