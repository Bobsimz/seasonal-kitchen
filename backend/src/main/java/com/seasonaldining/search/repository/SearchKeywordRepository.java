package com.seasonaldining.search.repository;
import com.seasonaldining.search.entity.SearchKeyword; import org.springframework.data.jpa.repository.JpaRepository; import java.util.*;
public interface SearchKeywordRepository extends JpaRepository<SearchKeyword,Long>{Optional<SearchKeyword> findByKeyword(String keyword); List<SearchKeyword> findTop10ByOrderBySearchCountDesc();}
