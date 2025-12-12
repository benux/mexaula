package com.aulabase.service;

import com.aulabase.dto.*;
import com.aulabase.exception.BadRequestException;
import com.aulabase.exception.ResourceNotFoundException;
import com.aulabase.model.ConfiguracionParental;
import com.aulabase.model.Usuario;
import com.aulabase.model.VinculoParental;
import com.aulabase.repository.ConfiguracionParentalRepository;
import com.aulabase.repository.InscripcionRepository;
import com.aulabase.repository.UsuarioRepository;
import com.aulabase.repository.VinculoParentalRepository;
import com.aulabase.util.DtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ParentalService {

    private final VinculoParentalRepository vinculoParentalRepository;
    private final ConfiguracionParentalRepository configuracionParentalRepository;
    private final InscripcionRepository inscripcionRepository;
    private final UsuarioRepository usuarioRepository;
    private final AuthService authService;

    public List<ParentalLinkDto> getChildren() {
        Usuario padre = authService.getCurrentUserEntity();
        return vinculoParentalRepository.findByPadre(padre).stream()
                .map(DtoMapper::toParentalLinkDto)
                .collect(Collectors.toList());
    }

    public ChildProgressDto getChildProgress(Long childId) {
        Usuario padre = authService.getCurrentUserEntity();

        Usuario alumno = usuarioRepository.findById(childId)
                .orElseThrow(() -> new ResourceNotFoundException("Alumno no encontrado con id: " + childId));

        // Verificar que el padre tiene vínculo con el alumno
        vinculoParentalRepository.findByPadre(padre).stream()
                .filter(vinculo -> vinculo.getAlumno().getId().equals(childId))
                .findFirst()
                .orElseThrow(() -> new BadRequestException("No tiene permisos para ver el progreso de este alumno"));

        List<ChildCourseProgressDto> cursos = inscripcionRepository.findByAlumno(alumno).stream()
                .map(DtoMapper::toChildCourseProgressDto)
                .collect(Collectors.toList());

        ChildProgressDto dto = new ChildProgressDto();
        dto.setChildId(alumno.getId());
        dto.setChildNombre(alumno.getNombre() + " " + alumno.getApellido());
        dto.setCursos(cursos);

        return dto;
    }

    public ParentalSettingsDto getSettings() {
        Usuario padre = authService.getCurrentUserEntity();

        ConfiguracionParental config = configuracionParentalRepository.findByPadre(padre)
                .orElse(null);

        if (config == null) {
            ParentalSettingsDto dto = new ParentalSettingsDto();
            dto.setPadreId(padre.getId());
            return dto;
        }

        return DtoMapper.toParentalSettingsDto(config);
    }

    @Transactional
    public ParentalSettingsDto updateSettings(ParentalSettingsDto dto) {
        Usuario padre = authService.getCurrentUserEntity();

        ConfiguracionParental config = configuracionParentalRepository.findByPadre(padre)
                .orElse(new ConfiguracionParental());

        config.setPadre(padre);
        config.setNivelMaximoContenido(dto.getNivelMaximoContenido());
        config.setTiempoMaximoDiarioMin(dto.getTiempoMaximoDiarioMin());

        config = configuracionParentalRepository.save(config);
        return DtoMapper.toParentalSettingsDto(config);
    }

    @Transactional
    public ParentalLinkDto createLink(Long padreId, Long alumnoId) {
        Usuario padre = usuarioRepository.findById(padreId)
                .orElseThrow(() -> new ResourceNotFoundException("Padre no encontrado con id: " + padreId));

        Usuario alumno = usuarioRepository.findById(alumnoId)
                .orElseThrow(() -> new ResourceNotFoundException("Alumno no encontrado con id: " + alumnoId));

        boolean isPadre = padre.getRoles().stream()
                .anyMatch(rol -> rol.getNombre().equals("PADRE"));
        if (!isPadre) {
            throw new BadRequestException("El usuario especificado no es un padre");
        }

        boolean isAlumno = alumno.getRoles().stream()
                .anyMatch(rol -> rol.getNombre().equals("ALUMNO"));
        if (!isAlumno) {
            throw new BadRequestException("El usuario especificado no es un alumno");
        }

        VinculoParental vinculo = new VinculoParental();
        vinculo.setPadre(padre);
        vinculo.setAlumno(alumno);

        vinculo = vinculoParentalRepository.save(vinculo);
        return DtoMapper.toParentalLinkDto(vinculo);
    }

    @Transactional
    public void deleteLink(Long linkId) {
        VinculoParental vinculo = vinculoParentalRepository.findById(linkId)
                .orElseThrow(() -> new ResourceNotFoundException("Vínculo no encontrado con id: " + linkId));

        vinculoParentalRepository.delete(vinculo);
    }
}

