package com.seasonaldining.curation.repository;

import com.seasonaldining.curation.entity.Curation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CurationRepository extends JpaRepository<Curation, Long> {

    List<Curation> findByActiveTrueOrderByDisplayOrderAscIdAsc();

    Optional<Curation> findByIdAndActiveTrue(Long id);
}
