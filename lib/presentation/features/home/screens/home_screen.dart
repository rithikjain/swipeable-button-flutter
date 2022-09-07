import 'dart:developer';

import 'package:cred_assignment/presentation/features/home/cubit/home_cubit.dart';
import 'package:cred_assignment/presentation/features/home/widgets/cred_card.dart';
import 'package:cred_assignment/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../cubit/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSuccess = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is FailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: const TextStyle(color: white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlutterSwitch(
                        value: _isSuccess,
                        activeText: 'Success',
                        activeColor: Colors.green,
                        inactiveText: 'Failure',
                        inactiveColor: Colors.red,
                        valueFontSize: 8,
                        showOnOff: true,
                        onToggle: ((value) {
                          setState(() {
                            _isSuccess = value;
                          });
                        }),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<HomeCubit>().resetCard();
                        },
                        child: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CredCard(
                    onSwipe: () {
                      log("SWIPED");
                      context.read<HomeCubit>().getResult(_isSuccess);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
