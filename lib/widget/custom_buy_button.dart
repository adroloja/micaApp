import 'package:flutter/material.dart';

class CustomBuyButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  CustomBuyButton({required this.onPressed, this.isEnabled = true, Key? key})
      : super(key: key);

  @override
  _CustomBuyButtonState createState() => _CustomBuyButtonState();
}

class _CustomBuyButtonState extends State<CustomBuyButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _borderColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.white,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.isEnabled) {
      _controller.forward();
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          width: screenWidth * 0.71,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: widget.isEnabled ? Colors.red[800] : Colors.grey,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: _borderColorAnimation.value ?? Colors.transparent,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(4, 4),
                blurRadius: 8.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: child,
        ),
        child: const Center(
          child: const Text(
            "COMPRAR",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
