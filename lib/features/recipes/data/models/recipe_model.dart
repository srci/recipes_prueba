import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required String id,
    required String name,
    required String tags,
    required String imageUrl,
    required String dietType,
    required String area,
    required List<String> ingredients,
    required List<String> steps,
  }) : super(
          id: id,
          name: name,
          tags: tags,
          imageUrl: imageUrl,
          dietType: dietType,
          area: area,
          ingredients: ingredients,
          steps: steps,
        );

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    // Extraer los ingredientes y medidas
    List<String> ingredients = [];
    List<String> steps = [];

    // TheMealDB proporciona ingredientes como idIngredient1, idIngredient2, etc.
    // y las medidas como strMeasure1, strMeasure2, etc.
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      
      if (ingredient != null && ingredient.toString().trim().isNotEmpty &&
          measure != null && measure.toString().trim().isNotEmpty) {
        ingredients.add('$measure $ingredient');
      }
    }

    // Las instrucciones vienen como un texto completo, las dividimos por puntos
    if (json['strInstructions'] != null) {
      final instructions = json['strInstructions'].toString();
      steps = instructions
          .split('.')
          .where((step) => step.trim().isNotEmpty)
          .map((step) => '${step.trim()}.')
          .toList();
    }

    // Asignamos valores predeterminados para algunos campos que TheMealDB no proporciona
    return RecipeModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      tags: json['strTags'] != null ? json['strTags'] : 'Sin etiquetas',
      imageUrl: json['strMealThumb'] ?? '',
      dietType: json['strCategory'] ?? 'Desconocido',
      area: json['strArea'] ?? 'Internacional',
      ingredients: ingredients,
      steps: steps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strTags': tags,
      'strMealThumb': imageUrl,
      'strCategory': dietType,
      'strArea': area,
      // Los demás campos no se pueden mapear directamente
    };
  }
} 