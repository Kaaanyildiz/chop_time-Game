import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ChopTimeApp());
}

class ChopTimeApp extends StatelessWidget {
  const ChopTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sistem UI'ını gizle (tam ekran oyun deneyimi için)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // Sadece portre modunu zorla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Kes Zamanı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D1B69),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
