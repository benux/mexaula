package com.aulabase.repository;

import com.aulabase.model.EstadoTechPost;
import com.aulabase.model.TechPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TechPostRepository extends JpaRepository<TechPost, Long> {

    List<TechPost> findByEstadoOrderByCreadoEnDesc(EstadoTechPost estado);

    Optional<TechPost> findBySlug(String slug);

    List<TechPost> findByAutorIdOrderByCreadoEnDesc(Long autorId);

    List<TechPost> findByCategoriaAndEstadoOrderByCreadoEnDesc(String categoria, EstadoTechPost estado);

    boolean existsBySlug(String slug);
}

