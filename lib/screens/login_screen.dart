import 'package:bloc_state_management/bloc/login/login_bloc.dart';
import 'package:bloc_state_management/bloc/login/login_event.dart';
import 'package:bloc_state_management/bloc/login/login_state.dart';
import 'package:bloc_state_management/screens/home_screen.dart';
import 'package:bloc_state_management/services/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<LoginBloc>().add(LoginSubmitted(email: _email.text, password: _password.text));
  }

  @override
  Widget build(BuildContext context) {
    // Provide the bloc here (no main.dart wiring)
    return BlocProvider(
      create: (_) => LoginBloc(Services.authRepo),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 15, 26, 45),
            body: SafeArea(
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.status == LoginStatus.failure && state.error != null && state.error!.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error!), behavior: SnackBarBehavior.floating),
                    );
                  }
                  if (state.status == LoginStatus.success) {
                    // TODO: Navigate to dashboard / home
                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                  }
                },
                builder: (context, state) {
                  final isLoading = state.status == LoginStatus.loading;

                  return SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: const [
                              Icon(Icons.health_and_safety_rounded, size: 80, color: Color.fromARGB(255, 34, 109, 121)),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const Text("Welcome Back", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        const Text("Login to your account", style: TextStyle(color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _email,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                          ),
                          onSubmitted: (_) => _submit(context),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _password,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          onSubmitted: (_) => _submit(context),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent), splashFactory: NoSplash.splashFactory),
                            onPressed: () {
                              // Navigator.pushNamed(context, ForgetScreen.id);
                            },
                            child: const Text("Forgot Password?", style: TextStyle(color: Colors.white70)),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 34, 109, 121),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ).copyWith(overlayColor: MaterialStateProperty.all(Colors.transparent), splashFactory: NoSplash.splashFactory),
                            onPressed: isLoading ? null : () => _submit(context),
                            child: isLoading
                                ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)))
                                : const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Register now directly with Aurkei ",
                                style: const TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: "Try Here",
                                    style: const TextStyle(color: Color.fromARGB(255, 34, 109, 121), fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()..onTap = () { /* push SignUp */ },
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
