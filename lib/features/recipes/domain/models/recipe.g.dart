// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      imageUrl: json['imageUrl'] as String,
      favoritedBy: (json['favoritedBy'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'imageUrl': instance.imageUrl,
      'favoritedBy': instance.favoritedBy,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'isFavorite': instance.isFavorite,
      'likesCount': instance.likesCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
