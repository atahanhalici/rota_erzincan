import 'package:flutter/material.dart';

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
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.circle, size: 10, color: Colors.white),
            SizedBox(width: 6),
            Text("CANLI", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
