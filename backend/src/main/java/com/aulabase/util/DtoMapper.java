package com.aulabase.util;

import com.aulabase.dto.*;
import com.aulabase.model.*;

import java.util.List;
import java.util.stream.Collectors;

public class DtoMapper {

    public static UserDto toUserDto(Usuario usuario) {
        UserDto dto = new UserDto();
        dto.setId(usuario.getId());
        dto.setNombre(usuario.getNombre());
        dto.setApellido(usuario.getApellido());
        dto.setEmail(usuario.getEmail());
        dto.setActivo(usuario.isActivo());
        dto.setRoles(usuario.getRoles().stream()
                .map(Rol::getNombre)
                .collect(Collectors.toList()));
        return dto;
    }

    public static CourseDto toCourseDto(Curso curso) {
        CourseDto dto = new CourseDto();
        dto.setId(curso.getId());
        dto.setTitulo(curso.getTitulo());
        dto.setDescripcion(curso.getDescripcion());
        dto.setNivel(curso.getNivel());
        dto.setPublicado(curso.isPublicado());
        dto.setMaestroId(curso.getMaestro().getId());
        dto.setMaestroNombre(curso.getMaestro().getNombre() + " " + curso.getMaestro().getApellido());
        dto.setCreadoEn(curso.getCreadoEn());
        dto.setActualizadoEn(curso.getActualizadoEn());
        return dto;
    }

    public static EnrollmentDto toEnrollmentDto(Inscripcion inscripcion) {
        EnrollmentDto dto = new EnrollmentDto();
        dto.setId(inscripcion.getId());
        dto.setCursoId(inscripcion.getCurso().getId());
        dto.setCursoTitulo(inscripcion.getCurso().getTitulo());
        dto.setAlumnoId(inscripcion.getAlumno().getId());
        dto.setAlumnoNombre(inscripcion.getAlumno().getNombre() + " " + inscripcion.getAlumno().getApellido());
        dto.setProgresoPorcentaje(inscripcion.getProgresoPorcentaje());
        dto.setCompletado(inscripcion.isCompletado());
        dto.setInscritoEn(inscripcion.getInscritoEn());
        dto.setActualizadoEn(inscripcion.getActualizadoEn());
        return dto;
    }

    public static CertificateDto toCertificateDto(Certificado certificado) {
        CertificateDto dto = new CertificateDto();
        dto.setId(certificado.getId());
        dto.setAlumnoId(certificado.getAlumno().getId());
        dto.setAlumnoNombre(certificado.getAlumno().getNombre() + " " + certificado.getAlumno().getApellido());
        dto.setCursoId(certificado.getCurso().getId());
        dto.setCursoTitulo(certificado.getCurso().getTitulo());
        dto.setCodigoVerificacion(certificado.getCodigoVerificacion());
        dto.setFechaEmision(certificado.getFechaEmision());
        return dto;
    }

    public static ParentalLinkDto toParentalLinkDto(VinculoParental vinculo) {
        ParentalLinkDto dto = new ParentalLinkDto();
        dto.setId(vinculo.getId());
        dto.setPadreId(vinculo.getPadre().getId());
        dto.setAlumnoId(vinculo.getAlumno().getId());
        dto.setAlumnoNombre(vinculo.getAlumno().getNombre() + " " + vinculo.getAlumno().getApellido());
        dto.setCreadoEn(vinculo.getCreadoEn());
        return dto;
    }

    public static ParentalSettingsDto toParentalSettingsDto(ConfiguracionParental config) {
        ParentalSettingsDto dto = new ParentalSettingsDto();
        dto.setId(config.getId());
        dto.setPadreId(config.getPadre().getId());
        dto.setNivelMaximoContenido(config.getNivelMaximoContenido());
        dto.setTiempoMaximoDiarioMin(config.getTiempoMaximoDiarioMin());
        dto.setCreadoEn(config.getCreadoEn());
        dto.setActualizadoEn(config.getActualizadoEn());
        return dto;
    }

    public static ChildCourseProgressDto toChildCourseProgressDto(Inscripcion inscripcion) {
        ChildCourseProgressDto dto = new ChildCourseProgressDto();
        dto.setCursoId(inscripcion.getCurso().getId());
        dto.setTitulo(inscripcion.getCurso().getTitulo());
        dto.setProgresoPorcentaje(inscripcion.getProgresoPorcentaje());
        dto.setCompletado(inscripcion.isCompletado());
        return dto;
    }

    public static LogroDto toLogroDto(Logro logro) {
        LogroDto dto = new LogroDto();
        dto.setId(logro.getId());
        dto.setTitulo(logro.getTitulo());
        dto.setDescripcion(logro.getDescripcion());
        dto.setIconoUrl(logro.getIconoUrl());
        dto.setTipo(logro.getTipo());
        dto.setCriterioCodigo(logro.getCriterioCodigo());
        dto.setPuntos(logro.getPuntos());
        dto.setActivo(logro.getActivo());
        dto.setCreadoEn(logro.getCreadoEn());
        dto.setActualizadoEn(logro.getActualizadoEn());
        return dto;
    }

    public static LogroUsuarioDto toLogroUsuarioDto(LogroUsuario logroUsuario) {
        LogroUsuarioDto dto = new LogroUsuarioDto();
        dto.setId(logroUsuario.getId());
        dto.setLogro(toLogroDto(logroUsuario.getLogro()));
        dto.setAlumnoId(logroUsuario.getAlumno().getId());
        dto.setAlumnoNombre(logroUsuario.getAlumno().getNombre() + " " + logroUsuario.getAlumno().getApellido());
        dto.setFechaObtenido(logroUsuario.getFechaObtenido());
        dto.setCompartidoVeces(logroUsuario.getCompartidoVeces());
        return dto;
    }

    public static TechPostDto toTechPostDto(TechPost techPost) {
        TechPostDto dto = new TechPostDto();
        dto.setId(techPost.getId());
        dto.setTitulo(techPost.getTitulo());
        dto.setResumen(techPost.getResumen());
        dto.setContenidoMarkdown(techPost.getContenidoMarkdown());
        dto.setSlug(techPost.getSlug());
        dto.setCategoria(techPost.getCategoria());
        dto.setEtiquetas(techPost.getEtiquetas());
        dto.setEstado(techPost.getEstado());
        dto.setAutorId(techPost.getAutor().getId());
        dto.setAutorNombre(techPost.getAutor().getNombre() + " " + techPost.getAutor().getApellido());
        dto.setCreadoEn(techPost.getCreadoEn());
        dto.setActualizadoEn(techPost.getActualizadoEn());
        return dto;
    }
}

