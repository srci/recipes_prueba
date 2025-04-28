import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/categories_bloc.dart';

class CategoryFilterDialog extends StatefulWidget {
  final String? initialCategory;
  const CategoryFilterDialog({Key? key, this.initialCategory}) : super(key: key);

  @override
  State<CategoryFilterDialog> createState() => _CategoryFilterDialogState();
}

class _CategoryFilterDialogState extends State<CategoryFilterDialog> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCategory;
    context.read<CategoriesBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return SizedBox(
                  height: 50,
                  child: Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryColor),
                  ),
                );
              } else if (state is CategoriesLoaded) {
                final categories = state.categories;
                if (categories.isEmpty) {
                  return SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('No categories found', style: TextStyle(color: Colors.white)),
                    ),
                  );
                }
                return SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSel = _selected == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSel,
                          selectedColor: AppTheme.primaryColor,
                          backgroundColor: AppTheme.secondaryColor,
                          labelStyle: TextStyle(color: isSel ? Colors.white : Colors.white70),
                          onSelected: (sel) => setState(() => _selected = sel ? cat : null),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return SizedBox(
                  height: 50,
                  child: Center(
                    child: Text('Error al cargar', style: TextStyle(color: Colors.white)),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Clear', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                onPressed: () => Navigator.of(context).pop(_selected),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
