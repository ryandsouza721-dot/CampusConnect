package com.campusconnect.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "event_registrations", uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "event_key"}))
public class EventRegistration {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "event_key", nullable = false, length = 120)
    private String eventKey;
    @Column(nullable = false, length = 180)
    private String title;
    @Column(nullable = false, length = 180)
    private String location;
    @Column(name = "event_date", nullable = false)
    private LocalDateTime eventDate;
    @Column(name = "next_reminder_at", nullable = false)
    private LocalDateTime nextReminderAt;

    protected EventRegistration() {}
    public EventRegistration(User user, String eventKey, String title, String location, LocalDateTime eventDate) {
        this.user = user;
        this.eventKey = eventKey;
        this.title = title;
        this.location = location;
        this.eventDate = eventDate;
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime threeDayReminder = now.plusDays(3);
        LocalDateTime oneDayReminder = eventDate.minusDays(1);
        LocalDateTime threeHourReminder = eventDate.minusHours(3);
        this.nextReminderAt = threeDayReminder;
        if (oneDayReminder.isBefore(this.nextReminderAt)) this.nextReminderAt = oneDayReminder;
        if (!this.nextReminderAt.isAfter(now)) this.nextReminderAt = threeHourReminder;
        if (!this.nextReminderAt.isAfter(now)) this.nextReminderAt = eventDate;
    }
    public Long getId() { return id; }
    public User getUser() { return user; }
    public String getEventKey() { return eventKey; }
    public String getTitle() { return title; }
    public String getLocation() { return location; }
    public LocalDateTime getEventDate() { return eventDate; }
    public LocalDateTime getNextReminderAt() { return nextReminderAt; }
    public void setNextReminderAt(LocalDateTime nextReminderAt) { this.nextReminderAt = nextReminderAt; }
}
