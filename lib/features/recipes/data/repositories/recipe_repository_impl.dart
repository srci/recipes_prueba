import '../../../../core/error/exceptions.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_data_source.dart';
import '../datasources/recipe_local_data_source.dart';
import '../models/recipe_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource, 
    required this.localDataSource
  });

  @override
  Future<List<Recipe>> getRecipes() async {
    try {
      final recipeModels = await remoteDataSource.getRecipes();
      return recipeModels;
    } on ServerException {
      throw Exception('Error al obtener las recetas del servidor');
    }
  }

  @override
  Future<Recipe> getRecipeById(String id) async {
    try {
      final recipeModel = await remoteDataSource.getRecipeById(id);
      return recipeModel;
    } on ServerException {
      throw Exception('Error al obtener la receta del servidor');
    }
  }
  
  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final recipeModels = await remoteDataSource.searchRecipes(query);
      return recipeModels;
    } on ServerException {
      throw Exception('Error al buscar recetas en el servidor');
    }
  }
  
  @override
  Future<List<Recipe>> filterByCategory(String category) async {
    try {
      final recipeModels = await remoteDataSource.filterByCategory(category);
      return recipeModels;
    } on ServerException {
      throw Exception('Error al filtrar recetas por categoría');
    }
  }
  
  @override
  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final favoriteRecipes = await localDataSource.getFavoriteRecipes();
      return favoriteRecipes;
    } on CacheException {
      throw Exception('Error al recuperar recetas favoritas');
    }
  }
  
  @override
  Future<void> addToFavorites(Recipe recipe) async {
    try {
      final recipeModel = recipe as RecipeModel;
      await localDataSource.saveFavoriteRecipe(recipeModel);
    } on CacheException {
      throw Exception('Error al guardar receta en favoritos');
    }
  }
  
  @override
  Future<void> removeFromFavorites(String recipeId) async {
    try {
      await localDataSource.removeFavoriteRecipe(recipeId);
    } on CacheException {
      throw Exception('Error al eliminar receta de favoritos');
    }
  }
  
  @override
  Future<bool> isFavorite(String recipeId) async {
    try {
      return await localDataSource.isFavoriteRecipe(recipeId);
    } on CacheException {
      throw Exception('Error al verificar si la receta es favorita');
    }
  }
} 