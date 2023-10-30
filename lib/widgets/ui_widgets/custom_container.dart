import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double marginHorizontal;
  final double marginVertical;
  final double paddingHorizontal;
  final double paddingVertical;
  final Color borderColor;
  final double? height;
  final double? width;

  const CustomContainer({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.marginHorizontal = 0,
    this.marginVertical = 0,
    this.paddingHorizontal = 0,
    this.paddingVertical = 0,
    this.borderColor = const Color(0xFF58315A),
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: marginVertical),
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF96D1BD),
        boxShadow: [
          BoxShadow(
            color: borderColor,
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
        border: Border.all(color: borderColor, width: 4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}
