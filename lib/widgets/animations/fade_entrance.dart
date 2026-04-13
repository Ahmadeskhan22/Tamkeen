import 'package:flutter/material.dart';

class FadeEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeEntrance(
      {super.key,
      required this.child,
      this.delay = const Duration(milliseconds: 0)});

  @override
  State<FadeEntrance> createState() => _FadeEntranceState();
}

class _FadeEntranceState extends State<FadeEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(widget.delay, () => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}
