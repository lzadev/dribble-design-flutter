import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/firebase_options.dart';
import 'package:login_app/providers/auth_provider.dart';
import 'package:login_app/providers/todo_service_provider.dart';
import 'package:login_app/screens/auth_screen.dart';
import 'package:login_app/screens/screens.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => TodoServicePorvider(),
          lazy: true,
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dribble Design',
      home: const AuthScreen(),
      routes: {
        // 'auth': (context) => const AuthScreen(),
        'home': (context) => const HomeScreen(),
        'note': (context) => const NoteScreen()
      },
    );
  }
}
