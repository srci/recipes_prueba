import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/recipe_repository.dart';

class RecipeIdParams extends Equatable {
  final String recipeId;

  const RecipeIdParams({required this.recipeId});

  @override
  List<Object> get props => [recipeId];
}

class CheckFavoriteStatus implements UseCase<bool, RecipeIdParams> {
  final RecipeRepository repository;

  CheckFavoriteStatus(this.repository);

  @override
  Future<bool> call(RecipeIdParams params) {
    return repository.isFavorite(params.recipeId);
  }
} 