import 'package:fitsteps_app/data/blocs/auth/auth_bloc.dart';
import 'package:fitsteps_app/data/screens/auth/login_screen.dart';
import 'package:fitsteps_app/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const FitStepsApp());
}

class FitStepsApp extends StatelessWidget {
  const FitStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(AuthService())),
      ],
      child: MaterialApp(
        title: 'FitSteps',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
        home: const LoginScreen(),
      ),
    );
  }
}
