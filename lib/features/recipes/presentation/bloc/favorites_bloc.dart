import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/usecases/get_favorite_recipes.dart';
import '../../domain/usecases/toggle_favorite_recipe.dart';
import '../../domain/usecases/check_favorite_status.dart';
import '../../../../core/usecases/usecase.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoriteRecipes getFavoriteRecipes;
  final ToggleFavoriteRecipe toggleFavoriteRecipe;
  final CheckFavoriteStatus checkFavoriteStatus;

  FavoritesBloc({
    required this.getFavoriteRecipes,
    required this.toggleFavoriteRecipe,
    required this.checkFavoriteStatus,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    on<CheckFavorite>(_onCheckFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    try {
      final favorites = await getFavoriteRecipes(NoParams());
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event,
      Emitter<FavoritesState> emit,
      ) async {
    try {
      // 1) Hacer el toggle
      final isNowFavorite = await toggleFavoriteRecipe(FavoriteParams(recipe: event.recipe));

      // 2) Obtener lista actualizada
      final favorites = await getFavoriteRecipes(NoParams());

      // 3) Actualizar el ícono (opcional, para detail page)
      emit(FavoriteStatusChecked(
        recipeId: event.recipe.id,
        isFavorite: isNowFavorite,
      ));

      // 4) ¡Emitir finalmente FavoritesLoaded!
      emit(FavoritesLoaded(favorites: favorites));

    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> _onCheckFavorite(
    CheckFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final isFavorite = await checkFavoriteStatus(RecipeIdParams(recipeId: event.recipeId));
      emit(FavoriteStatusChecked(recipeId: event.recipeId, isFavorite: isFavorite));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }
} 