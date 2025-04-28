import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String name;
  final String tags;
  final String imageUrl;
  final String dietType;
  final String area;
  final List<String> ingredients;
  final List<String> steps;

  const Recipe({
    required this.id,
    required this.name,
    required this.tags,
    required this.imageUrl,
    required this.dietType,
    required this.area,
    required this.ingredients,
    required this.steps,
  });

  @override
  List<Object> get props => [
        id,
        name,
        tags,
        imageUrl,
        dietType,
        area,
        ingredients,
        steps,
      ];
} 