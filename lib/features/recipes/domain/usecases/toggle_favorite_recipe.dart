import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class FavoriteParams extends Equatable {
  final Recipe recipe;

  const FavoriteParams({required this.recipe});

  @override
  List<Object> get props => [recipe];
}

class ToggleFavoriteRecipe implements UseCase<bool, FavoriteParams> {
  final RecipeRepository repository;

  ToggleFavoriteRecipe(this.repository);

  @override
  Future<bool> call(FavoriteParams params) async {
    final Recipe recipe = params.recipe;
    final bool isFavorite = await repository.isFavorite(recipe.id);
    
    if (isFavorite) {
      await repository.removeFromFavorites(recipe.id);
      return false;
    } else {
      await repository.addToFavorites(recipe);
      return true;
    }
  }
} 