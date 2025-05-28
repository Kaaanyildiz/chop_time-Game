import 'package:flutter/material.dart';

class ScoreDisplay extends StatefulWidget {
  final int score;
  final bool isAnimated;

  const ScoreDisplay({
    super.key,
    required this.score,
    this.isAnimated = true,
  });

  @override
  State<ScoreDisplay> createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticOut,
    ));

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _glowController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ScoreDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.score != oldWidget.score && widget.isAnimated) {
      _pulseController.forward().then((_) => _pulseController.reverse());
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,                colors: [
                  const Color(0xFFFFD700).withValues(alpha: _glowAnimation.value),
                  const Color(0xFFFFA500).withValues(alpha: _glowAnimation.value),
                  const Color(0xFFFF8C00).withValues(alpha: _glowAnimation.value),
                ],
              ),
              borderRadius: BorderRadius.circular(30),              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.4 * _glowAnimation.value),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.yellow.withValues(alpha: 0.2 * _glowAnimation.value),
                  blurRadius: 25,
                  spreadRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: ShaderMask(
                    key: ValueKey(widget.score),
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFFFF8DC)],
                    ).createShader(bounds),
                    child: Text(
                      widget.score.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
