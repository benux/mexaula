package com.aulabase.service;

import com.aulabase.dto.EnrollmentDto;
import com.aulabase.dto.ProgressUpdateRequest;
import com.aulabase.exception.BadRequestException;
import com.aulabase.exception.ResourceNotFoundException;
import com.aulabase.model.Curso;
import com.aulabase.model.Inscripcion;
import com.aulabase.model.Usuario;
import com.aulabase.repository.CursoRepository;
import com.aulabase.repository.InscripcionRepository;
import com.aulabase.util.DtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EnrollmentService {

    private final InscripcionRepository inscripcionRepository;
    private final CursoRepository cursoRepository;
    private final AuthService authService;

    public List<EnrollmentDto> getMyEnrollments() {
        Usuario alumno = authService.getCurrentUserEntity();
        return inscripcionRepository.findByAlumno(alumno).stream()
                .map(DtoMapper::toEnrollmentDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public EnrollmentDto enrollInCourse(Long cursoId) {
        Usuario alumno = authService.getCurrentUserEntity();

        Curso curso = cursoRepository.findById(cursoId)
                .orElseThrow(() -> new ResourceNotFoundException("Curso no encontrado con id: " + cursoId));

        if (!curso.isPublicado()) {
            throw new BadRequestException("No se puede inscribir en un curso no publicado");
        }

        if (inscripcionRepository.existsByCursoAndAlumno(curso, alumno)) {
            throw new BadRequestException("Ya está inscrito en este curso");
        }

        Inscripcion inscripcion = new Inscripcion();
        inscripcion.setCurso(curso);
        inscripcion.setAlumno(alumno);
        inscripcion.setProgresoPorcentaje(0.0);
        inscripcion.setCompletado(false);

        inscripcion = inscripcionRepository.save(inscripcion);
        return DtoMapper.toEnrollmentDto(inscripcion);
    }

    @Transactional
    public EnrollmentDto updateProgress(Long enrollmentId, ProgressUpdateRequest request) {
        Inscripcion inscripcion = inscripcionRepository.findById(enrollmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Inscripción no encontrada con id: " + enrollmentId));

        Usuario currentUser = authService.getCurrentUserEntity();
        if (!inscripcion.getAlumno().getId().equals(currentUser.getId())) {
            throw new BadRequestException("No tiene permisos para actualizar esta inscripción");
        }

        inscripcion.setProgresoPorcentaje(request.getProgresoPorcentaje());

        if (request.getProgresoPorcentaje() >= 100.0) {
            inscripcion.setCompletado(true);
            inscripcion.setProgresoPorcentaje(100.0);
        } else {
            inscripcion.setCompletado(false);
        }

        inscripcion = inscripcionRepository.save(inscripcion);
        return DtoMapper.toEnrollmentDto(inscripcion);
    }

    public boolean isEnrolledInCourse(Long cursoId) {
        Usuario alumno = authService.getCurrentUserEntity();
        Curso curso = cursoRepository.findById(cursoId)
                .orElseThrow(() -> new ResourceNotFoundException("Curso no encontrado con id: " + cursoId));
        return inscripcionRepository.existsByCursoAndAlumno(curso, alumno);
    }
}

