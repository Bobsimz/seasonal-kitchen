package com.seasonaldining.search.service;
import com.seasonaldining.ingredient.dto.response.IngredientCardResponse;
import com.seasonaldining.ingredient.repository.IngredientRepository; import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.ingredient.service.IngredientService; import com.seasonaldining.recipe.service.RecipeService;
import com.seasonaldining.recipe.dto.response.RecipeCardResponse;
import com.seasonaldining.product.service.ProductService;
import com.seasonaldining.search.dto.response.*; import com.seasonaldining.search.entity.*; import com.seasonaldining.search.repository.*; import org.springframework.stereotype.Service; import org.springframework.transaction.annotation.Transactional;
import java.util.*; import java.util.stream.Stream;
@Service @Transactional(readOnly=true)
public class SearchService {
 private final IngredientRepository ingredients; private final RecipeRepository recipes;
 private final SearchKeywordRepository keywords; private final RecentSearchRepository recentSearches;
 private final ProductService productService;
 private final IngredientService ingredientService; private final RecipeService recipeService;
 public SearchService(IngredientRepository ingredients,RecipeRepository recipes,SearchKeywordRepository keywords,RecentSearchRepository recentSearches,ProductService productService,IngredientService ingredientService,RecipeService recipeService){this.ingredients=ingredients;this.recipes=recipes;this.keywords=keywords;this.recentSearches=recentSearches;this.productService=productService;this.ingredientService=ingredientService;this.recipeService=recipeService;}
 @Transactional public SearchResponse search(String query,String type,Long userId){
  SearchKeyword keyword=keywords.findByKeyword(query).orElseGet(()->new SearchKeyword(query)); keyword.increment(); keywords.save(keyword); if(userId!=null)recentSearches.save(new RecentSearch(userId,query));
  List<IngredientCardResponse> ingredientCards=List.of(); List<RecipeCardResponse> recipeCards=List.of();
  List<SearchItemResponse> ingredientItems=List.of(),recipeItems=List.of(),reelItems=List.of(),productItems=List.of();
  if("ALL".equals(type)||"INGREDIENT".equals(type)){
   ingredientCards=ingredients.findTop20ByActiveTrueAndNameContainingIgnoreCaseOrderByIdDesc(query).stream().map(ingredientService::toCardResponse).toList();
   ingredientItems=ingredientCards.stream().map(c->new SearchItemResponse("INGREDIENT",c.id(),c.name(),c.category(),c.imageUrl())).toList();
  }
  if("ALL".equals(type)||"RECIPE".equals(type)){
   recipeCards=recipes.findTop20ByStatusAndTitleContainingIgnoreCaseOrderByIdDesc("PUBLISHED",query).stream().map(recipeService::toCardResponse).toList();
   recipeItems=recipeCards.stream().map(c->new SearchItemResponse("RECIPE",c.id(),c.title(),c.description(),c.imageUrl())).toList();
  }
  // 상품(producer_offers facade)은 type=PRODUCT에서만 검색 — ALL의 기존 동작(식재료+레시피) 보존
  if("PRODUCT".equals(type)) productItems=productService.searchCards(query,20).stream().map(c->new SearchItemResponse("PRODUCT",c.id(),c.name(),c.producerName(),c.imageUrl())).toList();
  List<SearchItemResponse> items=Stream.of(ingredientItems,recipeItems,productItems).flatMap(List::stream).toList();
  return new SearchResponse(items,ingredientCards,recipeCards,reelItems,ingredientCards.size(),recipeCards.size(),reelItems.size(),productItems,productItems.size());
 }
 public List<SearchKeywordResponse> trending(){return keywords.findTop10ByOrderBySearchCountDesc().stream().map(k->new SearchKeywordResponse(k.getKeyword(),k.getSearchCount())).toList();}
 public List<SearchKeywordResponse> recent(Long userId){return recentSearches.findTop10ByUserIdOrderByIdDesc(userId).stream().map(k->new SearchKeywordResponse(k.getKeyword(),0)).toList();}
}
