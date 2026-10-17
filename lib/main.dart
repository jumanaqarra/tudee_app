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
    WidgetsFlutterBinding.ensureInitialized(); // اولا : بجهز الفلاتر

    // WidgetsFlutterBinding: المسؤول عن ربط إطار عمل Flutter بالمنصة التي يعمل عليها التطبيق، وتنظيم التواصل مع أجزاء النظام.
    // ensureInitialized(): تتأكد من أن هذا الربط قد جرى تهيئته قبل استخدامه.

    await Firebase.initializeApp(
// ثانيا : بهيئ الفايربيز لاستخدام خدماته لاحقا وتنتظر اكتمال العملية
      // ما وظيفة await في هذا الكود؟
      // تنتظر اكتمال تهيئة Firebase قبل متابعة التنفيذ.
      // Firebase.initializeApp()؟
      // Firebase هي المكتبة التي تتيح لتطبيقك استخدام خدمات Firebase.
      // initializeApp()
      // فهي دالة تهيّئ تطبيق Firebase وتُنشئ نسخة جاهزة للاستخدام داخل مشروع Flutter.

      options: DefaultFirebaseOptions.currentPlatform,
      // options هنا اسم مُعامل في الدالة، نمرّر من خلاله إعدادات Firebase المطلوبة للمشروع
      /*options هنا اسم مُعامل في الدالة، نمرّر من خلاله إعدادات Firebase المطلوبة للمشروع.
  مثلًا، هذه الإعدادات قد تتضمن معلومات مثل:
  - معرّف مشروع Firebase.
  - مفتاح API الخاص بالمشروع.
  - معرّف التطبيق على المنصة.
  - معلومات أخرى تختلف بحسب المنصة والإعدادات.
  هذه المعلومات تُستخدم لتحديد مشروع Firebase الذي يتصل به التطبيق.*/

      // // DefaultFirebaseOptions
      // كلاس يحتوي على إعدادات Firebase التي جرى توليدها للمنصات المدعومة.

      //   currentPlatform
      /*تحدد إعدادات المنصة الحالية التي يعمل عليها التطبيق، مثل Android أو iOS، وفق المنصات التي أُعدّ المشروع لدعمها.
مثلًا، بما أنك تشغّلين تطبيق Flutter على هاتف Android، سيُستخدم إعداد Firebase الخاص بـ Android.
*/
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