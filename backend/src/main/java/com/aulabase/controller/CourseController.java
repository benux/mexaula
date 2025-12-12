package com.aulabase.controller;

import com.aulabase.dto.CourseDto;
import com.aulabase.dto.CourseRequest;
import com.aulabase.service.CourseService;
import com.aulabase.service.EnrollmentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/courses")
@RequiredArgsConstructor
public class CourseController {

    private final CourseService courseService;
    private final EnrollmentService enrollmentService;

    @GetMapping
    public ResponseEntity<List<CourseDto>> getAllCourses() {
        List<CourseDto> courses = courseService.getAllCourses();
        return ResponseEntity.ok(courses);
    }

    @GetMapping("/{id}")
    public ResponseEntity<CourseDto> getCourseById(@PathVariable Long id) {
        CourseDto course = courseService.getCourseById(id);
        return ResponseEntity.ok(course);
    }

    @GetMapping("/my")
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<List<CourseDto>> getMyCourses() {
        List<CourseDto> courses = courseService.getStudentCourses();
        return ResponseEntity.ok(courses);
    }

    @PostMapping("/{id}/enroll")
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<Map<String, String>> enrollInCourse(@PathVariable Long id) {
        enrollmentService.enrollInCourse(id);
        return ResponseEntity.ok(Map.of("message", "Inscripción exitosa"));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'MAESTRO')")
    public ResponseEntity<CourseDto> createCourse(@Valid @RequestBody CourseRequest request) {
        CourseDto course = courseService.createCourse(request);
        return ResponseEntity.ok(course);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MAESTRO')")
    public ResponseEntity<CourseDto> updateCourse(
            @PathVariable Long id,
            @Valid @RequestBody CourseRequest request
    ) {
        CourseDto course = courseService.updateCourse(id, request);
        return ResponseEntity.ok(course);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MAESTRO')")
    public ResponseEntity<Map<String, String>> deleteCourse(@PathVariable Long id) {
        courseService.deleteCourse(id);
        return ResponseEntity.ok(Map.of("message", "Curso eliminado exitosamente"));
    }
}

