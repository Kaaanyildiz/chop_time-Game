import 'package:flutter/material.dart';

class ComboDisplay extends StatefulWidget {
  final int combo;
  final double maxCombo;

  const ComboDisplay({
    super.key,
    required this.combo,
    this.maxCombo = 100.0,
  });

  @override
  State<ComboDisplay> createState() => _ComboDisplayState();
}

class _ComboDisplayState extends State<ComboDisplay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _fireController;
  late AnimationController _scaleController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fireAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fireController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _fireAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fireController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    if (widget.combo > 0) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    
    if (widget.combo >= 5) {
      _rotationController.repeat();
    }
    
    if (widget.combo >= 10) {
      _fireController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ComboDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.combo > oldWidget.combo && widget.combo > 0) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
    }
    
    if (widget.combo > 0 && oldWidget.combo == 0) {
      _startAnimations();
    } else if (widget.combo == 0 && oldWidget.combo > 0) {
      _stopAnimations();
    }
  }

  void _stopAnimations() {
    _pulseController.stop();
    _rotationController.stop();
    _fireController.stop();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _fireController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Color _getComboColor() {
    if (widget.combo == 0) return Colors.grey;
    if (widget.combo < 3) return Colors.green;
    if (widget.combo < 6) return Colors.orange;
    if (widget.combo < 10) return Colors.red;
    return Colors.purple;
  }

  List<Color> _getGradientColors() {
    if (widget.combo == 0) {
      return [
        Colors.grey.withValues(alpha: 0.3),
        Colors.grey.withValues(alpha: 0.1),
      ];
    }
    if (widget.combo < 3) {
      return [
        const Color(0xFF4CAF50),
        const Color(0xFF8BC34A),
      ];
    }
    if (widget.combo < 6) {
      return [
        const Color(0xFFFF9800),
        const Color(0xFFFFC107),
      ];
    }
    if (widget.combo < 10) {
      return [
        const Color(0xFFF44336),
        const Color(0xFFE91E63),
      ];
    }
    return [
      const Color(0xFF9C27B0),
      const Color(0xFF673AB7),
      const Color(0xFF3F51B5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseAnimation,
        _rotationAnimation,
        _fireAnimation,
        _scaleAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: widget.combo >= 5 ? _rotationAnimation.value * 2 * 3.14159 : 0,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: _getGradientColors(),
                ),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: _getComboColor(),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getComboColor().withValues(alpha: 0.5),
                    blurRadius: 20 * _pulseAnimation.value,
                    spreadRadius: 5 * _pulseAnimation.value,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Fire effect for high combos
                  if (widget.combo >= 10)
                    Positioned.fill(
                      child: Transform.scale(
                        scale: 1.2 + (_fireAnimation.value * 0.3),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.orange.withValues(alpha: 0.8 * _fireAnimation.value),
                                Colors.red.withValues(alpha: 0.6 * _fireAnimation.value),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                      ),
                    ),
                  
                  // Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'COMBO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.8),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white,
                            _getComboColor(),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          '${widget.combo}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (widget.combo >= 5)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.combo >= 15 ? '🔥' : 
                            widget.combo >= 10 ? '⚡' : '✨',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
