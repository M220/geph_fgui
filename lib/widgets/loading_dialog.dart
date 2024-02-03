import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String title;

  const LoadingDialog({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(children: [
        const Center(child: CircularProgressIndicator()),
        const SizedBox(width: 16),
        Text(title),
      ]),
    );
  }
}
