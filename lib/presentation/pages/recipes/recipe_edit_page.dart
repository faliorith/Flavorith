// ignore_for_file: deprecated_member_use, unused_import, unnecessary_null_comparison, unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:flavorith/domain/services/recipe_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:flavorith/features/recipes/data/repositories/recipe_repository.dart';

class RecipeEditPage extends StatefulWidget {
  final Recipe? recipe;

  const RecipeEditPage({super.key, required this.recipe});

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _recipeService = RecipeService();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;
  late TextEditingController _imageUrlController;
  late String _selectedCategory;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe!.title);
    _descriptionController = TextEditingController(text: widget.recipe!.description);
    _ingredientsController = TextEditingController(text: widget.recipe!.ingredients.join('\n'));
    _stepsController = TextEditingController(text: widget.recipe!.steps.join('\n'));
    _imageUrlController = TextEditingController(text: widget.recipe!.imageUrl);
    _selectedCategory = widget.recipe!.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final updatedRecipe = widget.recipe!.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        ingredients: _ingredientsController.text.split('\n'),
        steps: _stepsController.text.split('\n'),
        imageUrl: _imageUrlController.text,
        category: _selectedCategory,
        updatedAt: DateTime.now(),
      );

      try {
        await Provider.of<RecipeRepository>(context, listen: false).updateRecipe(updatedRecipe);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при обновлении рецепта: $e')),
          );
        }
      }
    }
  }

  void _deleteRecipe() async {
    try {
      await Provider.of<RecipeRepository>(context, listen: false).deleteRecipe(widget.recipe!.id);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении рецепта: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать рецепт'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteRecipe,
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Изображение
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : widget.recipe!.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.recipe!.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Icon(
                                Icons.add_photo_alternate,
                                size: 64,
                                color: theme.colorScheme.primary,
                              ),
                  ),
                ),
                const SizedBox(height: 16),
                // Название
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Название рецепта',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите название рецепта';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Описание
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите описание рецепта';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Ингредиенты
                Text(
                  'Ингредиенты',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(
                    labelText: 'Ингредиенты (каждый с новой строки)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 24),
                // Шаги приготовления
                Text(
                  'Шаги приготовления',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _stepsController,
                  decoration: const InputDecoration(
                    labelText: 'Шаги приготовления (каждый с новой строки)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                // Время приготовления и категория
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL изображения',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Категория',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Завтрак', child: Text('Завтрак')),
                          DropdownMenuItem(value: 'Обед', child: Text('Обед')),
                          DropdownMenuItem(value: 'Ужин', child: Text('Ужин')),
                          DropdownMenuItem(value: 'Десерт', child: Text('Десерт')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveRecipe,
                  child: const Text('Сохранить изменения'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
} 