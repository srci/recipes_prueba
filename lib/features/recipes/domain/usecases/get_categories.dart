import '../../../../core/usecases/usecase.dart';
import '../repositories/recipe_repository.dart';

class GetCategories implements UseCase<List<String>, NoParams> {
  final RecipeRepository repository;

  GetCategories(this.repository);

  @override
  Future<List<String>> call(NoParams params) {
    return repository.getCategories();
  }
}
