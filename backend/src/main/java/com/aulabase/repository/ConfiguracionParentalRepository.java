package com.aulabase.repository;

import com.aulabase.model.ConfiguracionParental;
import com.aulabase.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ConfiguracionParentalRepository extends JpaRepository<ConfiguracionParental, Long> {
    Optional<ConfiguracionParental> findByPadre(Usuario padre);
}

