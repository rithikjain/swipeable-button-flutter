import 'package:cred_assignment/presentation/features/home/animations/show_up.dart';
import 'package:cred_assignment/presentation/features/home/cubit/home_cubit.dart';
import 'package:cred_assignment/presentation/features/home/widgets/swipeable_button.dart';
import 'package:cred_assignment/presentation/features/home/widgets/widget_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../cubit/home_state.dart';

class CredCard extends StatefulWidget {
  final VoidCallback onSwipe;

  const CredCard({
    super.key,
    required this.onSwipe,
  });

  @override
  State<CredCard> createState() => _CredCardState();
}

class _CredCardState extends State<CredCard> with TickerProviderStateMixin {
  double _boxHeight = 200;
  bool _renderWidget = false;

  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    final curve = CurvedAnimation(
      curve: Curves.decelerate,
      parent: _animController,
    );

    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.02), end: Offset.zero)
            .animate(curve);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is InitialState) {
          _animController.reset();
        }
        if (state is SuccessState) {
          _animController.forward();
        }
      },
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 32, left: 32, right: 32),
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SlideTransition(
                          position: _animOffset,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: (state is SuccessState)
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 32),
                                    alignment: Alignment.bottomCenter,
                                    child: const ShowUp(
                                      delay: Duration(milliseconds: 300),
                                      child: Text(
                                        "success",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Expanded(
                  flex: 40,
                  child: SizedBox(),
                ),
                WidgetSize(
                  onChange: (Size size) {
                    setState(() {
                      _boxHeight = size.height;
                      _renderWidget = true;
                    });
                  },
                  child: Expanded(
                    flex: 49,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        (state is InitialState || state is FailureState)
                            ? Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(top: 90),
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Lottie.asset("assets/anim/arrow.json"),
                                ),
                              )
                            : Container(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (_renderWidget)
                                ? SwipeableButton(
                                    height: _boxHeight * 0.75,
                                    width: 100,
                                    onSwipe: widget.onSwipe,
                                  )
                                : Container(),
                            const SizedBox(height: 42),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
