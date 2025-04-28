import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recipe.dart';
import '../pages/recipe_detail_page.dart';
import 'recipe_card.dart';

class RecipesListView extends StatelessWidget {
  final List<Recipe> recipes;
  final Animation<double> fadeAnimation;

  const RecipesListView({
    Key? key,
    required this.recipes,
    required this.fadeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: recipes.isEmpty ? _buildEmptyState() : _buildList(context),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/emptyStates.json',
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
    );
  }

  Widget _buildList(BuildContext context) {
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
