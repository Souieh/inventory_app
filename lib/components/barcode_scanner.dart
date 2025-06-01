import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatelessWidget {
  final Function(String) onScanned;

  const BarcodeScannerScreen({super.key, required this.onScanned});

  @override
  Widget build(BuildContext context) {
    // ✅ safer check in release & all platforms
    if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              const Text(
                'Barcode scanning is not supported on this platform.',
                textAlign: TextAlign.center,
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: SizedBox.expand(
        child: MobileScanner(
          onDetect: (barcode) {
            final String code = barcode.barcodes.firstOrNull?.rawValue ?? '';
            onScanned(code);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
