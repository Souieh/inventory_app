import 'package:flutter/material.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/models/user.dart';
import 'package:inventory_app/services/db_helper.dart';

class AgentAddScreen extends StatefulWidget {
  const AgentAddScreen({super.key});

  @override
  State<AgentAddScreen> createState() => _AgentAddScreenState();
}

class _AgentAddScreenState extends State<AgentAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveAgent() async {
    if (!_formKey.currentState!.validate()) return;

    final t = S.of(context);
    setState(() {
      _isSaving = true;
    });

    final user = User(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      password: _passwordController.text.trim().isEmpty
          ? null
          : _passwordController.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
      role: 'agent',
    );

    try {
      await DBHelper().insertUser(user);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.agent_added_successfully)));

      _formKey.currentState!.reset();
      _codeController.clear();
      _nameController.clear();
      _descriptionController.clear();
      _passwordController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${t.failed_to_add_agent}: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.addAgent)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: t.agent_code_required,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? t.code_required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: t.name,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: t.description_optional,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: t.password_required,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? t.password_required
                      : null,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                _isSaving
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _saveAgent,
                        icon: const Icon(Icons.save),
                        label: Text(t.save_agent),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
