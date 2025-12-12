package com.aulabase.repository;

import com.aulabase.model.Curso;
import com.aulabase.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CursoRepository extends JpaRepository<Curso, Long> {
    List<Curso> findByMaestro(Usuario maestro);
    List<Curso> findByPublicadoTrue();
}

