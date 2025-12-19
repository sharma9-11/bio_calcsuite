import 'package:flutter/material.dart';
class ResultCard extends StatelessWidget {
  final String result;

  const ResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final bool isError =
    result.toLowerCase().contains('error');

    return Card(
      elevation: 0,
      color: isError
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          result,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isError
                ? Theme.of(context).colorScheme.onErrorContainer
                : Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}