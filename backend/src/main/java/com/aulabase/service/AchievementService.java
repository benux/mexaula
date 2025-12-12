package com.aulabase.service;

import com.aulabase.dto.LogroDto;
import com.aulabase.dto.LogroRequest;
import com.aulabase.dto.LogroUsuarioDto;
import com.aulabase.exception.BadRequestException;
import com.aulabase.exception.ResourceNotFoundException;
import com.aulabase.model.Logro;
import com.aulabase.model.LogroUsuario;
import com.aulabase.model.Usuario;
import com.aulabase.repository.LogroRepository;
import com.aulabase.repository.LogroUsuarioRepository;
import com.aulabase.repository.UsuarioRepository;
import com.aulabase.util.DtoMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AchievementService {

    private final LogroRepository logroRepository;
    private final LogroUsuarioRepository logroUsuarioRepository;
    private final UsuarioRepository usuarioRepository;

    // ========== CRUD de Logros (ADMIN) ==========

    @Transactional(readOnly = true)
    public List<LogroDto> getAllLogros() {
        return logroRepository.findAll().stream()
                .map(DtoMapper::toLogroDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<LogroDto> getActiveLogros() {
        return logroRepository.findByActivoTrueOrderByPuntosDesc().stream()
                .map(DtoMapper::toLogroDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public LogroDto getLogroById(Long id) {
        Logro logro = logroRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Logro no encontrado con id: " + id));
        return DtoMapper.toLogroDto(logro);
    }

    @Transactional
    public LogroDto createLogro(LogroRequest request) {
        // Verificar que el criterio código no exista
        if (logroRepository.findByCriterioCodigo(request.getCriterioCodigo()).isPresent()) {
            throw new BadRequestException("Ya existe un logro con el criterio código: " + request.getCriterioCodigo());
        }

        Logro logro = new Logro();
        logro.setTitulo(request.getTitulo());
        logro.setDescripcion(request.getDescripcion());
        logro.setIconoUrl(request.getIconoUrl());
        logro.setTipo(request.getTipo());
        logro.setCriterioCodigo(request.getCriterioCodigo());
        logro.setPuntos(request.getPuntos());
        logro.setActivo(request.getActivo() != null ? request.getActivo() : true);

        Logro savedLogro = logroRepository.save(logro);
        log.info("Logro creado: {} (id: {})", savedLogro.getTitulo(), savedLogro.getId());
        return DtoMapper.toLogroDto(savedLogro);
    }

    @Transactional
    public LogroDto updateLogro(Long id, LogroRequest request) {
        Logro logro = logroRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Logro no encontrado con id: " + id));

        // Verificar que el criterio código no esté siendo usado por otro logro
        logroRepository.findByCriterioCodigo(request.getCriterioCodigo())
                .ifPresent(existingLogro -> {
                    if (!existingLogro.getId().equals(id)) {
                        throw new BadRequestException("Ya existe un logro con el criterio código: " + request.getCriterioCodigo());
                    }
                });

        logro.setTitulo(request.getTitulo());
        logro.setDescripcion(request.getDescripcion());
        logro.setIconoUrl(request.getIconoUrl());
        logro.setTipo(request.getTipo());
        logro.setCriterioCodigo(request.getCriterioCodigo());
        logro.setPuntos(request.getPuntos());
        logro.setActivo(request.getActivo() != null ? request.getActivo() : true);

        Logro updatedLogro = logroRepository.save(logro);
        log.info("Logro actualizado: {} (id: {})", updatedLogro.getTitulo(), updatedLogro.getId());
        return DtoMapper.toLogroDto(updatedLogro);
    }

    @Transactional
    public void deleteLogro(Long id) {
        if (!logroRepository.existsById(id)) {
            throw new ResourceNotFoundException("Logro no encontrado con id: " + id);
        }
        logroRepository.deleteById(id);
        log.info("Logro eliminado con id: {}", id);
    }

    // ========== Logros del Alumno ==========

    @Transactional(readOnly = true)
    public List<LogroUsuarioDto> getAlumnoLogros(Long alumnoId) {
        Usuario alumno = usuarioRepository.findById(alumnoId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con id: " + alumnoId));

        return logroUsuarioRepository.findByAlumnoIdOrderByFechaObtenidoDesc(alumnoId).stream()
                .map(DtoMapper::toLogroUsuarioDto)
                .collect(Collectors.toList());
    }

    // ========== Otorgar Logro (automatizado) ==========

    @Transactional
    public void grantAchievementIfNeeded(String criterioCodigo, Usuario alumno) {
        // Buscar el logro por criterio
        Logro logro = logroRepository.findByCriterioCodigo(criterioCodigo).orElse(null);

        if (logro == null || !logro.getActivo()) {
            log.debug("Logro no encontrado o inactivo: {}", criterioCodigo);
            return;
        }

        // Verificar si el alumno ya tiene el logro
        if (logroUsuarioRepository.existsByLogroIdAndAlumnoId(logro.getId(), alumno.getId())) {
            log.debug("El alumno {} ya tiene el logro {}", alumno.getId(), criterioCodigo);
            return;
        }

        // Otorgar el logro
        LogroUsuario logroUsuario = new LogroUsuario();
        logroUsuario.setLogro(logro);
        logroUsuario.setAlumno(alumno);
        logroUsuario.setCompartidoVeces(0);

        logroUsuarioRepository.save(logroUsuario);
        log.info("Logro '{}' otorgado al alumno {} (id: {})", logro.getTitulo(), alumno.getNombre(), alumno.getId());
    }

    // ========== Compartir Logro ==========

    @Transactional
    public void incrementShareCount(Long logroUsuarioId) {
        LogroUsuario logroUsuario = logroUsuarioRepository.findById(logroUsuarioId)
                .orElseThrow(() -> new ResourceNotFoundException("Logro de usuario no encontrado con id: " + logroUsuarioId));

        logroUsuario.setCompartidoVeces(logroUsuario.getCompartidoVeces() + 1);
        logroUsuarioRepository.save(logroUsuario);
        log.info("Incrementado contador de compartidos para logro de usuario id: {}", logroUsuarioId);
    }

    // ========== Estadísticas del Alumno ==========

    @Transactional(readOnly = true)
    public long countAlumnoLogros(Long alumnoId) {
        return logroUsuarioRepository.countByAlumnoId(alumnoId);
    }

    @Transactional(readOnly = true)
    public Integer getTotalPuntosAlumno(Long alumnoId) {
        Integer puntos = logroUsuarioRepository.sumPuntosByAlumnoId(alumnoId);
        return puntos != null ? puntos : 0;
    }
}

