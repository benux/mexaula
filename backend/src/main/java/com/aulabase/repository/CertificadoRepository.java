package com.aulabase.repository;

import com.aulabase.model.Certificado;
import com.aulabase.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CertificadoRepository extends JpaRepository<Certificado, Long> {
    List<Certificado> findByAlumno(Usuario alumno);
    Optional<Certificado> findByCodigoVerificacion(String codigoVerificacion);
}

