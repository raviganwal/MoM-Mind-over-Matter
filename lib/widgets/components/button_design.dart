import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonDesign extends StatelessWidget {
  final String btnText;
  final Color? bgColor;
  final Color? shadowColor;
  final Color? txtColor;
  final Function btnFunction;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final double? width;
  final double? height;
  final double? marginHorizontal;
  final double? marginVertical;
  final double? paddingValue;
  final double? fontSize; // New optional parameter for font size

  const ButtonDesign({
    Key? key,
    required this.btnText,
    required this.btnFunction,
    this.bgColor,
    this.shadowColor,
    this.txtColor,
    this.prefixWidget,
    this.suffixWidget,
    this.width,
    this.height,
    this.marginHorizontal,
    this.marginVertical,
    this.paddingValue,
    this.fontSize, // Add font size parameter to the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => btnFunction(),
      child: Container(
        width: width,
        height: height,
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: bgColor ?? const Color(0xFF80D0DD),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            width: 4.0,
            color: shadowColor ?? const Color(0xFF58315A),
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? const Color(0xFF58315A),
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(paddingValue ?? 16.0),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            alignment: Alignment.center,
            children: [
              if (prefixWidget != null) ...[
                Align(alignment: Alignment.centerLeft, child: prefixWidget!),
                const SizedBox(width: 15),
              ],
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  btnText,
                  style: GoogleFonts.montserrat(
                    fontSize: fontSize ??
                        16, // Use the font size parameter, or fallback to 16
                    fontWeight: FontWeight.bold,
                    color: txtColor ?? const Color(0xFF58315A),
                  ),
                ),
              ),
              if (suffixWidget != null) ...[
                Align(alignment: Alignment.centerRight, child: suffixWidget!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
