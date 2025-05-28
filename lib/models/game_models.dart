enum IngredientType {
  carrot,
  onion,
  tomato,
  potato,
  pepper,
  cucumber
}

enum IngredientState {
  normal,
  cut,
  perfect
}

enum CutQuality {
  perfect,
  good,
  okay,
  missed
}

class Ingredient {
  final IngredientType type;
  final double speed;
  final double size;
  final String imagePath;
  
  const Ingredient({
    required this.type,
    required this.speed,
    required this.size,
    required this.imagePath,
  });
  
  static const Map<IngredientType, Ingredient> ingredients = {
    IngredientType.carrot: Ingredient(
      type: IngredientType.carrot,
      speed: 1.0,
      size: 1.0,
      imagePath: '🥕',
    ),
    IngredientType.onion: Ingredient(
      type: IngredientType.onion,
      speed: 0.8,
      size: 1.2,
      imagePath: '🧅',
    ),
    IngredientType.tomato: Ingredient(
      type: IngredientType.tomato,
      speed: 1.2,
      size: 0.9,
      imagePath: '🍅',
    ),
    IngredientType.potato: Ingredient(
      type: IngredientType.potato,
      speed: 0.7,
      size: 1.3,
      imagePath: '🥔',
    ),
    IngredientType.pepper: Ingredient(
      type: IngredientType.pepper,
      speed: 1.5,
      size: 0.8,
      imagePath: '🌶️',
    ),
    IngredientType.cucumber: Ingredient(
      type: IngredientType.cucumber,
      speed: 1.1,
      size: 1.1,
      imagePath: '🥒',
    ),
  };
}

class CutResult {
  final CutQuality quality;
  final int score;
  final double timing; // -1.0 (çok erken) ile 1.0 (çok geç) arası
  
  const CutResult({
    required this.quality,
    required this.score,
    required this.timing,
  });
  
  static CutResult fromTiming(double timing) {
    final absTime = timing.abs();
    
    if (absTime <= 0.1) {
      return CutResult(
        quality: CutQuality.perfect,
        score: 100,
        timing: timing,
      );
    } else if (absTime <= 0.25) {
      return CutResult(
        quality: CutQuality.good,
        score: 75,
        timing: timing,
      );
    } else if (absTime <= 0.4) {
      return CutResult(
        quality: CutQuality.okay,
        score: 25,
        timing: timing,
      );
    } else {
      return CutResult(
        quality: CutQuality.missed,
        score: 0,
        timing: timing,
      );
    }
  }
}

class GameState {
  final int currentRound;
  final int totalRounds;
  final int totalScore;
  final List<CutResult> results;
  final bool isGameActive;
  final IngredientType? currentIngredient;
  final int currentCombo;
  final int maxCombo;
  
  const GameState({
    this.currentRound = 0,
    this.totalRounds = 5,
    this.totalScore = 0,
    this.results = const [],
    this.isGameActive = false,
    this.currentIngredient,
    this.currentCombo = 0,
    this.maxCombo = 0,
  });
  
  GameState copyWith({
    int? currentRound,
    int? totalRounds,
    int? totalScore,
    List<CutResult>? results,
    bool? isGameActive,
    IngredientType? currentIngredient,
    int? currentCombo,
    int? maxCombo,
  }) {
    return GameState(
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      totalScore: totalScore ?? this.totalScore,
      results: results ?? this.results,
      isGameActive: isGameActive ?? this.isGameActive,
      currentIngredient: currentIngredient ?? this.currentIngredient,
      currentCombo: currentCombo ?? this.currentCombo,
      maxCombo: maxCombo ?? this.maxCombo,
    );
  }
}
