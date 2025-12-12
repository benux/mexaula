package com.aulabase.repository;

import com.aulabase.model.Curso;
import com.aulabase.model.Inscripcion;
import com.aulabase.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InscripcionRepository extends JpaRepository<Inscripcion, Long> {
    List<Inscripcion> findByAlumno(Usuario alumno);
    List<Inscripcion> findByCurso(Curso curso);
    Optional<Inscripcion> findByCursoAndAlumno(Curso curso, Usuario alumno);
    boolean existsByCursoAndAlumno(Curso curso, Usuario alumno);
}

