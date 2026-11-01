package com.campusconnect.controller;

import com.campusconnect.dto.LoginRequest;
import com.campusconnect.dto.LoginResponse;
import com.campusconnect.model.User;
import com.campusconnect.service.AuthService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(
            @RequestBody LoginRequest request) {

        Optional<User> userOptional = authService.login(
                request.getEmail(),
                request.getPassword()
        );

        if (userOptional.isPresent()) {
            User user = userOptional.get();

            LoginResponse response = new LoginResponse(
                    user.getId(),
                    user.getName(),
                    user.getEmail(),
                    user.getRole().name(),
                    "Login successful"
            );

            return ResponseEntity.ok(response);
        }

        LoginResponse response = new LoginResponse(
                null, null, null, null,
                "Invalid email or password"
        );

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(response);
    }
}