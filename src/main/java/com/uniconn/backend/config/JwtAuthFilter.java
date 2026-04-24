// Lillian Foster
// UniConn - COMP 380
// JwtAuthFilter.java - intercepts every incoming request and checks for a valid JWT token
// If the token is valid, it authenticates the user in Spring Security's context
// If no token or invalid token, the request is rejected before reaching any controller

package com.uniconn.backend.config;

import com.uniconn.backend.repositories.UserRepository;
import com.uniconn.backend.utils.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;

    // Constructor injection — same pattern the team uses everywhere
    public JwtAuthFilter(JwtUtil jwtUtil, UserRepository userRepository) {
        this.jwtUtil = jwtUtil;
        this.userRepository = userRepository;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        // Every request must have an Authorization header with the token
        // Format: "Bearer <token>"
        String authHeader = request.getHeader("Authorization");

        // If no Authorization header, skip — let SecurityConfig handle rejection
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        // Strip "Bearer " prefix to get just the token string
        String token = authHeader.substring(7);

        // Validate the token and authenticate the user if valid
        if (jwtUtil.validateToken(token)) {

            // Extract username from the token
            String username = jwtUtil.extractUsername(token);

            // Look up the user in the database by username
            userRepository.findByEmail(username).ifPresent(user -> {

                // Create an authentication object for Spring Security
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(
                                user, null, new ArrayList<>()
                        );

                authentication.setDetails(
                        new WebAuthenticationDetailsSource().buildDetails(request)
                );

                // Set the authenticated user in Spring Security's context
                // This is what makes getAuthenticatedUser() work in BaseService
                SecurityContextHolder.getContext().setAuthentication(authentication);
            });
        }

        // Continue processing the request
        filterChain.doFilter(request, response);
    }
}