package com.seasonaldining.search.service;
import com.seasonaldining.ingredient.repository.IngredientRepository; import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.product.service.ProductService;
import com.seasonaldining.search.dto.response.*; import com.seasonaldining.search.entity.*; import com.seasonaldining.search.repository.*; import org.springframework.stereotype.Service; import org.springframework.transaction.annotation.Transactional;
import java.util.*; import java.util.stream.Stream;
@Service @Transactional(readOnly=true)
public class SearchService {
 private final IngredientRepository ingredients; private final RecipeRepository recipes;
 private final SearchKeywordRepository keywords; private final RecentSearchRepository recentSearches;
 private final ProductService productService;
 public SearchService(IngredientRepository ingredients,RecipeRepository recipes,SearchKeywordRepository keywords,RecentSearchRepository recentSearches,ProductService productService){this.ingredients=ingredients;this.recipes=recipes;this.keywords=keywords;this.recentSearches=recentSearches;this.productService=productService;}
 @Transactional public SearchResponse search(String query,String type,Long userId){
  SearchKeyword keyword=keywords.findByKeyword(query).orElseGet(()->new SearchKeyword(query)); keyword.increment(); keywords.save(keyword); if(userId!=null)recentSearches.save(new RecentSearch(userId,query));
  List<SearchItemResponse> ingredientItems=List.of(),recipeItems=List.of(),reelItems=List.of(),productItems=List.of();
  if("ALL".equals(type)||"INGREDIENT".equals(type)) ingredientItems=ingredients.findTop20ByActiveTrueAndNameContainingIgnoreCaseOrderByIdDesc(query).stream().map(i->new SearchItemResponse("INGREDIENT",i.getId(),i.getName(),i.getCategory(),i.getImageUrl())).toList();
  if("ALL".equals(type)||"RECIPE".equals(type)) recipeItems=recipes.findTop20ByStatusAndTitleContainingIgnoreCaseOrderByIdDesc("PUBLISHED",query).stream().map(r->new SearchItemResponse("RECIPE",r.getId(),r.getTitle(),r.getDescription(),r.getImageUrl())).toList();
  // 상품(producer_offers facade)은 type=PRODUCT에서만 검색 — ALL의 기존 동작(식재료+레시피) 보존
  if("PRODUCT".equals(type)) productItems=productService.searchCards(query,20).stream().map(c->new SearchItemResponse("PRODUCT",c.id(),c.name(),c.producerName(),c.imageUrl())).toList();
  List<SearchItemResponse> items=Stream.of(ingredientItems,recipeItems,productItems).flatMap(List::stream).toList();
  return new SearchResponse(items,ingredientItems,recipeItems,reelItems,ingredientItems.size(),recipeItems.size(),reelItems.size(),productItems,productItems.size());
 }
 public List<SearchKeywordResponse> trending(){return keywords.findTop10ByOrderBySearchCountDesc().stream().map(k->new SearchKeywordResponse(k.getKeyword(),k.getSearchCount())).toList();}
 public List<SearchKeywordResponse> recent(Long userId){return recentSearches.findTop10ByUserIdOrderByIdDesc(userId).stream().map(k->new SearchKeywordResponse(k.getKeyword(),0)).toList();}
}
