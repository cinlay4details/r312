import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r312/api/connection_info.dart';

class ConnectionInfoWidget extends StatelessWidget {
  const ConnectionInfoWidget({
    required this.label,
    required this.connectionInfo,
    super.key,
  });
  final String label;
  final ConnectionInfo connectionInfo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConnectionInfo>.value(
      value: connectionInfo,
      child: Consumer<ConnectionInfo>(
        builder: (context, info, _) {
          var statusText = info.status.toString().split('.').last;
          if (statusText.isNotEmpty) {
            statusText = statusText[0].toUpperCase() + statusText.substring(1);
          }
          final showLabel = label.isNotEmpty;
          final isConnected = info.status == ConnectionStatus.connected;
          final textColor = isConnected ? null : Colors.yellow;
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: SizedBox(
                height: 32, // fixed height for the widget
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showLabel)
                      Text(
                        '$label: ',
                        style: const TextStyle(color: Colors.white),
                      ),
                    Text(
                      statusText,
                      style:
                          textColor != null
                              ? TextStyle(color: textColor)
                              : null,
                    ),
                    if (info.errorMessage != null)
                      Tooltip(
                        message: info.errorMessage,
                        child: IconButton(
                          icon: const Icon(Icons.info, color: Colors.yellow),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Disconnected'),
                                    content: Text(info.errorMessage!),
                                    actions: [
                                      TextButton(
                                        child: const Text('Close'),
                                        onPressed:
                                            () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          padding: EdgeInsets.zero, // reduce extra padding
                          constraints: const BoxConstraints(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
