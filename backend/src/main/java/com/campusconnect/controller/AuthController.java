package com.campusconnect.controller;
//ubln jeav baod iymn
import com.campusconnect.dto.LoginRequest;
import com.campusconnect.dto.LoginResponse;
import com.campusconnect.dto.RegisterRequest;
import com.campusconnect.model.User;
import com.campusconnect.service.AuthService;
import com.campusconnect.service.SessionTokenService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;
    private final SessionTokenService sessions;

    public AuthController(AuthService authService, SessionTokenService sessions) {
        this.authService = authService;
        this.sessions = sessions;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(
            @RequestBody LoginRequest request) {

        Optional<User> userOptional = authService.login(
                request.getEmail(),
                request.getPassword(),
                request.getRole()
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
            response.setToken(sessions.issue(user));

            return ResponseEntity.ok(response);
        }

        LoginResponse response = new LoginResponse(
                null, null, null, null,
                "Invalid email or password"
        );

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(response);
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        try {
            User user = authService.registerStudent(request.getName(), request.getEmail(), request.getPassword());
            LoginResponse response = new LoginResponse(
                    user.getId(), user.getName(), user.getEmail(), user.getRole().name(),
                    "Account created. A welcome email will be sent when email delivery is configured.");
            response.setToken(sessions.issue(user));
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException exception) {
            return ResponseEntity.badRequest().body(java.util.Map.of("message", exception.getMessage()));
        }
    }
}
