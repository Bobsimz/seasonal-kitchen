package com.seasonaldining.ingredient.repository;

import com.seasonaldining.ingredient.entity.Ingredient;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.List;

public interface IngredientRepository extends JpaRepository<Ingredient, Long> {

    Page<Ingredient> findByActiveTrue(Pageable pageable);

    Optional<Ingredient> findByIdAndActiveTrue(Long id);
    List<Ingredient> findTop20ByActiveTrueAndNameContainingIgnoreCaseOrderByIdDesc(String name);
    List<Ingredient> findByIdInAndActiveTrue(List<Long> ids);
    List<Ingredient> findByNameInAndActiveTrue(List<String> names);

    /** 컬럼 정렬(name 등)용 — 활성 + 선택적 카테고리 필터. 정렬은 Pageable 로 전달. */
    @Query("""
            select i from Ingredient i
            where i.active = true and (:category is null or i.category = :category)
            """)
    Page<Ingredient> findActiveFiltered(@Param("category") String category, Pageable pageable);

    /** 필터 칩용 — 활성 식재료의 카테고리 목록(가나다순). */
    @Query("select distinct i.category from Ingredient i where i.active = true order by i.category")
    List<String> findDistinctCategories();

    /**
     * 가격 오름차순 — 최신 스냅샷 가격(파생값) 기준. 상관 서브쿼리로 정렬(H2/Postgres 공통).
     * 정렬이 쿼리에 고정되므로 Pageable 은 page/size 만 전달한다.
     */
    @Query(value = """
            select i.* from ingredients i
            where i.active = true and (:category is null or i.category = :category)
            order by (
                select ps.price from price_snapshots ps
                where ps.ingredient_id = i.id
                order by ps.observed_date desc, ps.id desc
                limit 1
            ) asc nulls last, i.id asc
            """,
            countQuery = """
            select count(*) from ingredients i
            where i.active = true and (:category is null or i.category = :category)
            """,
            nativeQuery = true)
    Page<Ingredient> findActiveOrderByPriceAsc(@Param("category") String category, Pageable pageable);

    /** 가격 내림차순 — 위와 동일하되 내림차순. */
    @Query(value = """
            select i.* from ingredients i
            where i.active = true and (:category is null or i.category = :category)
            order by (
                select ps.price from price_snapshots ps
                where ps.ingredient_id = i.id
                order by ps.observed_date desc, ps.id desc
                limit 1
            ) desc nulls last, i.id asc
            """,
            countQuery = """
            select count(*) from ingredients i
            where i.active = true and (:category is null or i.category = :category)
            """,
            nativeQuery = true)
    Page<Ingredient> findActiveOrderByPriceDesc(@Param("category") String category, Pageable pageable);
}
