import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart';
import 'package:recipes_prueba/features/recipes/presentation/bloc/favorites_bloc.dart';
import '../../domain/entities/recipe.dart';
import '../bloc/recipes_bloc.dart';
import '../widgets/recipe_card.dart';
import '../../../../core/theme/app_theme.dart';
import 'recipe_detail_page.dart';
import 'package:lottie/lottie.dart';
import 'package:recipes_prueba/injection_container.dart' as di;
import 'package:recipes_prueba/features/recipes/data/datasources/recipe_remote_data_source.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<String> _categories = [];
  bool _isLoadingCategories = true;
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
    _fetchCategories();
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filtrar por categoría',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoadingCategories)
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(color: AppTheme.primaryColor),
                      ),
                    )
                  else if (_categories.isEmpty)
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text('Sin categorías', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  else
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              selectedColor: AppTheme.primaryColor,
                              backgroundColor: AppTheme.secondaryColor,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = selected ? category : null;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedCategory = null;
                          });
                          context.read<RecipesBloc>().add(FetchRecipes());
                        },
                        child: const Text(
                          'Limpiar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          if (_selectedCategory != null) {
                            context.read<RecipesBloc>().add(
                              FilterRecipesByCategoryEvent(
                                category: _selectedCategory!
                              ),
                            );
                          }
                        },
                        child: const Text('Aplicar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await di.sl<RecipeRemoteDataSource>().getCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (_) {
      setState(() {
        _categories = [];
        _isLoadingCategories = false;
      });
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
          'Recetas',
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
                    hintText: 'Buscar recetas...',
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
                  Tab(text: 'Todos'),
                  Tab(text: 'Favoritos'),
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
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildRecipesList(state.recipes),
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
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildRecipesList(state.favorites),
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

  Widget _buildRecipesList(List<Recipe> recipes) {
    if (recipes.isEmpty) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/phantomLottie.json',
                width: 280,
                height: 280,
                fit: BoxFit.contain,
                repeat: true,
              ),
              const SizedBox(height: 10),
              const Text(
                'No se encontraron recetas\n:(',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: const Duration(milliseconds: 500),
            openBuilder: (context, _) => RecipeDetailPage(recipe: recipe),
            closedElevation: 0,
            closedColor: Colors.transparent,
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            closedBuilder: (context, openContainer) => Material(
              color: Colors.transparent,
              child: RecipeCard(
                imageUrl: recipe.imageUrl,
                dietType: recipe.dietType,
                title: recipe.name,
                area: recipe.area,
                tags: recipe.tags,
                onTap: openContainer,
              ),
            ),
          ),
        );
      },
    );
  }
}