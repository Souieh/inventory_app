import 'package:flutter/material.dart';
import 'package:inventory_app/components/barcode_scanner.dart';
import 'package:inventory_app/models/article.dart';
import 'package:inventory_app/services/db_helper.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

import '../localization/S.dart';

class ArticleAddScreen extends StatefulWidget {
  const ArticleAddScreen({super.key});

  @override
  State<ArticleAddScreen> createState() => _ArticleAddScreenState();
}

class _ArticleAddScreenState extends State<ArticleAddScreen> {
  late final session = Provider.of<SessionManager>(context, listen: false);

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCondition;
  final List<String> _conditionOptions = [
    'New',
    'Good',
    'Working',
    'Needs Repair',
    'Broken',
  ];

  Future<void> _saveArticle() async {
    final t = S.of(context);
    if (!_formKey.currentState!.validate()) return;

    final article = Article(
      code: _codeController.text.trim(),
      name: _nameController.text.trim().isEmpty
          ? t.no_name
          : _nameController.text.trim(),
      quantity: int.tryParse(_quantityController.text) ?? 1,
      description: _descriptionController.text.trim().isEmpty
          ? t.no_description
          : _descriptionController.text.trim(),
      category: _categoryController.text.trim().isEmpty
          ? t.no_category
          : _categoryController.text.trim(),
      condition: _selectedCondition ?? t.no_condition,
      location: _locationController.text.trim().isEmpty
          ? t.no_location
          : _locationController.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      agentCode: session.user?.code ?? t.unknown_agent,
    );

    try {
      final alreadyExist = await DBHelper().getArticles(
        code: article.code,
        agentCode: session.user?.code,
      );
      if (alreadyExist.isNotEmpty) {
        if (context.mounted && mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.article_exists)));
        }
        return;
      }
      await DBHelper().insertArticle(article);

      if (context.mounted && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.article_saved_successfully)));
      }
      _codeController.clear();
      _nameController.clear();
      _categoryController.clear();
      _descriptionController.clear();
      _quantityController.text = '1';
      setState(() {
        _selectedCondition = null;
      });
    } catch (e) {
      if (context.mounted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.error_saving_article}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.addArticle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _codeController,
                              decoration: InputDecoration(
                                labelText: '${t.article_code} *',
                                border: const OutlineInputBorder(),
                                suffixIcon:
                                    (Theme.of(context).platform ==
                                                TargetPlatform.android ||
                                            Theme.of(context).platform ==
                                                TargetPlatform.iOS) &&
                                        !session.isAdmin
                                    ? null
                                    : IconButton(
                                        icon: const Icon(Icons.qr_code_scanner),
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BarcodeScannerScreen(
                                                    onScanned: (value) {
                                                      setState(() {
                                                        _codeController.text =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? t.code_required
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: '${t.name} (${t.optional})',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: '${t.location} *',
                          border: const OutlineInputBorder(),
                          suffixIcon:
                              (Theme.of(context).platform ==
                                          TargetPlatform.android ||
                                      Theme.of(context).platform ==
                                          TargetPlatform.iOS) &&
                                  !session.isAdmin
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.qr_code_scanner),
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BarcodeScannerScreen(
                                              onScanned: (value) {
                                                setState(() {
                                                  _locationController.text =
                                                      value;
                                                });
                                              },
                                            ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? t.location_required
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _quantityController,
                              decoration: InputDecoration(
                                labelText: '${t.quantity} *',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return t.quantity_required;
                                }
                                final quantity = int.tryParse(value);
                                if (quantity == null || quantity <= 0) {
                                  return t.invalid_quantity;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCondition,
                              decoration: InputDecoration(
                                labelText: '${t.condition} *',
                                border: const OutlineInputBorder(),
                              ),
                              items: _conditionOptions
                                  .map(
                                    (condition) => DropdownMenuItem<String>(
                                      value: condition,
                                      child: Text(condition),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(() {
                                _selectedCondition = value;
                              }),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? t.required
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: '${t.category} (${t.optional})',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: '${t.description} (${t.optional})',
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: _saveArticle,
                        icon: const Icon(Icons.save),
                        label: Text(t.save_article),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
