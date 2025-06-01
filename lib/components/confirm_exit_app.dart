import 'package:flutter/material.dart';

class ConfirmExitApp extends StatefulWidget {
  const ConfirmExitApp({super.key});

  @override
  State<ConfirmExitApp> createState() => _ConfirmExitAppState();
}

class _ConfirmExitAppState extends State<ConfirmExitApp> {
  bool _canPopScreen = false; // Controls PopScope's canPop behavior

  @override
  Widget build(BuildContext context) {
    // This component is likely a regular screen pushed onto the navigator.
    // Popping it means going back to the previous screen.
    return PopScope(
      canPop: _canPopScreen,
      // ignore: deprecated_member_use
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          // If the pop succeeded (e.g., _canPopScreen was true), the screen is likely removed.
          // If it could somehow remain, resetting _canPopScreen might be considered,
          // but typically not needed as the state is disposed with the screen.
          return;
        }

        // didPop is false, so _canPopScreen (which was false) prevented the pop.
        // Now, show the confirmation dialog.
        final bool? shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            // The title/content might need to be more generic if this component
            // is reused for confirming navigation away from any screen,
            // not just "exiting the app".
            title: const Text('تأكيد الخروج'),
            content: const Text('هل تريد حقاً الخروج من التطبيق؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Don't pop
                child: const Text('لا'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Do pop
                child: const Text('نعم'),
              ),
            ],
          ),
        );

        if (shouldPop ?? false) {
          if (mounted) {
            // Allow the pop by setting _canPopScreen to true
            setState(() {
              _canPopScreen = true;
            });
            // Then trigger the pop action.
            if (context.mounted) {
              // Use Navigator.of(context).maybePop() to avoid errors if the screen is already popped.
              Navigator.of(context).maybePop();
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('مثال تأكيد خروج')),
        body: const Center(child: Text('اضغط زر الرجوع للخروج')),
      ),
    );
  }
}
