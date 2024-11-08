import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/constant/paths.dart';

class Loader extends StatefulWidget {
  const Loader(
      {super.key, this.backgroundDimPercentage = 0.0, this.width, this.height});

  final double backgroundDimPercentage;
  final double? width;
  final double? height;

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Loader fade-in animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Stack(
        children: [
          // Dimmed background
          Positioned.fill(
            child: ModalBarrier(
              color: Colors.black.withOpacity(widget.backgroundDimPercentage),
              dismissible: false,
            ),
          ),
          // Centered GIF Loader
          Center(
            child: Image.asset(
              height: widget.height,
              width: widget.width,
              Paths.loaderAnimation,
            ),
          ),
        ],
      ),
    );
  }
}
