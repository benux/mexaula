package com.aulabase.repository;

import com.aulabase.model.Logro;
import com.aulabase.model.TipoLogro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LogroRepository extends JpaRepository<Logro, Long> {

    List<Logro> findByActivoTrue();

    List<Logro> findByTipo(TipoLogro tipo);

    Optional<Logro> findByCriterioCodigo(String criterioCodigo);

    List<Logro> findByActivoTrueOrderByPuntosDesc();
}

