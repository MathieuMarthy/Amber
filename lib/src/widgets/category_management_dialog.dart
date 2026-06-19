import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/repositories/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryManagementDialog extends StatefulWidget {
  final VoidCallback onChanged;

  const CategoryManagementDialog({super.key, required this.onChanged});

  @override
  State<CategoryManagementDialog> createState() =>
      _CategoryManagementDialogState();
}

class _CategoryManagementDialogState extends State<CategoryManagementDialog> {
  final _addController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = context.read<CategoryRepository>();
      final cats = await repo.getAll();
      if (mounted) {
        setState(() {
          _categories = cats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  Future<void> _addCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _addController.text.trim();
      final repo = context.read<CategoryRepository>();

      try {
        await repo.create(name);
        _addController.clear();
        await _load();
        widget.onChanged();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur : $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la catégorie ?'),
        content: Text(
          'Voulez-vous vraiment supprimer "${category.name}" ?\nLes abonnements liés n\'auront plus de catégorie.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final repo = context.read<CategoryRepository>();
      try {
        await repo.delete(category.id);
        await _load();
        widget.onChanged();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur : $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AlertDialog(
      title: const Text('Gérer les catégories'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _addController,
                      decoration: const InputDecoration(
                        labelText: 'Nouvelle catégorie',
                        hintText: 'Nom de la catégorie',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Requis';
                        }
                        if (_categories.any(
                          (c) =>
                              c.name.toLowerCase() ==
                              value.trim().toLowerCase(),
                        )) {
                          return 'Existe déjà';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _addCategory,
                    icon: const Icon(Icons.add),
                    tooltip: 'Ajouter',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _categories.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text('Aucune catégorie pour le moment.'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            return ListTile(
                              title: Text(cat.name),
                              contentPadding: EdgeInsets.zero,
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: colors.error,
                                tooltip: 'Supprimer',
                                onPressed: () => _deleteCategory(cat),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}
