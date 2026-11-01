package com.campusconnect.service;

import com.campusconnect.model.User;
import com.campusconnect.repository.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import com.campusconnect.model.User.Role;

import java.util.Optional;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final EmailNotificationService emailNotifications;
    private final BCryptPasswordEncoder passwordEncoder =
            new BCryptPasswordEncoder();

    public AuthService(UserRepository userRepository, EmailNotificationService emailNotifications) {
        this.userRepository = userRepository;
        this.emailNotifications = emailNotifications;
    }

    public Optional<User> login(String email, String password, String requestedRole) {
        Optional<User> userOptional = userRepository.findByEmail(email);

        if (userOptional.isPresent()) {
            User user = userOptional.get();

            boolean roleMatches = requestedRole == null || requestedRole.isBlank()
                    || user.getRole().name().equalsIgnoreCase(requestedRole)
                    || (requestedRole.equalsIgnoreCase("TEACHER") && user.getRole() == Role.NOTICE_MANAGER);
            if (roleMatches && passwordEncoder.matches(password, user.getPassword())) {
                emailNotifications.login(user.getName(), user.getEmail());
                return Optional.of(user);
            }
        }

        return Optional.empty();
    }

    public User registerStudent(String name, String email, String password) {
        if (name == null || name.isBlank() || email == null || email.isBlank() || password == null || password.length() < 8) {
            throw new IllegalArgumentException("Enter your name, a valid email, and a password of at least 8 characters.");
        }
        String normalizedEmail = email.trim().toLowerCase();
        if (!normalizedEmail.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            throw new IllegalArgumentException("Enter a valid email address.");
        }
        if (userRepository.existsByEmail(normalizedEmail)) {
            throw new IllegalArgumentException("An account with that email already exists.");
        }
        User user = new User();
        user.setName(name.trim());
        user.setEmail(normalizedEmail);
        user.setPassword(passwordEncoder.encode(password));
        user.setRole(Role.STUDENT);
        User saved = userRepository.save(user);
        emailNotifications.registration(saved.getName(), saved.getEmail());
        return saved;
    }
}
