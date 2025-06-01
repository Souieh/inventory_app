import 'package:flutter/material.dart';
import 'package:inventory_app/components/barcode_scanner.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/models/location.dart';
import 'package:inventory_app/services/db_helper.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

class LocationAddScreen extends StatefulWidget {
  const LocationAddScreen({super.key});

  @override
  State<LocationAddScreen> createState() => _LocationAddScreenState();
}

class _LocationAddScreenState extends State<LocationAddScreen> {
  final _formKey = GlobalKey<FormState>();

  late final session = Provider.of<SessionManager>(context, listen: false);
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _occupationController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _saveLocation() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final location = Location(
      code: _codeController.text.trim(),
      name: _nameController.text.trim().isEmpty
          ? S.of(context).no_name
          : _nameController.text.trim(),
      occupation: _occupationController.text.trim().isEmpty
          ? null
          : _occupationController.text.trim(),
      type: _typeController.text.trim().isEmpty
          ? null
          : _typeController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      agentCode: session.user?.code ?? S.of(context).unknown_agent,
    );

    try {
      final alreadyExist = await DBHelper().getLocations(
        code: location.code,
        agentCode: session.user?.code,
      );
      if (alreadyExist.isNotEmpty) {
        if (!mounted) return;
        Navigator.of(context).pop(); // close loading dialog

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(S.of(context).location_exists)));
        return;
      }
      await DBHelper().insertLocation(location);

      if (!mounted) return;
      Navigator.of(context).pop(); // close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).location_saved_successfully)),
      );

      _codeController.clear();
      _nameController.clear();
      _occupationController.clear();
      _typeController.clear();
      _descriptionController.clear();
      setState(() {});
    } catch (e) {
      if (mounted) Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.of(context).error_saving_location}: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context); // اختصار لتسهيل الوصول للترجمة

    return Scaffold(
      appBar: AppBar(title: Text(s.add_location)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: "${s.location_code} *",
                    border: const OutlineInputBorder(),
                    suffixIcon:
                        (Theme.of(context).platform == TargetPlatform.android ||
                                Theme.of(context).platform ==
                                    TargetPlatform.iOS) &&
                            !session.isAdmin
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BarcodeScannerScreen(
                                    onScanned: (value) {
                                      setState(() {
                                        _codeController.text = value;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? s.code_required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "${s.name} (${s.optional})",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _occupationController,
                  decoration: InputDecoration(
                    labelText: "${s.occupation} (${s.optional})",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _typeController,
                  decoration: InputDecoration(
                    labelText: "${s.type} (${s.optional})",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "${s.description} (${s.optional})",
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _saveLocation,
                  icon: const Icon(Icons.save),
                  label: Text(s.save_location),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
