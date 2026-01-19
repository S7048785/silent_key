import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpringShakeAnimation extends StatefulWidget {
  final Widget child;
  final double amplitude; // 振幅
  final double frequency; // 频率
  final Duration duration;

  const SpringShakeAnimation({
    super.key,
    required this.child,
    this.amplitude = 10.0,
    this.frequency = 8.0,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  SpringShakeAnimationState createState() => SpringShakeAnimationState();

  static void shake(GlobalKey<SpringShakeAnimationState> key) {
    key.currentState?._triggerShake();
  }
}

class SpringShakeAnimationState extends State<SpringShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _springAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _springAnimation = Tween<double>(
      begin: 0,
      end: widget.amplitude,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut, // 弹簧效果
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _animationController.forward().whenComplete(() {
      _animationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _springAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _springAnimation.value *
                math.sin(_animationController.value * math.pi * widget.frequency),
            0,
          ),
          child: widget.child,
        );
      },
    );
  }
}