package com.campusconnect.dto;

import java.util.List;

public class LoginResponse {

    private Integer id;
    private String name;
    private String email;
    private String role;
    private String message;
    private String token;
    private String department;
    private String yearOfStudy;
    private String division;
    private String rollNumber;
    private List<String> clubs;

    public LoginResponse() {
    }

    public LoginResponse(Integer id, String name, String email,
                         String role, String message) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.role = role;
        this.message = message;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public String getYearOfStudy() { return yearOfStudy; }
    public void setYearOfStudy(String yearOfStudy) { this.yearOfStudy = yearOfStudy; }
    public String getDivision() { return division; }
    public void setDivision(String division) { this.division = division; }
    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }
    public List<String> getClubs() { return clubs; }
    public void setClubs(List<String> clubs) { this.clubs = clubs; }
}
