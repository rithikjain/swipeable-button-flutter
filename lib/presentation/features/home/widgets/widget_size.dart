import 'package:flutter/material.dart';

class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function onChange;

  const WidgetSize({
    super.key,
    required this.onChange,
    required this.child,
  });

  @override
  State<WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  var widgetKey = GlobalKey();
  Size oldSize = const Size(0, 0);

  @override
  Widget build(BuildContext context) {
    Future(_postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  Future<void> _postFrameCallback() async {
    await Future.delayed(const Duration(milliseconds: 100));

    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize ?? const Size(0, 0);
    widget.onChange(newSize);
  }
}
