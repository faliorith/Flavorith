// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flavorith/core/constants/app_constants.dart';
import 'package:flavorith/data/models/recipe.dart';

class RecipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'recipes';
  
  Future<List<Recipe>> getRecipes() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }
  
  Future<Recipe> getRecipe(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists) {
      throw Exception('Recipe not found');
    }
    return Recipe.fromJson({...doc.data()!, 'id': doc.id});
  }
  
  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _firestore.collection(_collection).add(recipe.toJson());
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }
  
  Future<void> updateRecipe(String id, Recipe recipe) async {
    try {
      await _firestore.collection(_collection).doc(id).update(recipe.toJson());
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }
  
  Future<void> deleteRecipe(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }
  
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'isFavorite': isFavorite,
      });
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }
} 