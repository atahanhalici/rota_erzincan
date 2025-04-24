import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LiveBadge extends StatelessWidget {
  const LiveBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Positioned(
      bottom: orientation == Orientation.portrait ? 50 : 20,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.circle, size: 10, color: Colors.white),
            const SizedBox(width: 6),
            Text('liveBadge'.tr(), style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
