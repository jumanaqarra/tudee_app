import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/firestore_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TudeeApp());
}

class TudeeApp extends StatefulWidget {
  const TudeeApp({super.key});

  @override
  State<TudeeApp> createState() => _TudeeAppState();
}

class _TudeeAppState extends State<TudeeApp> {
  late final Future<String?> initFuture;

  @override
  void initState() {
    super.initState();
    initFuture = init();
  }

  /// Starts Firebase, then returns the saved name (or null if none).
  Future<String?> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final name = await FirestoreService.getName();
    if (name == null || name.trim().isEmpty) return null;
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tudee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: FutureBuilder<String?>(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final name = snapshot.data;
          return name == null ? const WelcomeScreen() : HomeScreen(name: name);
        },
      ),
    );
  }
}