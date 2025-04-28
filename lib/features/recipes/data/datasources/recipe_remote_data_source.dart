import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class RecipeRemoteDataSource {
  /// Llama al endpoint para obtener la lista de recetas
  /// Lanza [ServerException] si hay un fallo
  Future<List<RecipeModel>> getRecipes();
  
  /// Llama al endpoint para obtener una receta por ID
  /// Lanza [ServerException] si hay un fallo
  Future<RecipeModel> getRecipeById(String id);

  /// Busca recetas por nombre
  /// Lanza [ServerException] si hay un fallo
  Future<List<RecipeModel>> searchRecipes(String query);

  /// Filtra recetas por categoría
  /// Lanza [ServerException] si hay un fallo
  Future<List<RecipeModel>> filterByCategory(String category);

  /// Obtiene la lista de categorías dinámicas
  /// Lanza [ServerException] si hay un fallo
  Future<List<String>> getCategories();
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  RecipeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RecipeModel>> getRecipes() async {
    try {
      // TheMealDB no tiene un endpoint para obtener todas las recetas
      // Usaremos la búsqueda con una string vacía para obtener algunas recetas populares
      final response = await client.get(
        Uri.parse('$baseUrl/search.php?s='),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['meals'] == null) {
          return [];
        }
        
        final List<dynamic> mealsJson = data['meals'];
        return mealsJson
            .map((json) => RecipeModel.fromJson(json))
            .toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<RecipeModel> getRecipeById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/lookup.php?i=$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['meals'] == null || data['meals'].isEmpty) {
          throw ServerException();
        }
        
        return RecipeModel.fromJson(data['meals'][0]);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/search.php?s=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['meals'] == null) {
          return [];
        }
        
        final List<dynamic> mealsJson = data['meals'];
        return mealsJson
            .map((json) => RecipeModel.fromJson(json))
            .toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<RecipeModel>> filterByCategory(String category) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/filter.php?c=$category'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['meals'] == null) {
          return [];
        }
        
        final List<dynamic> mealsJson = data['meals'];
        
        // El endpoint de filtrado solo proporciona datos básicos
        // Necesitamos hacer peticiones adicionales para obtener detalles completos
        List<RecipeModel> recipes = [];
        for (var meal in mealsJson) {
          // Obtenemos más detalles de cada receta
          try {
            final detailedRecipe = await getRecipeById(meal['idMeal']);
            recipes.add(detailedRecipe);
          } catch (_) {
            // Si falla la petición individual, continuamos con la siguiente
            continue;
          }
        }
        
        return recipes;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/list.php?c=list'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['meals'] == null) return [];
        final List<dynamic> categoriesJson = data['meals'];
        return categoriesJson
            .map<String>((json) => json['strCategory'] as String)
            .toList();
      } else {
        throw ServerException();
      }
    } catch (_) {
      throw ServerException();
    }
  }
}