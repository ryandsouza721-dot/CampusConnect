package com.campusconnect.dto;

import java.time.LocalDateTime;

public class EventRegistrationRequest {
    private String eventKey;
    private String title;
    private String location;
    private LocalDateTime eventDate;
    public String getEventKey() { return eventKey; }
    public void setEventKey(String eventKey) { this.eventKey = eventKey; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public LocalDateTime getEventDate() { return eventDate; }
    public void setEventDate(LocalDateTime eventDate) { this.eventDate = eventDate; }
}
