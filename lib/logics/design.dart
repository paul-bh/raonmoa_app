import 'package:flutter/material.dart';

Color $raonmoaColor = Color(0xFF6781D3);

// animate double value with animation controller
class AnimatedDouble extends AnimatedWidget {
  final double? value;
  final Widget Function(double value) builder;

  AnimatedDouble({
    Key? key,
    required this.value,
    required this.builder,
    required Animation<double> animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return builder(animation.value);
  }
}

//top text style
final TextStyle topTextStyle_sub = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.normal,
  color: Colors.black87,
  shadows: [
    Shadow(
      color: Colors.white,
      offset: Offset(0.5, 0.5),
      blurRadius: 15.0,
    ),
  ],
);
final TextStyle topTextStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.normal,
  color: Colors.black,
  shadows: [
    Shadow(
      color: Colors.white,
      offset: Offset(0.5, 0.5),
      blurRadius: 15.0,
    ),
  ],
);

Widget verticalbar({Color? color, double? width, double? height, EdgeInsets? padding}) {
  color ?? $raonmoaColor;
  width ?? 1.0;
  height ?? 0.0;
  padding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 8);

  return Container(padding: padding, child: Container(width: width, height: height, color: color));
}
