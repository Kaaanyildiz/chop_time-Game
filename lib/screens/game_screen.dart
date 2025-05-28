import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/game_models.dart';
import '../widgets/score_display.dart';
import '../widgets/combo_display.dart';
import '../widgets/game_area.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> 
    with TickerProviderStateMixin {
  late AnimationController _ingredientController;
  late GameController _gameController;

  @override
  void initState() {
    super.initState();
    _ingredientController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _gameController = GameController();
    _gameController.setAnimationController(_ingredientController);
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameController,
      child: Scaffold(
        backgroundColor: const Color(0xFF2D1B69),
        body: SafeArea(
          child: Consumer<GameController>(
            builder: (context, controller, child) {
              if (!controller.gameState.isGameActive && 
                  controller.gameState.currentRound == 0) {
                return _buildStartScreen(controller);
              }
              
              if (!controller.gameState.isGameActive && 
                  controller.gameState.results.isNotEmpty) {
                return _buildGameOverScreen(controller);
              }
              
              return _buildGameScreen(controller);
            },
          ),
        ),
      ),
    );
  }
  Widget _buildStartScreen(GameController controller) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            Color(0xFF4A148C),
            Color(0xFF6A1B9A),
            Color(0xFF8E24AA),
            Color(0xFF1A0E3D),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.1),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasyonlu logo
              TweenAnimationBuilder(
                duration: const Duration(seconds: 2),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFFFFEB3B),
                            Color(0xFFFFC107),
                            Color(0xFFFF9800),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🔪',
                          style: TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              
              // Ana başlık
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFFFA500),
                    Color(0xFFFF6B35),
                  ],
                ).createShader(bounds),
                child: const Text(
                  'KES ZAMANI',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              
              // Alt başlık
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'Mükemmel zamanlama ile şeflik seviyesine ulaş!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
              
              // Başlat butonu
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1500),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: GestureDetector(
                      onTap: () => controller.startGame(),
                      child: Container(
                        width: 200,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFF6B6B),
                              Color(0xFFFF5722),
                              Color(0xFFE91E63),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.1),
                              blurRadius: 2,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'BAŞLA',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
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
              
              const SizedBox(height: 60),
              
              // Nasıl oynanır kutusu
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.help,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'NASIL OYNANIR?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInstructionItem('🥕', 'Malzeme düşerken bekle'),
                    _buildInstructionItem('⚡', 'Kesim çizgisini yakala'),
                    _buildInstructionItem('🎯', 'Mükemmel zamanlama yap'),
                    _buildInstructionItem('🏆', 'Combo zinciri oluştur'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGameScreen(GameController controller) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF1A237E),
            Color(0xFF283593),
            Color(0xFF3F51B5),
            Color(0xFF0D1B2A),
          ],
          stops: [0.0, 0.4, 0.7, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.1),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: Column(
          children: [
            // Üst bilgi çubuğu
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [                  ScoreDisplay(
                    score: controller.gameState.totalScore,
                  ),
                  ComboDisplay(
                    combo: controller.gameState.currentCombo,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF42A5F5),
                          Color(0xFF1E88E5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.flag,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${controller.gameState.currentRound}/${controller.gameState.totalRounds}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Oyun alanı
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GameArea(
                    ingredientController: _ingredientController,
                    onTap: controller.onTap,
                  ),
                ),
              ),
            ),
            
            // Son kesim sonucu
            if (controller.gameState.results.isNotEmpty)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                child: _buildLastResult(controller.gameState.results.last),
              ),
              
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
  Widget _buildLastResult(CutResult result) {
    Color primaryColor;
    Color secondaryColor;
    String text;
    IconData icon;
    
    switch (result.quality) {
      case CutQuality.perfect:
        primaryColor = const Color(0xFFFFD700);
        secondaryColor = const Color(0xFFFFA000);
        text = 'MÜKEMMEL!';
        icon = Icons.star;
        break;
      case CutQuality.good:
        primaryColor = const Color(0xFF4CAF50);
        secondaryColor = const Color(0xFF388E3C);
        text = 'İYİ KESİM!';
        icon = Icons.check_circle;
        break;
      case CutQuality.okay:
        primaryColor = const Color(0xFFFF9800);
        secondaryColor = const Color(0xFFF57C00);
        text = 'FENA DEĞİL';
        icon = Icons.thumb_up;
        break;
      case CutQuality.missed:
        primaryColor = const Color(0xFFF44336);
        secondaryColor = const Color(0xFFD32F2F);
        text = 'KAÇIRDIN!';
        icon = Icons.close;
        break;
    }
    
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  secondaryColor,
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.2),
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (result.quality != CutQuality.missed)
                      Text(
                        '+${result.score} puan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );      },
    );
  }

  Widget _buildGameOverScreen(GameController controller) {
    final perfectCuts = controller.gameState.results
        .where((r) => r.quality == CutQuality.perfect)
        .length;
    final totalRounds = controller.gameState.results.length;
    final percentage = totalRounds > 0 ? (perfectCuts / totalRounds * 100).round() : 0;
    
    String title;
    String emoji;
    Color color;
    
    if (percentage >= 90) {
      title = 'ŞEFLERE HAYRAN!';
      emoji = '👨‍🍳';
      color = const Color(0xFFFFD700);
    } else if (percentage >= 70) {
      title = 'HARIKA İŞ!';
      emoji = '🎉';
      color = const Color(0xFF4CAF50);
    } else if (percentage >= 50) {
      title = 'FENA DEĞİL!';
      emoji = '👍';
      color = const Color(0xFF2196F3);
    } else {
      title = 'DAHA ÇOK PRATİK!';
      emoji = '💪';
      color = const Color(0xFFFF9800);
    }
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF1A237E),
            Color(0xFF283593),
            Color(0xFF3F51B5),
            Color(0xFF0D1B2A),
          ],
          stops: [0.0, 0.4, 0.7, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.1),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasyonlu emoji
              TweenAnimationBuilder(
                duration: const Duration(seconds: 2),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.5 + (0.5 * value),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            color.withValues(alpha: 0.8),
                            color.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              
              // Başlık
              Text(
                title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: color,
                  shadows: const [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Skor bilgisi container'ı
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildScoreRow('🏆', 'TOPLAM SKOR', controller.gameState.totalScore.toString()),
                    const SizedBox(height: 15),
                    _buildScoreRow('⭐', 'MÜKEMMEL KESİM', '$perfectCuts/$totalRounds'),
                    const SizedBox(height: 15),
                    _buildScoreRow('🔥', 'EN UZUN COMBO', controller.gameState.maxCombo.toString()),
                    const SizedBox(height: 15),
                    _buildScoreRow('📊', 'BAŞARI ORANI', '$percentage%'),
                  ],
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tekrar oyna butonu
                  GestureDetector(
                    onTap: () => controller.resetGame(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'YENİDEN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Ana menü butonu
                  GestureDetector(
                    onTap: () => controller.resetGame(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.home, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'ANA MENÜ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(String emoji, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
