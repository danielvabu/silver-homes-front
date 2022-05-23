import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { opacity, translateY }

class ToastMessageAnimation extends StatelessWidget {
  const ToastMessageAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimelineTween<AniProps> tween = TimelineTween<AniProps>()
      ..addScene(
              begin: const Duration(milliseconds: 0),
              end: const Duration(milliseconds: 250))
          .animate(AniProps.translateY, tween: Tween(begin: 100.0, end: 0.0))
      ..addScene(
              begin: const Duration(milliseconds: 250),
              end: const Duration(seconds: 1))
          .animate(AniProps.translateY, tween: Tween(begin: 0.0, end: 0.0))
      ..addScene(
              begin: const Duration(milliseconds: 1250),
              end: const Duration(milliseconds: 250))
          .animate(AniProps.translateY, tween: Tween(begin: 0.0, end: 100.0))
      ..addScene(
              begin: const Duration(milliseconds: 0),
              end: const Duration(milliseconds: 500))
          .animate(AniProps.opacity, tween: Tween(begin: 0.0, end: 1.0))
      ..addScene(
              begin: const Duration(milliseconds: 500),
              end: const Duration(seconds: 1))
          .animate(AniProps.opacity, tween: Tween(begin: 1.0, end: 1.0))
      ..addScene(
              begin: const Duration(milliseconds: 1500),
              end: const Duration(milliseconds: 500))
          .animate(AniProps.opacity, tween: Tween(begin: 1.0, end: 0.0));

    return PlayAnimation<TimelineValue<AniProps>>(
      duration: tween.duration,
      tween: tween,
      builder: (context, child, value) => Opacity(
        opacity: 1.0,
        child: Transform.translate(offset: Offset(0, 1), child: child),
      ),
    );
  }
}
