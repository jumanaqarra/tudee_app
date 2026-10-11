import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/task_model.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
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
  late final Future<bool> initFuture;

  @override
  void initState() {
    super.initState();
    initFuture = initHive();
  }

  /// Opens Hive and returns true if the user already saved a name.
  Future<bool> initHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    await Hive.openBox('settings');
    await Hive.openBox<TaskModel>('tasks');

    final name = Hive.box('settings').get('name') as String?;
    return name != null && name.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tudee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: FutureBuilder<bool>(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          }
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!
              ? const HomeScreen()
              : const WelcomeScreen();
        },
      ),
    );
  }
}