import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Oops', 'Please enter your name');
      return;
    }

    await FirestoreService.saveName(name);
    Get.off(() => HomeScreen(name: name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tudeeAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let's get started",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const Gap(16),
            const Text(
              'What should we call you?',
              style: TextStyle(fontSize: 16, color: AppColors.textMuted),
            ),
            const Gap(16),
            TudeeTextField(controller: _nameController, hint: 'Your name'),
            const Gap(16),
            PrimaryButton(label: 'Save', onPressed: _saveName),
          ],
        ),
      ),
    );
  }
}