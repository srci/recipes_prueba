part of 'recipes_bloc.dart';

abstract class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecipes extends RecipesEvent {}

class SearchRecipesEvent extends RecipesEvent {
  final String query;

  const SearchRecipesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class FilterRecipesByCategoryEvent extends RecipesEvent {
  final String category;

  const FilterRecipesByCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
} 