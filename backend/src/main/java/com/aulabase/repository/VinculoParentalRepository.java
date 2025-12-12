package com.aulabase.repository;

import com.aulabase.model.Usuario;
import com.aulabase.model.VinculoParental;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VinculoParentalRepository extends JpaRepository<VinculoParental, Long> {
    List<VinculoParental> findByPadre(Usuario padre);
    List<VinculoParental> findByAlumno(Usuario alumno);
}

