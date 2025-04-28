import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart';
import 'package:recipes_prueba/features/recipes/presentation/bloc/favorites_bloc.dart';
import '../../domain/entities/recipe.dart';
import '../bloc/recipes_bloc.dart';
import '../widgets/recipe_card.dart';
import '../../../../core/theme/app_theme.dart';
import 'recipe_detail_page.dart';
import '../widgets/category_filter_dialog.dart';
import '../widgets/recipes_list_view.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
      if (_tabController.index == 1) {
        context.read<FavoritesBloc>().add(LoadFavorites());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<RecipesBloc>().add(SearchRecipesEvent(query: query));
    }
  }

  Future<void> _showFilterDialog() async {
    final selected = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => CategoryFilterDialog(initialCategory: _selectedCategory),
    );
    if (selected == null) {
      setState(() => _selectedCategory = null);
      context.read<RecipesBloc>().add(FetchRecipes());
    } else {
      setState(() => _selectedCategory = selected);
      context.read<RecipesBloc>().add(FilterRecipesByCategoryEvent(category: selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'Recipes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                        context.read<RecipesBloc>().add(FetchRecipes());
                      },
                    ),
                    filled: true,
                    fillColor: AppTheme.secondaryColor.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (_) => _performSearch(),
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.primaryColor,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                tabs: const [
                  Tab(text: 'Last'),
                  Tab(text: 'Favorites'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<RecipesBloc, RecipesState>(
            builder: (context, state) {
              if (state is RecipesInitial) {
                context.read<RecipesBloc>().add(FetchRecipes());
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              } else if (state is RecipesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              } else if (state is RecipesLoaded) {
                return RecipesListView(
                  recipes: state.recipes,
                  fadeAnimation: _fadeAnimation,
                );
              } else if (state is RecipesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.primaryColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                        onPressed: () {
                          context.read<RecipesBloc>().add(FetchRecipes());
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text(
                  'No hay recetas disponibles',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesInitial) {
                context.read<FavoritesBloc>().add(LoadFavorites());
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              } else if (state is FavoritesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              } else if (state is FavoritesLoaded) {
                return RecipesListView(
                  recipes: state.favorites,
                  fadeAnimation: _fadeAnimation,
                );
              } else if (state is FavoritesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.primaryColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                        onPressed: () {
                          context.read<FavoritesBloc>().add(LoadFavorites());
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text(
                  'No hay favoritos guardados',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}