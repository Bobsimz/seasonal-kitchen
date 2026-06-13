package com.seasonaldining.recipe.repository;

import com.seasonaldining.recipe.entity.Recipe;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.List;

public interface RecipeRepository extends JpaRepository<Recipe, Long> {

    Page<Recipe> findByStatus(String status, Pageable pageable);

    Optional<Recipe> findByIdAndStatus(Long id, String status);
    List<Recipe> findTop20ByStatusAndTitleContainingIgnoreCaseOrderByIdDesc(String status, String title);
    List<Recipe> findByIdInAndStatus(List<Long> ids, String status);

    /** 컬럼 기반 정렬(minutes/title 등)용 — 상태 + 선택적 태그 필터. 정렬은 Pageable 로 전달. */
    @Query("""
            select r from Recipe r
            where r.status = :status
              and (:tag is null or exists (
                    select 1 from RecipeTag t where t.recipeId = r.id and t.tag = :tag))
            """)
    Page<Recipe> findPublishedFiltered(@Param("status") String status,
                                       @Param("tag") String tag,
                                       Pageable pageable);

    /**
     * 찜(favorites, targetType=RECIPE) 개수 내림차순 — 파생값이라 네이티브로 조인 정렬.
     * 선택적 태그 필터. 정렬이 쿼리에 고정돼 있으므로 Pageable 에는 정렬을 넣지 않는다(page/size 만).
     */
    @Query(value = """
            select r.* from recipes r
            left join (
                select f.target_id as rid, count(*) as cnt
                from favorites f
                where f.target_type = 'RECIPE'
                group by f.target_id
            ) fav on fav.rid = r.id
            where r.status = :status
              and (:tag is null or exists (
                    select 1 from recipe_tags t where t.recipe_id = r.id and t.tag = :tag))
            order by coalesce(fav.cnt, 0) desc, r.id desc
            """,
            countQuery = """
            select count(*) from recipes r
            where r.status = :status
              and (:tag is null or exists (
                    select 1 from recipe_tags t where t.recipe_id = r.id and t.tag = :tag))
            """,
            nativeQuery = true)
    Page<Recipe> findPublishedOrderByLikesDesc(@Param("status") String status,
                                               @Param("tag") String tag,
                                               Pageable pageable);
}
