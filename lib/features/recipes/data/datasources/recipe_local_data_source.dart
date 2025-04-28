import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class RecipeLocalDataSource {
  /// Obtiene las recetas favoritas almacenadas localmente
  Future<List<RecipeModel>> getFavoriteRecipes();
  
  /// Guarda una receta como favorita
  Future<void> saveFavoriteRecipe(RecipeModel recipe);
  
  /// Elimina una receta de favoritos
  Future<void> removeFavoriteRecipe(String recipeId);
  
  /// Comprueba si una receta está en favoritos
  Future<bool> isFavoriteRecipe(String recipeId);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final SharedPreferences sharedPreferences;
  final String _favoritesKey = 'FAVORITE_RECIPES';
  
  RecipeLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<List<RecipeModel>> getFavoriteRecipes() async {
    try {
      final jsonString = sharedPreferences.getString(_favoritesKey);
      if (jsonString == null) {
        return [];
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((jsonRecipe) => RecipeModel.fromJson(jsonRecipe)).toList();
    } catch (e) {
      throw CacheException();
    }
  }
  
  @override
  Future<void> saveFavoriteRecipe(RecipeModel recipe) async {
    try {
      final List<RecipeModel> favorites = await getFavoriteRecipes();
      
      // Verificar si la receta ya existe en favoritos
      final existingIndex = favorites.indexWhere((fav) => fav.id == recipe.id);
      if (existingIndex >= 0) {
        return; // La receta ya está en favoritos
      }
      
      // Añadir la receta a favoritos
      favorites.add(recipe);
      
      // Convertir a json y guardar
      final List<Map<String, dynamic>> jsonList = favorites.map((recipe) => recipe.toJson()).toList();
      await sharedPreferences.setString(_favoritesKey, json.encode(jsonList));
    } catch (e) {
      throw CacheException();
    }
  }
  
  @override
  Future<void> removeFavoriteRecipe(String recipeId) async {
    try {
      final List<RecipeModel> favorites = await getFavoriteRecipes();
      
      // Filtrar la receta a eliminar
      final updatedFavorites = favorites.where((recipe) => recipe.id != recipeId).toList();
      
      // Convertir a json y guardar
      final List<Map<String, dynamic>> jsonList = updatedFavorites.map((recipe) => recipe.toJson()).toList();
      await sharedPreferences.setString(_favoritesKey, json.encode(jsonList));
    } catch (e) {
      throw CacheException();
    }
  }
  
  @override
  Future<bool> isFavoriteRecipe(String recipeId) async {
    try {
      final List<RecipeModel> favorites = await getFavoriteRecipes();
      return favorites.any((recipe) => recipe.id == recipeId);
    } catch (e) {
      throw CacheException();
    }
  }
} 