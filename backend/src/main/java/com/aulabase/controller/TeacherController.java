package com.aulabase.controller;

import com.aulabase.dto.CourseDto;
import com.aulabase.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/teachers")
@RequiredArgsConstructor
public class TeacherController {

    private final CourseService courseService;

    @GetMapping("/me/courses")
    @PreAuthorize("hasRole('MAESTRO')")
    public ResponseEntity<List<CourseDto>> getMyTeacherCourses() {
        List<CourseDto> courses = courseService.getTeacherCourses();
        return ResponseEntity.ok(courses);
    }
}

