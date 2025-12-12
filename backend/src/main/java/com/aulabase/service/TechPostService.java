package com.aulabase.service;

import com.aulabase.dto.TechPostDto;
import com.aulabase.dto.TechPostRequest;
import com.aulabase.exception.BadRequestException;
import com.aulabase.exception.ResourceNotFoundException;
import com.aulabase.model.EstadoTechPost;
import com.aulabase.model.TechPost;
import com.aulabase.model.Usuario;
import com.aulabase.repository.TechPostRepository;
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
public class TechPostService {

    private final TechPostRepository techPostRepository;
    private final UsuarioRepository usuarioRepository;

    // ========== CRUD para ADMIN/MAESTRO ==========

    @Transactional(readOnly = true)
    public List<TechPostDto> getAllTechPosts() {
        return techPostRepository.findAll().stream()
                .map(DtoMapper::toTechPostDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<TechPostDto> getPublishedTechPosts() {
        return techPostRepository.findByEstadoOrderByCreadoEnDesc(EstadoTechPost.PUBLISHED).stream()
                .map(DtoMapper::toTechPostDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public TechPostDto getTechPostById(Long id) {
        TechPost techPost = techPostRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Tech post no encontrado con id: " + id));
        return DtoMapper.toTechPostDto(techPost);
    }

    @Transactional(readOnly = true)
    public TechPostDto getTechPostBySlug(String slug) {
        TechPost techPost = techPostRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("Tech post no encontrado con slug: " + slug));
        return DtoMapper.toTechPostDto(techPost);
    }

    @Transactional
    public TechPostDto createTechPost(TechPostRequest request, Long autorId) {
        // Verificar que el slug no exista
        if (techPostRepository.existsBySlug(request.getSlug())) {
            throw new BadRequestException("Ya existe un tech post con el slug: " + request.getSlug());
        }

        Usuario autor = usuarioRepository.findById(autorId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con id: " + autorId));

        TechPost techPost = new TechPost();
        techPost.setTitulo(request.getTitulo());
        techPost.setResumen(request.getResumen());
        techPost.setContenidoMarkdown(request.getContenidoMarkdown());
        techPost.setSlug(request.getSlug());
        techPost.setCategoria(request.getCategoria());
        techPost.setEtiquetas(request.getEtiquetas());
        techPost.setEstado(request.getEstado());
        techPost.setAutor(autor);

        TechPost savedTechPost = techPostRepository.save(techPost);
        log.info("Tech post creado: {} (id: {})", savedTechPost.getTitulo(), savedTechPost.getId());
        return DtoMapper.toTechPostDto(savedTechPost);
    }

    @Transactional
    public TechPostDto updateTechPost(Long id, TechPostRequest request) {
        TechPost techPost = techPostRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Tech post no encontrado con id: " + id));

        // Verificar que el slug no esté siendo usado por otro post
        techPostRepository.findBySlug(request.getSlug())
                .ifPresent(existingPost -> {
                    if (!existingPost.getId().equals(id)) {
                        throw new BadRequestException("Ya existe un tech post con el slug: " + request.getSlug());
                    }
                });

        techPost.setTitulo(request.getTitulo());
        techPost.setResumen(request.getResumen());
        techPost.setContenidoMarkdown(request.getContenidoMarkdown());
        techPost.setSlug(request.getSlug());
        techPost.setCategoria(request.getCategoria());
        techPost.setEtiquetas(request.getEtiquetas());
        techPost.setEstado(request.getEstado());

        TechPost updatedTechPost = techPostRepository.save(techPost);
        log.info("Tech post actualizado: {} (id: {})", updatedTechPost.getTitulo(), updatedTechPost.getId());
        return DtoMapper.toTechPostDto(updatedTechPost);
    }

    @Transactional
    public void deleteTechPost(Long id) {
        if (!techPostRepository.existsById(id)) {
            throw new ResourceNotFoundException("Tech post no encontrado con id: " + id);
        }
        techPostRepository.deleteById(id);
        log.info("Tech post eliminado con id: {}", id);
    }

    // ========== Búsquedas adicionales ==========

    @Transactional(readOnly = true)
    public List<TechPostDto> getTechPostsByCategory(String categoria) {
        return techPostRepository.findByCategoriaAndEstadoOrderByCreadoEnDesc(categoria, EstadoTechPost.PUBLISHED).stream()
                .map(DtoMapper::toTechPostDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<TechPostDto> getTechPostsByAutor(Long autorId) {
        return techPostRepository.findByAutorIdOrderByCreadoEnDesc(autorId).stream()
                .map(DtoMapper::toTechPostDto)
                .collect(Collectors.toList());
    }
}

