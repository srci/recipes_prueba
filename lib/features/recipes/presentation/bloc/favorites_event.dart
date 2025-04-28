part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final Recipe recipe;

  const ToggleFavorite({required this.recipe});

  @override
  List<Object> get props => [recipe];
}

class CheckFavorite extends FavoritesEvent {
  final String recipeId;

  const CheckFavorite({required this.recipeId});

  @override
  List<Object> get props => [recipeId];
} 