import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/usecases/get_recipes.dart';
import '../../domain/usecases/search_recipes.dart';
import '../../domain/usecases/filter_recipes_by_category.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final GetRecipes getRecipes;
  final SearchRecipes searchRecipes;
  final FilterRecipesByCategory filterRecipesByCategory;

  RecipesBloc({
    required this.getRecipes,
    required this.searchRecipes,
    required this.filterRecipesByCategory,
  }) : super(RecipesInitial()) {
    on<FetchRecipes>(_onFetchRecipes);
    on<SearchRecipesEvent>(_onSearchRecipes);
    on<FilterRecipesByCategoryEvent>(_onFilterRecipesByCategory);
  }

  Future<void> _onFetchRecipes(
    FetchRecipes event,
    Emitter<RecipesState> emit,
  ) async {
    emit(RecipesLoading());
    try {
      final recipes = await getRecipes(NoParams());
      emit(RecipesLoaded(recipes: recipes));
    } catch (e) {
      emit(RecipesError(message: e.toString()));
    }
  }

  Future<void> _onSearchRecipes(
    SearchRecipesEvent event,
    Emitter<RecipesState> emit,
  ) async {
    emit(RecipesLoading());
    try {
      final recipes = await searchRecipes(SearchParams(query: event.query));
      emit(RecipesLoaded(recipes: recipes));
    } catch (e) {
      emit(RecipesError(message: e.toString()));
    }
  }

  Future<void> _onFilterRecipesByCategory(
    FilterRecipesByCategoryEvent event,
    Emitter<RecipesState> emit,
  ) async {
    emit(RecipesLoading());
    try {
      final recipes = await filterRecipesByCategory(CategoryParams(category: event.category));
      emit(RecipesLoaded(recipes: recipes));
    } catch (e) {
      emit(RecipesError(message: e.toString()));
    }
  }
} 