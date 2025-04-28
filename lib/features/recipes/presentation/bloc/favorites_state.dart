part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Recipe> favorites;

  const FavoritesLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

class FavoriteToggled extends FavoritesState {
  final Recipe recipe;
  final bool isFavorite;
  final List<Recipe> favorites;

  const FavoriteToggled({
    required this.recipe,
    required this.isFavorite,
    required this.favorites,
  });

  @override
  List<Object> get props => [recipe, isFavorite, favorites];
}

class FavoriteStatusChecked extends FavoritesState {
  final String recipeId;
  final bool isFavorite;

  const FavoriteStatusChecked({
    required this.recipeId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [recipeId, isFavorite];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError({required this.message});

  @override
  List<Object> get props => [message];
} 