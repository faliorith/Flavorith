import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> ingredients;
  final List<String> steps;
  final String imageUrl;
  final List<String> favoritedBy;
  final String authorId;
  final String authorName;
  final bool isFavorite;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
    required this.favoritedBy,
    required this.authorId,
    required this.authorName,
    this.isFavorite = false,
    this.likesCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    List<String>? ingredients,
    List<String>? steps,
    String? imageUrl,
    List<String>? favoritedBy,
    String? authorId,
    String? authorName,
    bool? isFavorite,
    int? likesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      imageUrl: imageUrl ?? this.imageUrl,
      favoritedBy: favoritedBy ?? this.favoritedBy,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      isFavorite: isFavorite ?? this.isFavorite,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 