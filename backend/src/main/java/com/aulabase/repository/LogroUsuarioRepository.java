package com.aulabase.repository;

import com.aulabase.model.LogroUsuario;
import com.aulabase.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LogroUsuarioRepository extends JpaRepository<LogroUsuario, Long> {

    List<LogroUsuario> findByAlumnoIdOrderByFechaObtenidoDesc(Long alumnoId);

    List<LogroUsuario> findByAlumno(Usuario alumno);

    Optional<LogroUsuario> findByLogroIdAndAlumnoId(Long logroId, Long alumnoId);

    boolean existsByLogroIdAndAlumnoId(Long logroId, Long alumnoId);

    @Query("SELECT COUNT(lu) FROM LogroUsuario lu WHERE lu.alumno.id = :alumnoId")
    long countByAlumnoId(@Param("alumnoId") Long alumnoId);

    @Query("SELECT SUM(lu.logro.puntos) FROM LogroUsuario lu WHERE lu.alumno.id = :alumnoId")
    Integer sumPuntosByAlumnoId(@Param("alumnoId") Long alumnoId);
}

