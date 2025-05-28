import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import '../models/game_models.dart';
import '../services/sound_manager.dart';

class GameController extends ChangeNotifier {
  GameState _gameState = const GameState();
  Timer? _gameTimer;
  Timer? _roundTimer;
  late AnimationController _ingredientAnimationController;
  bool _isDisposed = false;
  
  // Malzeme hareketi için
  double _ingredientPosition = -1.0; // -1.0 (sol) ile 1.0 (sağ) arası
  final double _cutZone = 0.0; // Kesim çizgisi pozisyonu
  final double _perfectZone = 0.05; // Perfect kesim için tolerans
  
  GameState get gameState => _gameState;
  double get ingredientPosition => _ingredientPosition;
  bool get isInCutZone => (_ingredientPosition - _cutZone).abs() <= _perfectZone;
    void setAnimationController(AnimationController controller) {
    _ingredientAnimationController = controller;
    _ingredientAnimationController.addListener(_updateIngredientPosition);
  }
  
  void _updateIngredientPosition() {
    if (_isDisposed) return;
    // Malzemenin pozisyonunu -1.0'dan 1.0'a hareket ettir
    _ingredientPosition = -1.0 + (2.0 * _ingredientAnimationController.value);
    notifyListeners();
  }
    void startGame() {
    _gameState = _gameState.copyWith(
      isGameActive: true,
      currentRound: 0,
      totalScore: 0,
      results: [],
    );
    
    SoundManager().playSound(SoundType.gameStart);
    _startNextRound();
    notifyListeners();
  }
  
  void _startNextRound() {
    if (_gameState.currentRound >= _gameState.totalRounds) {
      _endGame();
      return;
    }
    
    // Yeni tur başlat
    _gameState = _gameState.copyWith(
      currentRound: _gameState.currentRound + 1,
      currentIngredient: _getRandomIngredient(),
    );
    
    // 3-2-1 countdown sonrası malzeme hareketi başlat
    Future.delayed(const Duration(seconds: 1), () {
      _startIngredientMovement();
    });
    
    notifyListeners();
  }
  
  IngredientType _getRandomIngredient() {
    final ingredients = IngredientType.values;
    return ingredients[Random().nextInt(ingredients.length)];
  }    void _startIngredientMovement() {
    if (_isDisposed || _gameState.currentIngredient == null) return;
    
    final ingredient = Ingredient.ingredients[_gameState.currentIngredient]!;
    final duration = Duration(milliseconds: (2000 / ingredient.speed).round());
    
    SoundManager().playSound(SoundType.ingredient);
    
    if (!_isDisposed) {
      _ingredientAnimationController.reset();
      _ingredientAnimationController.duration = duration;
      _ingredientAnimationController.forward();
    }
    
    // Eğer oyuncu tıklamazsa otomatik olarak missed olsun
    _roundTimer = Timer(duration, () {
      if (_gameState.isGameActive) {
        _processCut(double.infinity); // Çok geç = missed
      }
    });
  }
  
  void onTap() {
    if (!_gameState.isGameActive || _gameState.currentIngredient == null) {
      return;
    }
    
    // Timing hesapla: malzemenin kesim çizgisine ne kadar yakın olduğu
    final timing = _ingredientPosition - _cutZone;
    _processCut(timing);
  }    void _processCut(double timing) {
    if (_isDisposed) return;
    
    _roundTimer?.cancel();
    if (!_isDisposed && _ingredientAnimationController.isAnimating) {
      _ingredientAnimationController.stop();
    }
    
    final result = CutResult.fromTiming(timing);
    final newResults = List<CutResult>.from(_gameState.results)..add(result);
    
    // Combo hesaplama
    int newCombo = _gameState.currentCombo;
    int newMaxCombo = _gameState.maxCombo;
    
    if (result.quality == CutQuality.perfect || result.quality == CutQuality.good) {
      newCombo += 1;
      if (newCombo > newMaxCombo) {
        newMaxCombo = newCombo;
      }
    } else {
      newCombo = 0;
    }
    
    // Combo bonusu hesaplama
    int finalScore = result.score;
    if (newCombo >= 2) {
      final comboBonus = (newCombo * 10).clamp(0, 50);
      finalScore += comboBonus;
    }
    
    _gameState = _gameState.copyWith(
      totalScore: _gameState.totalScore + finalScore,
      results: newResults,
      currentCombo: newCombo,
      maxCombo: newMaxCombo,
    );
    
    // Feedback
    _provideFeedback(result.quality);
    
    // Sonuçları göster ve sonraki tura geç
    Future.delayed(const Duration(milliseconds: 1500), () {
      _startNextRound();
    });
    
    notifyListeners();
  }
  void _provideFeedback(CutQuality quality) async {
    // Ses efektleri
    switch (quality) {
      case CutQuality.perfect:
        SoundManager().playSound(SoundType.perfectCut);
        break;
      case CutQuality.good:
        SoundManager().playSound(SoundType.goodCut);
        break;
      case CutQuality.okay:
        SoundManager().playSound(SoundType.goodCut);
        break;
      case CutQuality.missed:
        SoundManager().playSound(SoundType.missedCut);
        break;
    }
    
    // Haptic feedback
    if (quality == CutQuality.perfect) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }
    void _endGame() {
    SoundManager().playSound(SoundType.gameOver);
    _gameState = _gameState.copyWith(isGameActive: false);
    _cleanup();
    notifyListeners();
  }
  
  void resetGame() {
    _cleanup();
    _gameState = const GameState();
    notifyListeners();
  }
    void _cleanup() {
    _gameTimer?.cancel();
    _roundTimer?.cancel();
    if (!_isDisposed && _ingredientAnimationController.isCompleted == false) {
      _ingredientAnimationController.reset();
    }
  }
  
  @override
  void dispose() {
    _isDisposed = true;
    _cleanup();
    super.dispose();
  }
}
