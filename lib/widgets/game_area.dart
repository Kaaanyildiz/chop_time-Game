import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/game_models.dart';
import '../utils/image_assets.dart';

class GameArea extends StatelessWidget {
  final AnimationController ingredientController;
  final VoidCallback onTap;

  const GameArea({
    super.key,
    required this.ingredientController,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageAssets.gameBackground),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.1),
              BlendMode.darken,
            ),
            onError: (exception, stackTrace) {
              // Fallback if image not found
            },
          ),
        ),
        child: Consumer<GameController>(
          builder: (context, controller, child) {
            return CustomPaint(
              painter: GameAreaPainter(
                ingredientPosition: controller.ingredientPosition,
                currentIngredient: controller.gameState.currentIngredient,
                isInCutZone: controller.isInCutZone,
                context: context,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class GameAreaPainter extends CustomPainter {
  final double ingredientPosition;
  final IngredientType? currentIngredient;
  final bool isInCutZone;
  final BuildContext context;

  GameAreaPainter({
    required this.ingredientPosition,
    required this.currentIngredient,
    required this.isInCutZone,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawWoodenBoard(canvas, size);
    _drawCuttingLine(canvas, size);
    _drawPerfectZone(canvas, size);
    _drawKnife(canvas, size);
    if (currentIngredient != null) {
      _drawIngredient(canvas, size);
    }
  }
  void _drawWoodenBoard(Canvas canvas, Size size) {
    final boardRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.3,
      size.width * 0.8,
      size.height * 0.4,
    );

    // Kesme tahtası görüntüsünü çizmeye çalış
    _drawImage(canvas, ImageAssets.cuttingBoard, boardRect);
    
    // Görüntü yoksa fallback - ahşap doku gradyanı
    final boardPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFD2691E),
          const Color(0xFF8B4513),
          const Color(0xFF654321),
          const Color(0xFF2F1B14),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(boardRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(boardRect, const Radius.circular(15)),
      boardPaint,
    );

    // Ahşap doku çizgileri
    final texturePaint = Paint()
      ..color = const Color(0xFF654321).withValues(alpha: 0.3)
      ..strokeWidth = 2;

    for (int i = 0; i < 8; i++) {
      final y = boardRect.top + (boardRect.height / 8) * i;
      final opacity = (i % 2 == 0) ? 0.4 : 0.2;
      texturePaint.color = const Color(0xFF4A2C17).withValues(alpha: opacity);
      
      canvas.drawLine(
        Offset(boardRect.left, y),
        Offset(boardRect.right, y),
        texturePaint,
      );
    }

    // Gölge efekti
    final shadowPaint = Paint()
      ..color = const Color(0xFF4A2C17).withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        boardRect.translate(4, 4),
        const Radius.circular(15),
      ),
      shadowPaint,
    );
  }

  void _drawCuttingLine(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    
    // Ana kesim çizgisi - parlayan efekt
    final linePaint = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..strokeWidth = 4
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.yellow.withValues(alpha: 0.3),
          Colors.yellow,
          Colors.yellow,
          Colors.yellow.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromLTWH(centerX - 2, 0, 4, size.height));

    canvas.drawLine(
      Offset(centerX, size.height * 0.2),
      Offset(centerX, size.height * 0.8),
      linePaint,
    );

    // Glow efekti
    final glowPaint = Paint()
      ..color = Colors.yellow.withValues(alpha: 0.3)
      ..strokeWidth = 12
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawLine(
      Offset(centerX, size.height * 0.2),
      Offset(centerX, size.height * 0.8),
      glowPaint,
    );
  }

  void _drawPerfectZone(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final zoneWidth = size.width * 0.1;
    
    // Perfect zone görsel göstergesi
    final zonePaint = Paint()
      ..color = (isInCutZone ? Colors.green : Colors.yellow).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final zoneRect = Rect.fromCenter(
      center: Offset(centerX, size.height * 0.5),
      width: zoneWidth,
      height: size.height * 0.6,
    );

    canvas.drawRect(zoneRect, zonePaint);

    // Zone kenarlıkları
    final borderPaint = Paint()
      ..color = isInCutZone ? Colors.green : Colors.yellow
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(zoneRect, borderPaint);
  }

  void _drawKnife(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    
    // Bıçak sapı
    final handlePath = Path();
    handlePath.moveTo(centerX - 15, size.height * 0.15);
    handlePath.lineTo(centerX + 15, size.height * 0.15);
    handlePath.lineTo(centerX + 5, size.height * 0.2);
    handlePath.lineTo(centerX - 5, size.height * 0.2);
    handlePath.close();

    final handlePaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    canvas.drawPath(handlePath, handlePaint);

    // Bıçak ucu
    final bladePaint = Paint()
      ..color = const Color(0xFF8B4513);

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.12),
        width: 8,
        height: 20,
      ),
      bladePaint,
    );
  }  void _drawIngredient(Canvas canvas, Size size) {
    if (currentIngredient == null) return;

    final centerY = size.height * 0.5;
    final ingredientX = size.width * 0.1 + 
        (size.width * 0.8) * ((ingredientPosition + 1.0) / 2.0);

    // Malzeme görüntüsünü çizmeye çalış
    final ingredientAsset = ImageAssets.getIngredientPath(currentIngredient!, IngredientState.normal);
    final ingredientRect = Rect.fromCenter(
      center: Offset(ingredientX, centerY),
      width: 60,
      height: 60,
    );

    // Gölge efekti
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(
      Offset(ingredientX + 2, centerY + 2),
      30,
      shadowPaint,
    );

    // Görüntü çizmeyi dene, başarısız olursa fallback kullan
    if (!_drawImage(canvas, ingredientAsset, ingredientRect)) {
      // Fallback - programmatic ingredient drawing
      final ingredientPaint = Paint()
        ..color = _getIngredientColor(currentIngredient!)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(ingredientX, centerY),
        30,
        ingredientPaint,
      );

      // Malzeme detayları (daha gerçekçi görünüm)
      final detailPaint = Paint()
        ..color = _getIngredientColor(currentIngredient!).withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(ingredientX - 8, centerY - 8),
        12,
        detailPaint,
      );

      // Parlaklık efekti
      final shinePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(ingredientX - 10, centerY - 10),
        8,
        shinePaint,
      );
    }
  }

  // Görüntü çizim yardımcı metodu
  bool _drawImage(Canvas canvas, String assetPath, Rect destinationRect) {
    try {
      // Bu kısım gerçek implementasyonda AssetImage yükleme gerektirecek
      // Şu an için sadece false döndürüyoruz (fallback kullanılsın)
      return false;
    } catch (e) {
      return false;
    }
  }
  Color _getIngredientColor(IngredientType type) {
    switch (type) {
      case IngredientType.carrot:
        return Colors.orange;
      case IngredientType.tomato:
        return Colors.red;
      case IngredientType.cucumber:
        return Colors.green;
      case IngredientType.onion:
        return const Color(0xFFF5F5DC);
      case IngredientType.potato:
        return const Color(0xFFDEB887);
      case IngredientType.pepper:
        return Colors.red[700]!;
    }
  }

  @override
  bool shouldRepaint(GameAreaPainter oldDelegate) {
    return oldDelegate.ingredientPosition != ingredientPosition ||
           oldDelegate.currentIngredient != currentIngredient ||
           oldDelegate.isInCutZone != isInCutZone;
  }
}
