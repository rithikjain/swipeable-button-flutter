import 'package:cred_assignment/presentation/features/home/cubit/home_cubit.dart';
import 'package:cred_assignment/presentation/features/home/widgets/swipeable_widget.dart';
import 'package:cred_assignment/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../cubit/home_state.dart';

class SwipeableButton extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onSwipe;

  const SwipeableButton({
    super.key,
    required this.width,
    required this.height,
    required this.onSwipe,
  });

  @override
  State<SwipeableButton> createState() => _SwipeableButtonState();
}

class _SwipeableButtonState extends State<SwipeableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 200,
      duration: const Duration(milliseconds: 300),
    )..addListener(
        () {
          setState(() {});
        },
      );

    _animController.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is InitialState) {
          _animController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
          );
        }
        if (state is SuccessState) {
          _animController.animateTo(
            200,
            duration: const Duration(milliseconds: 300),
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          height: widget.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: -1 * _animController.value,
                child: Stack(
                  children: [
                    (state is LoadingState)
                        ? LottieBuilder.asset(
                            "assets/anim/loading.json",
                            height: widget.width,
                            width: widget.width,
                          )
                        : Container(),
                    ClipOval(
                      child: Container(
                        height: widget.width,
                        width: widget.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 1, color: lightGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SwipeableWidget(
                height: widget.height,
                width: widget.width,
                widgetHeight: widget.width,
                onSwipe: widget.onSwipe,
                child: ClipOval(
                  child: Material(
                    child: SizedBox(
                      height: widget.width,
                      width: widget.width,
                      child: Ink.image(
                        image: const AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
