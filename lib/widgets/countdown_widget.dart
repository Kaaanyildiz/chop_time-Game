import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  final VoidCallback onComplete;
  final int duration;

  const CountdownWidget({
    super.key,
    required this.onComplete,
    this.duration = 3,
  });

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  int _currentNumber = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0),
    ));

    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = widget.duration; i > 0; i--) {
      setState(() {
        _currentNumber = i;
      });
      
      _controller.reset();
      _controller.forward();
      
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    
    // "BAŞLA!" göster
    setState(() {
      _currentNumber = 0;
    });
    _controller.reset();
    _controller.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    widget.onComplete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    _currentNumber > 0 ? _currentNumber.toString() : 'BAŞLA!',
                    style: TextStyle(
                      fontSize: _currentNumber > 0 ? 48 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
