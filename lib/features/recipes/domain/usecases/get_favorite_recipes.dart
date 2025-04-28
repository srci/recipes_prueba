import '../../../../core/usecases/usecase.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetFavoriteRecipes implements UseCase<List<Recipe>, NoParams> {
  final RecipeRepository repository;

  GetFavoriteRecipes(this.repository);

  @override
  Future<List<Recipe>> call(NoParams params) {
    return repository.getFavoriteRecipes();
  }
} 