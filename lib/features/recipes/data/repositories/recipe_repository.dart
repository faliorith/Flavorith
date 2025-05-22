// ignore_for_file: unused_field, prefer_interpolation_to_compose_strings, avoid_print, unused_import

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flavorith/core/services/firebase_service.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'recipes';

  RecipeRepository(this._firestore);

  Future<List<Recipe>> getRecipes() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Ошибка при получении рецептов: $e');
    }
  }

  Stream<List<Recipe>> searchRecipes(String query) {
    return _firestore
        .collection(_collection)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList());
  }

  Stream<List<Recipe>> getRecipesByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList());
  }

  Stream<List<Recipe>> getFavoriteRecipes(String userId) {
    return _firestore
        .collection(_collection)
        .where('favoritedBy', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList());
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _firestore.collection(_collection).doc(recipe.id).set(recipe.toFirestore());
    } catch (e) {
      throw Exception('Ошибка при добавлении рецепта: $e');
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _firestore.collection(_collection).doc(recipe.id).update(recipe.toFirestore());
    } catch (e) {
      throw Exception('Ошибка при обновлении рецепта: $e');
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection(_collection).doc(recipeId).delete();
    } catch (e) {
      throw Exception('Ошибка при удалении рецепта: $e');
    }
  }

  Future<void> toggleFavorite(String recipeId, String userId, bool isFavorite) async {
    try {
      final docRef = _firestore.collection(_collection).doc(recipeId);
      if (isFavorite) {
        await docRef.update({
          'favoritedBy': FieldValue.arrayUnion([userId]),
          'likesCount': FieldValue.increment(1),
        });
      } else {
        await docRef.update({
          'favoritedBy': FieldValue.arrayRemove([userId]),
          'likesCount': FieldValue.increment(-1),
        });
      }
    } catch (e) {
      throw Exception('Ошибка при изменении избранного: $e');
    }
  }

  // Загрузка изображения
  Future<String> uploadImage(String path, Uint8List imageBytes) async {
    final ref = FirebaseStorage.instance.ref().child('recipe_images/$path');
    await ref.putData(imageBytes);
    return await ref.getDownloadURL();
  }
} 