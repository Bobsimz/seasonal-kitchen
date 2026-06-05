package com.seasonaldining.search.repository;
import com.seasonaldining.search.entity.RecentSearch; import org.springframework.data.jpa.repository.JpaRepository; import java.util.List;
public interface RecentSearchRepository extends JpaRepository<RecentSearch,Long>{List<RecentSearch> findTop10ByUserIdOrderByIdDesc(Long userId);}
