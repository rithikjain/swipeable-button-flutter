import 'package:cred_assignment/presentation/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_state.dart';

class SwipeableWidget extends StatefulWidget {
  final Widget child;
  final double height;
  final double width;
  final double widgetHeight;
  final VoidCallback onSwipe;
  final double swipePercentageNeeded;

  const SwipeableWidget({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.widgetHeight,
    required this.onSwipe,
    this.swipePercentageNeeded = 0.80,
  });

  @override
  State<SwipeableWidget> createState() => _SwipeableWidgetState();
}

class _SwipeableWidgetState extends State<SwipeableWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _hoverAnimController;
  late final Animation<Offset> _animation = Tween(
    begin: Offset.zero,
    end: const Offset(0, 0.085),
  ).animate(_hoverAnimController);

  var _dyStartPosition = 0.0;
  var _dyEndsPosition = 0.0;

  bool _isVisible = true;

  late double _height;

  @override
  void initState() {
    super.initState();

    _height = widget.height - widget.widgetHeight;

    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: _height,
      duration: const Duration(milliseconds: 300),
    )..addListener(
        () {
          setState(() {});
        },
      );

    _hoverAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);

    _controller.value = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is FailureState || state is InitialState) {
          setState(() {
            _isVisible = true;
          });
          _controller.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onPanStart: (details) {
            setState(() {
              _dyStartPosition = details.localPosition.dy;
              _controller.animateTo(_dyStartPosition);
              _hoverAnimController.stop();
            });
          },
          onPanUpdate: (details) {
            final widgetSize = _height;

            // will only animate the swipe if user starts the swipe in the first 70% of the widget
            final minimumYToStartSwiping = widgetSize * 0.70;
            if (_dyStartPosition <= minimumYToStartSwiping) {
              setState(() {
                _dyEndsPosition = details.localPosition.dy;
                _controller.value = _dyEndsPosition;
              });
            }
          },
          onPanEnd: (details) async {
            _hoverAnimController.repeat(reverse: true);

            // checks if the swipe done is enough or not
            final delta = _dyEndsPosition - _dyStartPosition;
            final widgetSize = _height;
            final deltaNeededToBeSwiped =
                widgetSize * widget.swipePercentageNeeded;
            if (delta > deltaNeededToBeSwiped) {
              // if it's enough, then animate to the end
              _controller.animateTo(
                widget.height,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
              );
              setState(() {
                _isVisible = false;
              });
              widget.onSwipe();
            } else {
              // if it's not enough, then animate it back to its intial position
              _controller.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
              );
            }
          },
          child: SizedBox(
            height: widget.height,
            width: widget.width,
            child: Stack(
              children: [
                Visibility(
                  visible: _isVisible,
                  child: Positioned(
                    top: _controller.value,
                    child: SlideTransition(
                      position: _animation,
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
