package com.campusconnect.service;

import com.campusconnect.model.EventRegistration;
import com.campusconnect.repository.EventRegistrationRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Component
public class EventReminderScheduler {
    private final EventRegistrationRepository registrations;
    private final EmailNotificationService emails;

    public EventReminderScheduler(EventRegistrationRepository registrations, EmailNotificationService emails) {
        this.registrations = registrations;
        this.emails = emails;
    }

    @Scheduled(fixedDelayString = "${campusconnect.reminders.poll-ms:3600000}")
    @Transactional
    public void sendDueReminders() {
        LocalDateTime now = LocalDateTime.now();
        for (EventRegistration registration : registrations.findByNextReminderAtBeforeAndEventDateAfter(now, now)) {
            boolean sent = emails.send(registration.getUser().getEmail(), "Reminder: " + registration.getTitle(),
                    "Hi " + registration.getUser().getName() + ",\n\nThis is a reminder for " + registration.getTitle() + ".\nDate: "
                            + registration.getEventDate().format(DateTimeFormatter.ofPattern("EEE, d MMM yyyy h:mm a"))
                            + "\nLocation: " + registration.getLocation() + "\n\nFCRIT CampusConnect");
            if (!sent) {
                registration.setNextReminderAt(now.plusHours(1));
                continue;
            }
            LocalDateTime eventDate = registration.getEventDate();
            long hoursUntilEvent = java.time.Duration.between(now, eventDate).toHours();
            LocalDateTime next;
            if (hoursUntilEvent > 72) next = now.plusDays(3);
            else if (hoursUntilEvent > 24) next = eventDate.minusDays(1);
            else if (hoursUntilEvent > 3) next = eventDate.minusHours(3);
            else next = eventDate;
            if (!next.isAfter(now)) next = eventDate;
            registration.setNextReminderAt(next);
        }
    }
}
