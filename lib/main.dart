import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_notify/firebase_options.dart';
import 'package:firebase_notify/screen_home.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase intial setup
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ScreenHome());
  }
}
