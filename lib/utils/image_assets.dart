enum IngredientType {
  tomato,
  carrot,
  onion,
  potato,
  pepper,
  cucumber,
}

enum IngredientState {
  normal,
  cut,
  perfect,
}

import '../models/game_models.dart';

class ImageAssets {
  // Backgrounds
  static const String homeBackground = 'assets/backgrounds/home_background.png';
  static const String gameBackground = 'assets/backgrounds/game_background.png';
  
  // Cutting Board
  static const String cuttingBoard = 'assets/images/cutting_board.png';
  
  // UI Elements
  static const String playButton = 'assets/ui/play_button.png';
  static const String scoreBg = 'assets/ui/score_bg.png';
  static const String comboRing = 'assets/ui/combo_ring.png';
  static const String progressBarBg = 'assets/ui/progress_bar_bg.png';
  static const String progressBarFill = 'assets/ui/progress_bar_fill.png';
  
  // Effects
  static const String cutSlash = 'assets/effects/cut_slash.png';
  static const String perfectStar = 'assets/effects/perfect_star.png';
  static const String comboExplosion = 'assets/effects/combo_explosion.png';
  static const String particleSparkle = 'assets/effects/particle_sparkle.png';
  
  // Ingredients - Normal
  static const String tomatoNormal = 'assets/ingredients/tomato_normal.png';
  static const String carrotNormal = 'assets/ingredients/carrot_normal.png';
  static const String onionNormal = 'assets/ingredients/onion_normal.png';
  static const String potatoNormal = 'assets/ingredients/potato_normal.png';
  static const String appleNormal = 'assets/ingredients/apple_normal.png';
  
  // Ingredients - Cut
  static const String tomatoCut = 'assets/ingredients/tomato_cut.png';
  static const String carrotCut = 'assets/ingredients/carrot_cut.png';
  static const String onionCut = 'assets/ingredients/onion_cut.png';
  static const String potatoCut = 'assets/ingredients/potato_cut.png';
  static const String appleCut = 'assets/ingredients/apple_cut.png';
  
  // Ingredients - Perfect
  static const String tomatoPerfect = 'assets/ingredients/tomato_perfect.png';
  static const String carrotPerfect = 'assets/ingredients/carrot_perfect.png';
  static const String onionPerfect = 'assets/ingredients/onion_perfect.png';
  static const String potatoPerfect = 'assets/ingredients/potato_perfect.png';
  static const String applePerfect = 'assets/ingredients/apple_perfect.png';
  
  // Helper methods updated for IngredientType enum
  static String getIngredientPath(IngredientType type, IngredientState state) {
    final ingredientName = _getIngredientName(type);
    
    switch (state) {
      case IngredientState.normal:
        return getIngredientNormal(ingredientName);
      case IngredientState.cut:
        return getIngredientCut(ingredientName);
      case IngredientState.perfect:
        return getIngredientPerfect(ingredientName);
    }
  }
  
  static String _getIngredientName(IngredientType type) {
    switch (type) {
      case IngredientType.tomato:
        return 'tomato';
      case IngredientType.carrot:
        return 'carrot';
      case IngredientType.onion:
        return 'onion';
      case IngredientType.potato:
        return 'potato';
      case IngredientType.pepper:
        return 'apple'; // pepper kullanmak yerine apple kullanıyoruz
      case IngredientType.cucumber:
        return 'apple'; // cucumber kullanmak yerine apple kullanıyoruz
    }
  }
  
  static String getIngredientNormal(String ingredient) {
    switch (ingredient) {
      case 'tomato':
        return tomatoNormal;
      case 'carrot':
        return carrotNormal;
      case 'onion':
        return onionNormal;
      case 'potato':
        return potatoNormal;
      case 'apple':
        return appleNormal;
      default:
        return tomatoNormal;
    }
  }
  
  static String getIngredientCut(String ingredient) {
    switch (ingredient) {
      case 'tomato':
        return tomatoCut;
      case 'carrot':
        return carrotCut;
      case 'onion':
        return onionCut;
      case 'potato':
        return potatoCut;
      case 'apple':
        return appleCut;
      default:
        return tomatoCut;
    }
  }
  
  static String getIngredientPerfect(String ingredient) {
    switch (ingredient) {
      case 'tomato':
        return tomatoPerfect;
      case 'carrot':
        return carrotPerfect;
      case 'onion':
        return onionPerfect;
      case 'potato':
        return potatoPerfect;
      case 'apple':
        return applePerfect;
      default:
        return tomatoPerfect;
    }
  }
}
