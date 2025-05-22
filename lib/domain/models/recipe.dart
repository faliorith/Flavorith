// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final String category;
  final String userId;
  final String authorName;
  final List<String> favoritedBy;
  final bool isFavorite;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int views;

  final String difficulty;

  var cookingTime;

  var instructions;

  final String authorId;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.category,
    required this.userId,
    required this.authorName,
    required this.difficulty,
    this.favoritedBy = const [],
    this.isFavorite = false,
    this.likesCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.views = 0,
    required this.authorId,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      category: data['category'] ?? '',
      userId: data['userId'] ?? '',
      authorName: data['authorName'] ?? '',
      favoritedBy: List<String>.from(data['favoritedBy'] ?? []),
      isFavorite: data['isFavorite'] ?? false,
      likesCount: data['likesCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      views: data['views'] ?? 0,
      difficulty: data['difficulty'] ?? '',
      authorId: data['authorId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'category': category,
      'userId': userId,
      'authorName': authorName,
      'favoritedBy': favoritedBy,
      'isFavorite': isFavorite,
      'likesCount': likesCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'views': views,
    };
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    List<String>? ingredients,
    List<String>? steps,
    String? category,
    String? userId,
    String? authorName,
    List<String>? favoritedBy,
    bool? isFavorite,
    int? likesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? views,
    String? difficulty,
    String? authorId,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      category: category ?? this.category,
      userId: userId ?? this.userId,
      authorName: authorName ?? this.authorName,
      favoritedBy: favoritedBy ?? this.favoritedBy,
      isFavorite: isFavorite ?? this.isFavorite,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      views: views ?? this.views,
      difficulty: difficulty ?? this.difficulty,
      authorId: authorId ?? this.authorId,
    );
  }
} 