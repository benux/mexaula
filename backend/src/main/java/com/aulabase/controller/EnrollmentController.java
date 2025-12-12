package com.aulabase.controller;

import com.aulabase.dto.EnrollmentDto;
import com.aulabase.dto.ProgressUpdateRequest;
import com.aulabase.service.EnrollmentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/enrollments")
@RequiredArgsConstructor
public class EnrollmentController {

    private final EnrollmentService enrollmentService;

    @GetMapping("/my")
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<List<EnrollmentDto>> getMyEnrollments() {
        List<EnrollmentDto> enrollments = enrollmentService.getMyEnrollments();
        return ResponseEntity.ok(enrollments);
    }

    @PutMapping("/{id}/progress")
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<EnrollmentDto> updateProgress(
            @PathVariable Long id,
            @Valid @RequestBody ProgressUpdateRequest request
    ) {
        EnrollmentDto enrollment = enrollmentService.updateProgress(id, request);
        return ResponseEntity.ok(enrollment);
    }

    @GetMapping("/check/{courseId}")
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<Boolean> checkEnrollment(@PathVariable Long courseId) {
        boolean isEnrolled = enrollmentService.isEnrolledInCourse(courseId);
        return ResponseEntity.ok(isEnrolled);
    }
}

