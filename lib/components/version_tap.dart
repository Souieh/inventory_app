import 'package:flutter/material.dart';
import 'package:inventory_app/providers/dev_mode_provider.dart';
import 'package:provider/provider.dart';

class VersionTap extends StatefulWidget {
  const VersionTap({super.key});

  @override
  State<VersionTap> createState() => _VersionTapState();
}

class _VersionTapState extends State<VersionTap> {
  final List<DateTime> _tapTimes = [];

  void _handleTap() {
    final now = DateTime.now();
    _tapTimes.add(now);

    // إزالة الضغطات القديمة بعد 10 ثوانٍ
    _tapTimes.removeWhere((t) => now.difference(t).inSeconds > 10);

    if (_tapTimes.length >= 7) {
      _tapTimes.clear();
      _showPasskeyDialog();
    }
  }

  void _showPasskeyDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('أدخل رمز التفعيل'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'كلمة المرور'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DevModeProvider>().enable(controller.text);
              Navigator.pop(context);
            },
            child: const Text('تفعيل'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final version = 'v1.0.0';
    return GestureDetector(
      onTap: _handleTap,
      child: Text(version, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
