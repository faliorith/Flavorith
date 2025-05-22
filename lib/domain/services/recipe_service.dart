// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flavorith/domain/models/recipe.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'recipes';

  // Получение всех рецептов
  Stream<List<Recipe>> getRecipes() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }

  // Получение рецептов пользователя
  Stream<List<Recipe>> getUserRecipes(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }

  // Получение одного рецепта по ID
  Future<Recipe?> getRecipe(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return Recipe.fromFirestore(doc);
    }
    return null;
  }

  // Создание нового рецепта
  Future<Recipe> createRecipe(Recipe recipe) async {
    final docRef = _firestore.collection(_collection).doc();
    final newRecipe = recipe.copyWith(
      id: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await docRef.set(newRecipe.toFirestore());
    return newRecipe;
  }

  // Обновление рецепта
  Future<void> updateRecipe(Recipe recipe) async {
    final updatedRecipe = recipe.copyWith(
      updatedAt: DateTime.now(),
    );
    
    await _firestore
        .collection(_collection)
        .doc(recipe.id)
        .update(updatedRecipe.toFirestore());
  }

  // Удаление рецепта
  Future<void> deleteRecipe(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Поиск рецептов по названию
  Stream<List<Recipe>> searchRecipes(String query) {
    return _firestore
        .collection(_collection)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }

  // Получение рецептов по сложности
  Stream<List<Recipe>> getRecipesByDifficulty(String difficulty) {
    return _firestore
        .collection(_collection)
        .where('difficulty', isEqualTo: difficulty)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }

  // Получение рецептов по времени приготовления
  Stream<List<Recipe>> getRecipesByCookingTime(int maxTime) {
    return _firestore
        .collection(_collection)
        .where('cookingTime', isLessThanOrEqualTo: maxTime)
        .orderBy('cookingTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }
} 