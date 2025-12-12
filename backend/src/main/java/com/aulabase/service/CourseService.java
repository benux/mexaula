package com.aulabase.service;

import com.aulabase.dto.CourseDto;
import com.aulabase.dto.CourseRequest;
import com.aulabase.exception.BadRequestException;
import com.aulabase.exception.ResourceNotFoundException;
import com.aulabase.model.Curso;
import com.aulabase.model.Rol;
import com.aulabase.model.Usuario;
import com.aulabase.repository.CursoRepository;
import com.aulabase.repository.InscripcionRepository;
import com.aulabase.repository.UsuarioRepository;
import com.aulabase.util.DtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseService {

    private final CursoRepository cursoRepository;
    private final UsuarioRepository usuarioRepository;
    private final InscripcionRepository inscripcionRepository;
    private final AuthService authService;

    public List<CourseDto> getAllCourses() {
        Usuario currentUser = authService.getCurrentUserEntity();
        boolean isAdmin = currentUser.getRoles().stream()
                .anyMatch(rol -> rol.getNombre().equals("ADMIN"));

        List<Curso> cursos;
        if (isAdmin) {
            cursos = cursoRepository.findAll();
        } else {
            cursos = cursoRepository.findByPublicadoTrue();
        }

        return cursos.stream()
                .map(DtoMapper::toCourseDto)
                .collect(Collectors.toList());
    }

    public CourseDto getCourseById(Long id) {
        Curso curso = cursoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Curso no encontrado con id: " + id));
        return DtoMapper.toCourseDto(curso);
    }

    public List<CourseDto> getTeacherCourses() {
        Usuario maestro = authService.getCurrentUserEntity();
        return cursoRepository.findByMaestro(maestro).stream()
                .map(DtoMapper::toCourseDto)
                .collect(Collectors.toList());
    }

    public List<CourseDto> getStudentCourses() {
        Usuario alumno = authService.getCurrentUserEntity();
        return inscripcionRepository.findByAlumno(alumno).stream()
                .map(inscripcion -> DtoMapper.toCourseDto(inscripcion.getCurso()))
                .collect(Collectors.toList());
    }

    @Transactional
    public CourseDto createCourse(CourseRequest request) {
        Usuario currentUser = authService.getCurrentUserEntity();
        boolean isAdmin = currentUser.getRoles().stream()
                .anyMatch(rol -> rol.getNombre().equals("ADMIN"));

        Usuario maestro;
        if (isAdmin && request.getMaestroId() != null) {
            maestro = usuarioRepository.findById(request.getMaestroId())
                    .orElseThrow(() -> new ResourceNotFoundException("Maestro no encontrado con id: " + request.getMaestroId()));

            boolean isMaestro = maestro.getRoles().stream()
                    .anyMatch(rol -> rol.getNombre().equals("MAESTRO"));
            if (!isMaestro) {
                throw new BadRequestException("El usuario especificado no es un maestro");
            }
        } else {
            maestro = currentUser;
        }

        Curso curso = new Curso();
        curso.setTitulo(request.getTitulo());
        curso.setDescripcion(request.getDescripcion());
        curso.setNivel(request.getNivel().toUpperCase());
        curso.setPublicado(request.getPublicado());
        curso.setMaestro(maestro);

        curso = cursoRepository.save(curso);
        return DtoMapper.toCourseDto(curso);
    }

    @Transactional
    public CourseDto updateCourse(Long id, CourseRequest request) {
        Curso curso = cursoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Curso no encontrado con id: " + id));

        Usuario currentUser = authService.getCurrentUserEntity();
        boolean isAdmin = currentUser.getRoles().stream()
                .anyMatch(rol -> rol.getNombre().equals("ADMIN"));

        if (!isAdmin && !curso.getMaestro().getId().equals(currentUser.getId())) {
            throw new AccessDeniedException("No tiene permisos para editar este curso");
        }

        curso.setTitulo(request.getTitulo());
        curso.setDescripcion(request.getDescripcion());
        curso.setNivel(request.getNivel().toUpperCase());
        curso.setPublicado(request.getPublicado());

        if (isAdmin && request.getMaestroId() != null) {
            Usuario maestro = usuarioRepository.findById(request.getMaestroId())
                    .orElseThrow(() -> new ResourceNotFoundException("Maestro no encontrado con id: " + request.getMaestroId()));
            curso.setMaestro(maestro);
        }

        curso = cursoRepository.save(curso);
        return DtoMapper.toCourseDto(curso);
    }

    @Transactional
    public void deleteCourse(Long id) {
        Curso curso = cursoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Curso no encontrado con id: " + id));

        Usuario currentUser = authService.getCurrentUserEntity();
        boolean isAdmin = currentUser.getRoles().stream()
                .anyMatch(rol -> rol.getNombre().equals("ADMIN"));

        if (!isAdmin && !curso.getMaestro().getId().equals(currentUser.getId())) {
            throw new AccessDeniedException("No tiene permisos para eliminar este curso");
        }

        cursoRepository.delete(curso);
    }
}

