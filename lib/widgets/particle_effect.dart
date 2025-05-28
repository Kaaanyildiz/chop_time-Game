import 'package:flutter/material.dart';
import 'dart:math';

class ParticleEffect extends StatefulWidget {
  final Offset position;
  final Color color;
  final int particleCount;
  final VoidCallback? onComplete;

  const ParticleEffect({
    super.key,
    required this.position,
    required this.color,
    this.particleCount = 10,
    this.onComplete,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _generateParticles();
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  void _generateParticles() {
    final random = Random();
    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        startPosition: widget.position,
        velocity: Offset(
          (random.nextDouble() - 0.5) * 200,
          (random.nextDouble() - 0.5) * 200,
        ),
        color: widget.color,
        size: random.nextDouble() * 6 + 2,
        life: random.nextDouble() * 0.5 + 0.5,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  final Offset startPosition;
  final Offset velocity;
  final Color color;
  final double size;
  final double life;

  Particle({
    required this.startPosition,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      if (progress > particle.life) continue;

      final relativeProgress = progress / particle.life;
      final currentPosition = Offset(
        particle.startPosition.dx + particle.velocity.dx * relativeProgress,
        particle.startPosition.dy + particle.velocity.dy * relativeProgress,
      );      final alpha = (1.0 - relativeProgress).clamp(0.0, 1.0);
      paint.color = particle.color.withValues(alpha: alpha);
      
      canvas.drawCircle(
        currentPosition,
        particle.size * (1.0 - relativeProgress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
