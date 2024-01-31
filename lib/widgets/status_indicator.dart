import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String status;

  const StatusIndicator({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case 'approved':
        color = Theme.of(context).colorScheme.primary;
        break;
      case 'pending':
        color = Theme.of(context).colorScheme.secondary;
        break;
      case 'rejected':
        color = Theme.of(context).colorScheme.tertiary;
        break;
      default:
        color = Theme.of(context).colorScheme.outline;
    }

    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          status.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
