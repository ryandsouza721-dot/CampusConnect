package com.campusconnect;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
    public static void main(String[] args) {

        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        System.out.println("STUDENT: " + encoder.encode("Student@123"));
        System.out.println("ADMIN: " + encoder.encode("Admin@123"));
        System.out.println("NOTICE MANAGER: " + encoder.encode("Notice@123"));
    }
}