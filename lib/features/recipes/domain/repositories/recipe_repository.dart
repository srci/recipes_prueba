import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes();
  Future<Recipe> getRecipeById(String id);
  Future<List<Recipe>> searchRecipes(String query);
  Future<List<Recipe>> filterByCategory(String category);
  
  // Métodos para gestionar favoritos
  Future<List<Recipe>> getFavoriteRecipes();
  Future<void> addToFavorites(Recipe recipe);
  Future<void> removeFromFavorites(String recipeId);
  Future<bool> isFavorite(String recipeId);
} 