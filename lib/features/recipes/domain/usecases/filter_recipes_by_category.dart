import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class CategoryParams extends Equatable {
  final String category;

  const CategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}

class FilterRecipesByCategory implements UseCase<List<Recipe>, CategoryParams> {
  final RecipeRepository repository;

  FilterRecipesByCategory(this.repository);

  @override
  Future<List<Recipe>> call(CategoryParams params) {
    return repository.filterByCategory(params.category);
  }
} 