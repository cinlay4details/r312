import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  const QrCodeWidget({required this.deepLink, super.key});

  final String? deepLink;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.qr_code),
      label: const Text('Copy Link'),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: deepLink!)).then(
          // ignore: use_build_context_synchronously it'll be fine
          (_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Link copied to clipboard'),
              duration: Duration(seconds: 2),
            ),
          ),
        );
        showDialog<void>(
          context: context,
          builder:
              (context) => Dialog(
                backgroundColor: Colors.white,
                // insetPadding: EdgeInsets.zero, // No extra padding
                child: QrImageView(data: deepLink!),
              ),
        );
      },
    );
  }
}
