import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:r312/screens/widgets/box_button_widget.dart';

class BoxControlsWidget extends StatelessWidget {
  const BoxControlsWidget({
    required this.disconnectPressed,
    required this.leftPressed,
    required this.rightPressed,
    required this.deepLink,
    super.key,
  });

  final VoidCallback disconnectPressed;
  final VoidCallback leftPressed;
  final VoidCallback rightPressed;
  final String? deepLink;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoxButtonWidget(icon: Icons.chevron_left, onPressed: leftPressed),
              if (deepLink != null)
                BoxButtonWidget(
                  icon: Icons.qr_code,
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
                ),
              BoxButtonWidget(
                icon: Icons.link_off,
                onPressed: disconnectPressed,
              ),
              BoxButtonWidget(
                icon: Icons.chevron_right,
                onPressed: rightPressed,
              ),
            ],
          ),
          const SizedBox(height: 10), // Spacing between rows
          BorderedText(
            strokeColor: Colors.yellow,
            strokeWidth: 2,
            child: const Text(
              'r312',
              style: TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
