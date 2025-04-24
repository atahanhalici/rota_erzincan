import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SwipeUpHint extends StatefulWidget {
  const SwipeUpHint({super.key});

  @override
  State<SwipeUpHint> createState() => SwipeUpHintState();
}

class SwipeUpHintState extends State<SwipeUpHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        const  Icon(
            Icons.keyboard_arrow_up,
            color: Colors.white,
            size: 32,
          ),
        const  SizedBox(height: 4),
          Text(
            'scrollUpForMore'.tr(),
            style:const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
