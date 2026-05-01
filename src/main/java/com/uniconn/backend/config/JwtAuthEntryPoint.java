// Lillian Foster
// JwtAuthEntryPoint.java - handles unauthenticated requests
// API calls get 401 JSON, browser page requests get redirected to /login

package com.uniconn.backend.config;

import java.io.IOException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtAuthEntryPoint implements AuthenticationEntryPoint {

    @Override
    public void commence(HttpServletRequest request,
                         HttpServletResponse response,
                         AuthenticationException authException) throws IOException {

        String path = request.getRequestURI();

        if (path.startsWith("/api/")) {
            // API calls get 401 JSON response
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Unauthorized. Please log in.\"}");
        } else {
            // browser page requests get redirected to login
            response.sendRedirect("/login");
        }
    }
}