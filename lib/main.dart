import 'package:cred_assignment/presentation/features/home/cubit/home_cubit.dart';
import 'package:cred_assignment/presentation/features/home/screens/home_screen.dart';
import 'package:cred_assignment/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: darkGrey,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cred Assignment',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: BlocProvider(
        create: (context) => HomeCubit(),
        child: const HomeScreen(),
      ),
    );
  }
}
