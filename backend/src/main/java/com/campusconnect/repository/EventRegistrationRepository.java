package com.campusconnect.repository;

import com.campusconnect.model.EventRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDateTime;
import java.util.List;

public interface EventRegistrationRepository extends JpaRepository<EventRegistration, Long> {
    boolean existsByUserIdAndEventKey(Integer userId, String eventKey);
    List<EventRegistration> findByNextReminderAtBeforeAndEventDateAfter(LocalDateTime now, LocalDateTime eventDate);
}
