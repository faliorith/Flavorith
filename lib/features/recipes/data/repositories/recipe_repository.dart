import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flavorith/core/services/firebase_service.dart';
import 'package:flavorith/features/recipes/domain/models/recipe.dart';
import 'dart:typed_data';

class RecipeRepository {
  final FirebaseService _firebaseService = FirebaseService();
  final CollectionReference _recipesCollection = FirebaseFirestore.instance.collection('recipes');
  final Reference _storageRef = FirebaseStorage.instance.ref();

  // Получение всех рецептов
  Stream<List<Recipe>> getRecipes() {
    return _recipesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Recipe.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }

  // Получение рецепта по ID
  Future<Recipe?> getRecipeById(String id) async {
    final doc = await _recipesCollection.doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return Recipe.fromJson({
        'id': doc.id,
        ...data,
      });
    }
    return null;
  }

  // Добавление нового рецепта
  Future<String> addRecipe(Recipe recipe) async {
    final docRef = await _recipesCollection.add(recipe.toJson());
    return docRef.id;
  }

  // Обновление рецепта
  Future<void> updateRecipe(String id, Recipe recipe) async {
    await _recipesCollection.doc(id).update(recipe.toJson());
  }

  // Удаление рецепта
  Future<void> deleteRecipe(String id) async {
    await _recipesCollection.doc(id).delete();
  }

  // Загрузка изображения
  Future<String> uploadImage(String path, Uint8List imageBytes) async {
    final ref = _storageRef.child('recipe_images/$path');
    await ref.putData(imageBytes);
    return await ref.getDownloadURL();
  }

  // Поиск рецептов
  Stream<List<Recipe>> searchRecipes(String query) {
    return _recipesCollection
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Recipe.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }

  // Получение рецептов по категории
  Stream<List<Recipe>> getRecipesByCategory(String category) {
    return _recipesCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Recipe.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }

  // Получение избранных рецептов
  Stream<List<Recipe>> getFavoriteRecipes(String userId) {
    return _recipesCollection
        .where('favoritedBy', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Recipe.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }

  // Добавление/удаление из избранного
  Future<void> toggleFavorite(String recipeId, String userId) async {
    final doc = await _recipesCollection.doc(recipeId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final favoritedBy = List<String>.from(data['favoritedBy'] ?? []);
      
      if (favoritedBy.contains(userId)) {
        favoritedBy.remove(userId);
      } else {
        favoritedBy.add(userId);
      }
      
      await _recipesCollection.doc(recipeId).update({
        'favoritedBy': favoritedBy,
      });
    }
  }
} 