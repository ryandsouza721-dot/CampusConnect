package com.campusconnect.service;

import com.campusconnect.model.User;
import org.springframework.stereotype.Service;
import java.time.Instant;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class SessionTokenService {
    private record Session(Integer userId, Instant expiresAt) {}
    private final ConcurrentHashMap<String, Session> sessions = new ConcurrentHashMap<>();

    public String issue(User user) {
        String token = UUID.randomUUID().toString();
        sessions.put(token, new Session(user.getId(), Instant.now().plusSeconds(12 * 60 * 60)));
        return token;
    }

    public Integer resolve(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) return null;
        String token = authorizationHeader.substring(7).trim();
        Session session = sessions.get(token);
        if (session == null) return null;
        if (session.expiresAt().isBefore(Instant.now())) {
            sessions.remove(token);
            return null;
        }
        return session.userId();
    }
}
