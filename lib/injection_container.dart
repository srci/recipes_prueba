import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/recipes/data/datasources/recipe_remote_data_source.dart';
import 'features/recipes/data/datasources/recipe_local_data_source.dart';
import 'features/recipes/data/repositories/recipe_repository_impl.dart';
import 'features/recipes/domain/repositories/recipe_repository.dart';
import 'features/recipes/domain/usecases/get_recipes.dart';
import 'features/recipes/domain/usecases/search_recipes.dart';
import 'features/recipes/domain/usecases/filter_recipes_by_category.dart';
import 'features/recipes/domain/usecases/get_favorite_recipes.dart';
import 'features/recipes/domain/usecases/toggle_favorite_recipe.dart';
import 'features/recipes/domain/usecases/check_favorite_status.dart';
import 'features/recipes/presentation/bloc/recipes_bloc.dart';
import 'features/recipes/presentation/bloc/favorites_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Recipes
  // BLoC
  sl.registerFactory(
    () => RecipesBloc(
      getRecipes: sl(),
      searchRecipes: sl(),
      filterRecipesByCategory: sl(),
    ),
  );
  
  sl.registerFactory(
    () => FavoritesBloc(
      getFavoriteRecipes: sl(),
      toggleFavoriteRecipe: sl(),
      checkFavoriteStatus: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRecipes(sl()));
  sl.registerLazySingleton(() => SearchRecipes(sl()));
  sl.registerLazySingleton(() => FilterRecipesByCategory(sl()));
  sl.registerLazySingleton(() => GetFavoriteRecipes(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteRecipe(sl()));
  sl.registerLazySingleton(() => CheckFavoriteStatus(sl()));

  // Repository
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(client: sl()),
  );
  
  sl.registerLazySingleton<RecipeLocalDataSource>(
    () => RecipeLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
} 