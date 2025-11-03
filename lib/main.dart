import 'package:bloc_state_management/screens/home_screen.dart';
import 'package:bloc_state_management/screens/login_screen.dart';
import 'package:bloc_state_management/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BlocLearningApp());
}

class BlocLearningApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  const BlocLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Learning App',
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      navigatorKey: rootNavigatorKey,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        // ignore: equal_keys_in_map
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
