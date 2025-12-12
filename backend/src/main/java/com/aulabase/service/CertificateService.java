package com.aulabase.service;

import com.aulabase.dto.CertificateDto;
import com.aulabase.dto.CertificateRequest;
import com.aulabase.exception.BadRequestException;
import com.aulabase.exception.ResourceNotFoundException;
import com.aulabase.model.Certificado;
import com.aulabase.model.Curso;
import com.aulabase.model.Inscripcion;
import com.aulabase.model.Usuario;
import com.aulabase.repository.CertificadoRepository;
import com.aulabase.repository.CursoRepository;
import com.aulabase.repository.InscripcionRepository;
import com.aulabase.util.DtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CertificateService {

    private final CertificadoRepository certificadoRepository;
    private final InscripcionRepository inscripcionRepository;
    private final CursoRepository cursoRepository;
    private final AuthService authService;

    public List<CertificateDto> getMyCertificates() {
        Usuario alumno = authService.getCurrentUserEntity();
        return certificadoRepository.findByAlumno(alumno).stream()
                .map(DtoMapper::toCertificateDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public CertificateDto generateCertificate(CertificateRequest request) {
        Usuario alumno = authService.getCurrentUserEntity();

        Curso curso = cursoRepository.findById(request.getCursoId())
                .orElseThrow(() -> new ResourceNotFoundException("Curso no encontrado con id: " + request.getCursoId()));

        Inscripcion inscripcion = inscripcionRepository.findByCursoAndAlumno(curso, alumno)
                .orElseThrow(() -> new BadRequestException("No está inscrito en este curso"));

        if (!inscripcion.isCompletado()) {
            throw new BadRequestException("Debe completar el curso antes de generar el certificado");
        }

        // Verificar si ya existe un certificado
        certificadoRepository.findByAlumno(alumno).stream()
                .filter(cert -> cert.getCurso().getId().equals(curso.getId()))
                .findFirst()
                .ifPresent(cert -> {
                    throw new BadRequestException("Ya existe un certificado para este curso");
                });

        String codigoVerificacion = UUID.randomUUID().toString().replace("-", "").substring(0, 16).toUpperCase();

        Certificado certificado = new Certificado();
        certificado.setAlumno(alumno);
        certificado.setCurso(curso);
        certificado.setCodigoVerificacion(codigoVerificacion);

        certificado = certificadoRepository.save(certificado);
        return DtoMapper.toCertificateDto(certificado);
    }

    public CertificateDto verifyCertificate(String codigo) {
        Certificado certificado = certificadoRepository.findByCodigoVerificacion(codigo)
                .orElseThrow(() -> new ResourceNotFoundException("Certificado no encontrado con código: " + codigo));
        return DtoMapper.toCertificateDto(certificado);
    }
}

