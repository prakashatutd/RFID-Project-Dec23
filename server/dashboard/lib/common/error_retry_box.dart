import 'package:flutter/material.dart';

// Simple error box with a retry button that is displayed when a data table fails to load
class ErrorAndRetryBox extends StatelessWidget {
  const ErrorAndRetryBox(this.errorMessage, this.retry);

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 120,
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Oops! $errorMessage', style: const TextStyle(color: Colors.white)),
            TextButton(
              onPressed: retry,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  Text('Retry', style: TextStyle(color: Colors.white))
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}