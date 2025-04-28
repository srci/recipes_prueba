import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class SearchParams extends Equatable {
  final String query;

  const SearchParams({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchRecipes implements UseCase<List<Recipe>, SearchParams> {
  final RecipeRepository repository;

  SearchRecipes(this.repository);

  @override
  Future<List<Recipe>> call(SearchParams params) {
    return repository.searchRecipes(params.query);
  }
} 