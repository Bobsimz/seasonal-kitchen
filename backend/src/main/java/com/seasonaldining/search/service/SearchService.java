package com.seasonaldining.search.service;
import com.seasonaldining.ingredient.repository.IngredientRepository; import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.search.dto.response.*; import com.seasonaldining.search.entity.*; import com.seasonaldining.search.repository.*; import org.springframework.stereotype.Service; import org.springframework.transaction.annotation.Transactional;
import java.util.*; import java.util.stream.Stream;
@Service @Transactional(readOnly=true)
public class SearchService {
 private final IngredientRepository ingredients; private final RecipeRepository recipes;
 private final SearchKeywordRepository keywords; private final RecentSearchRepository recentSearches;
 public SearchService(IngredientRepository ingredients,RecipeRepository recipes,SearchKeywordRepository keywords,RecentSearchRepository recentSearches){this.ingredients=ingredients;this.recipes=recipes;this.keywords=keywords;this.recentSearches=recentSearches;}
 @Transactional public SearchResponse search(String query,String type,Long userId){
  SearchKeyword keyword=keywords.findByKeyword(query).orElseGet(()->new SearchKeyword(query)); keyword.increment(); keywords.save(keyword); if(userId!=null)recentSearches.save(new RecentSearch(userId,query));
  List<SearchItemResponse> ingredientItems=List.of(),recipeItems=List.of(),reelItems=List.of();
  if("ALL".equals(type)||"INGREDIENT".equals(type)) ingredientItems=ingredients.findTop20ByActiveTrueAndNameContainingIgnoreCaseOrderByIdDesc(query).stream().map(i->new SearchItemResponse("INGREDIENT",i.getId(),i.getName(),i.getCategory(),i.getImageUrl())).toList();
  if("ALL".equals(type)||"RECIPE".equals(type)) recipeItems=recipes.findTop20ByStatusAndTitleContainingIgnoreCaseOrderByIdDesc("PUBLISHED",query).stream().map(r->new SearchItemResponse("RECIPE",r.getId(),r.getTitle(),r.getDescription(),r.getImageUrl())).toList();
  return new SearchResponse(Stream.concat(ingredientItems.stream(),recipeItems.stream()).toList(),ingredientItems,recipeItems,reelItems,ingredientItems.size(),recipeItems.size(),reelItems.size());
 }
 public List<SearchKeywordResponse> trending(){return keywords.findTop10ByOrderBySearchCountDesc().stream().map(k->new SearchKeywordResponse(k.getKeyword(),k.getSearchCount())).toList();}
 public List<SearchKeywordResponse> recent(Long userId){return recentSearches.findTop10ByUserIdOrderByIdDesc(userId).stream().map(k->new SearchKeywordResponse(k.getKeyword(),0)).toList();}
}
