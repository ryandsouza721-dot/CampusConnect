package com.campusconnect.controller;
import com.campusconnect.dto.LoginRequest;
import com.campusconnect.dto.LoginResponse;
import com.campusconnect.dto.RegisterRequest;
import com.campusconnect.dto.ProfileUpdateRequest;
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
            response.setDepartment(user.getDepartment());
            response.setYearOfStudy(user.getYearOfStudy());
            response.setDivision(user.getDivision());
            response.setRollNumber(user.getRollNumber());
            response.setClubs(user.getProfileClubs() == null || user.getProfileClubs().isBlank()
                    ? java.util.List.of() : java.util.List.of(user.getProfileClubs().split(",")));

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

    @PutMapping("/profile")
    public ResponseEntity<?> updateProfile(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody ProfileUpdateRequest request) {
        Integer userId = sessions.resolve(authorization);
        if (userId == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(java.util.Map.of("message", "Please sign in again."));
        if (request.getName() == null || request.getName().isBlank()) return ResponseEntity.badRequest().body(java.util.Map.of("message", "Name is required."));
        return authService.updateProfile(userId, request.getName(), request.getDepartment(), request.getYearOfStudy(),
                        request.getDivision(), request.getRollNumber(), request.getClubs())
                .<ResponseEntity<?>>map(user -> ResponseEntity.ok(java.util.Map.of("name", user.getName())))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body(java.util.Map.of("message", "User account not found.")));
    }
}
