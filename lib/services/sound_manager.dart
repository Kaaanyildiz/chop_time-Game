import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;

  bool get soundEnabled => _soundEnabled;

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  Future<void> playSound(SoundType type) async {
    if (!_soundEnabled) return;

    try {
      // Bu örnekte basit sistem sesleri kullanıyoruz
      // Gerçek projede ses dosyaları assets klasöründe olacak
      switch (type) {
        case SoundType.perfectCut:
          // await _audioPlayer.play(AssetSource('sounds/perfect_cut.mp3'));
          if (kDebugMode) print('🎵 Perfect Cut Sound');
          break;
        case SoundType.goodCut:
          // await _audioPlayer.play(AssetSource('sounds/good_cut.mp3'));
          if (kDebugMode) print('🎵 Good Cut Sound');
          break;
        case SoundType.missedCut:
          // await _audioPlayer.play(AssetSource('sounds/missed_cut.mp3'));
          if (kDebugMode) print('🎵 Missed Cut Sound');
          break;
        case SoundType.gameStart:
          // await _audioPlayer.play(AssetSource('sounds/game_start.mp3'));
          if (kDebugMode) print('🎵 Game Start Sound');
          break;
        case SoundType.gameOver:
          // await _audioPlayer.play(AssetSource('sounds/game_over.mp3'));
          if (kDebugMode) print('🎵 Game Over Sound');
          break;        case SoundType.ingredient:
          // await _audioPlayer.play(AssetSource('sounds/ingredient.mp3'));
          if (kDebugMode) print('🎵 Ingredient Sound');
          break;
        case SoundType.countdown:
          // await _audioPlayer.play(AssetSource('sounds/countdown.mp3'));
          if (kDebugMode) print('🎵 Countdown Sound');
          break;
      }
    } catch (e) {
      if (kDebugMode) print('Sound error: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

enum SoundType {
  perfectCut,
  goodCut,
  missedCut,
  gameStart,
  gameOver,
  ingredient,
  countdown,
}
