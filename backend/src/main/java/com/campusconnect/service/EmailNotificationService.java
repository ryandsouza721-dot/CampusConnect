package com.campusconnect.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailNotificationService {
    private static final Logger log = LoggerFactory.getLogger(EmailNotificationService.class);
    private final ObjectProvider<JavaMailSender> mailSenderProvider;

    public EmailNotificationService(ObjectProvider<JavaMailSender> mailSenderProvider) {
        this.mailSenderProvider = mailSenderProvider;
    }

    public boolean send(String to, String subject, String body) {
        JavaMailSender sender = mailSenderProvider.getIfAvailable();
        if (sender == null) {
            log.warn("Email not sent to {}: configure SMTP settings to enable email notifications", to);
            return false;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(to);
            message.setSubject(subject);
            message.setText(body);
            sender.send(message);
            return true;
        } catch (RuntimeException exception) {
            log.error("Could not send email notification to {}", to, exception);
            return false;
        }
    }

    public void registration(String name, String email) {
        send(email, "Welcome to CampusConnect", "Hi " + name + ",\n\nThanks for registering with CampusConnect. Your student account is ready.\n\nFCRIT CampusConnect");
    }

    public void login(String name, String email) {
        send(email, "CampusConnect sign-in", "Hi " + name + ",\n\nA sign-in to your CampusConnect account just occurred. If this wasn't you, contact your college administrator.\n\nFCRIT CampusConnect");
    }

    public void eventRegistration(String name, String email, String title, String date, String location) {
        send(email, "Event registration confirmed: " + title,
                "Hi " + name + ",\n\nYou are registered for " + title + ".\nDate: " + date + "\nLocation: " + location + "\n\nWe'll email you reminders before the event.\n\nFCRIT CampusConnect");
    }

    public void eventReminder(String name, String email, String title, String date, String location) {
        send(email, "Reminder: " + title, "Hi " + name + ",\n\nThis is a reminder for " + title + ".\nDate: " + date + "\nLocation: " + location + "\n\nFCRIT CampusConnect");
    }
}
