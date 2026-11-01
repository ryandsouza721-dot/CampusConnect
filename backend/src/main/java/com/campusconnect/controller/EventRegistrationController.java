package com.campusconnect.controller;

import com.campusconnect.dto.EventRegistrationRequest;
import com.campusconnect.model.EventRegistration;
import com.campusconnect.model.User;
import com.campusconnect.repository.EventRegistrationRepository;
import com.campusconnect.repository.UserRepository;
import com.campusconnect.service.EmailNotificationService;
import com.campusconnect.service.SessionTokenService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@RestController
@RequestMapping("/api/events")
@CrossOrigin(origins = "*")
public class EventRegistrationController {
    private final EventRegistrationRepository registrations;
    private final UserRepository users;
    private final EmailNotificationService emails;
    private final SessionTokenService sessions;

    public EventRegistrationController(EventRegistrationRepository registrations, UserRepository users, EmailNotificationService emails, SessionTokenService sessions) {
        this.registrations = registrations;
        this.users = users;
        this.emails = emails;
        this.sessions = sessions;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestHeader(value = "Authorization", required = false) String authorization,
                                      @RequestBody EventRegistrationRequest request) {
        Integer userId = sessions.resolve(authorization);
        if (userId == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", "Please sign in again."));
        if (blank(request.getEventKey()) || blank(request.getTitle()) || blank(request.getLocation()) || request.getEventDate() == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Event details and event date are required."));
        }
        if (!request.getEventDate().isAfter(LocalDateTime.now())) {
            return ResponseEntity.badRequest().body(Map.of("message", "This event has already started."));
        }
        User user = users.findById(userId).orElse(null);
        if (user == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("message", "User account not found."));
        if (registrations.existsByUserIdAndEventKey(user.getId(), request.getEventKey())) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("message", "You are already registered for this event."));
        }
        EventRegistration registration = registrations.save(new EventRegistration(user, request.getEventKey().trim(), request.getTitle().trim(), request.getLocation().trim(), request.getEventDate()));
        emails.eventRegistration(user.getName(), user.getEmail(), registration.getTitle(), registration.getEventDate().format(DateTimeFormatter.ofPattern("EEE, d MMM yyyy h:mm a")), registration.getLocation());
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("message", "Registration confirmed. A confirmation email will be sent when email delivery is configured."));
    }

    private boolean blank(String value) { return value == null || value.isBlank(); }
}
