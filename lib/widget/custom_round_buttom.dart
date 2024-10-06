import 'package:flutter/material.dart';

class CustomRoundButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;

  CustomRoundButton({
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  _CustomRoundButtonState createState() => _CustomRoundButtonState();
}

class _CustomRoundButtonState extends State<CustomRoundButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;

  late AnimationController _controller;
  late Animation<Color?> _borderAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _borderAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.white,
    ).animate(_controller);

    _shadowAnimation = Tween<double>(
      begin: 10.0,
      end: 30.0,
    ).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });

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

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.isEnabled) {
          setState(() {
            _isPressed = true;
          });
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (widget.isEnabled) {
          widget.onPressed();
        }
      },
      onTapCancel: () {
        if (widget.isEnabled) {
          setState(() {
            _isPressed = false;
          });
          // Do not reverse the animation immediately on tap cancel
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isEnabled
                ? _borderAnimation.value ?? Colors.blue
                : Colors.grey,
            width: 15.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _borderAnimation.value?.withOpacity(0.5) ??
                  Colors.blue.withOpacity(0.5),
              blurRadius: _shadowAnimation.value,
              spreadRadius: _shadowAnimation.value,
            ),
          ],
          color: Colors.white, // Ensure the background is always white
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text.substring(0, 5),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isEnabled ? Colors.black : Colors.grey,
                    fontSize: 35.0,
                  ),
                ),
                Text(
                  widget.text.substring(5),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isEnabled ? Colors.black : Colors.grey,
                    fontSize: 35.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
