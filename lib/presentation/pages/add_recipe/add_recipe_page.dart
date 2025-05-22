import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flavorith/features/recipes/data/repositories/recipe_repository.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? _selectedCategory;
  final List<String> _ingredients = [];
  final List<String> _steps = [];
  String? _imageUrl;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final recipe = Recipe(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrl ?? '',
        ingredients: _ingredients,
        steps: _steps,
        category: _selectedCategory ?? '',
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        authorName: FirebaseAuth.instance.currentUser?.displayName ?? 'Аноним',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(), authorId: '', difficulty: '',
      );

      try {
        await Provider.of<RecipeRepository>(context, listen: false).addRecipe(recipe);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при сохранении рецепта: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить рецепт'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Название',
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                  ),
                ),
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание',
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                  ),
                ),
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: 'Ингредиенты (каждый с новой строки)'),
                maxLines: null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(labelText: 'Шаги приготовления (каждый с новой строки)'),
                maxLines: null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL изображения'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'Завтрак', child: Text('Завтрак')),
                  DropdownMenuItem(value: 'Обед', child: Text('Обед')),
                  DropdownMenuItem(value: 'Ужин', child: Text('Ужин')),
                  DropdownMenuItem(value: 'Десерт', child: Text('Десерт')),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: const Text('Сохранить рецепт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 