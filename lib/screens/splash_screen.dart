import 'package:bloc_state_management/bloc/splash/splash_bloc.dart';
import 'package:bloc_state_management/bloc/splash/splash_event.dart';
import 'package:bloc_state_management/bloc/splash/splash_state.dart';
import 'package:bloc_state_management/screens/login_screen.dart';
import 'package:bloc_state_management/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// lib/presentation/splash/view/splash_screen.dart

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SplashBloc(Services.storage);
    // Dispatch directly on the instance (no context.read here)
    _bloc.add(const SplashCheckRequested());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 26, 45),
        body: SafeArea(
          child: BlocListener<SplashBloc, SplashState>(
            listener: (context, state) {
              if (state.status == SplashStatus.authenticated) {
                // Navigator.pushReplacementNamed(context, HomeScreen.id);
                // Temporary:
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authenticated → Home')));
              } else if (state.status == SplashStatus.unauthenticated ||
                         state.status == SplashStatus.failure) {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              }
            },
            child: const _SplashBody(),
          ),
        ),
      ),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.health_and_safety_rounded, size: 84, color: Color.fromARGB(255, 34, 109, 121)),
          SizedBox(height: 16),
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('Checking session...', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

