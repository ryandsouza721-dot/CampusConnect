package com.campusconnect.dto;

import java.util.List;

public class ProfileUpdateRequest {
    private String name;
    private String department;
    private String yearOfStudy;
    private String division;
    private String rollNumber;
    private List<String> clubs;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
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
