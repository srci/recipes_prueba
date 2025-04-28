import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes_prueba/features/recipes/presentation/bloc/favorites_bloc.dart';
import 'injection_container.dart' as di;
import 'features/recipes/presentation/bloc/recipes_bloc.dart';
import 'features/recipes/presentation/bloc/categories_bloc.dart';
import 'features/recipes/presentation/pages/recipes_page.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecipesBloc>(
          create: (_) => di.sl<RecipesBloc>()..add(FetchRecipes()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (_) => di.sl<FavoritesBloc>(), // sin llamar eventos aquí todavía
        ),
        // Categories BLoC provider
        BlocProvider<CategoriesBloc>(
          create: (_) => di.sl<CategoriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Recipes App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme(),
        home: const RecipesPage(),
      ),
    );
  }
}
