package com.seasonaldining.recipe.repository;

import com.seasonaldining.recipe.entity.RecipeTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface RecipeTagRepository extends JpaRepository<RecipeTag, Long> {

    /**
     * 필터 칩용 — 공개(PUBLISHED) 레시피에 달린 태그만(가나다순, 중복 제거).
     * 목록 API가 PUBLISHED만 노출하므로, 누르면 결과 없는 태그가 칩에 뜨지 않도록 조인 필터.
     */
    @Query("""
            select distinct t.tag from RecipeTag t
            where exists (select 1 from Recipe r where r.id = t.recipeId and r.status = 'PUBLISHED')
            order by t.tag
            """)
    List<String> findDistinctTags();
}
