import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final double? fontSize;

  const CustomHeader({Key? key, required this.title, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 176,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/images/ui_components/appbar_bg.png"),
//           fit: BoxFit.fitHeight,
// // Set the x and y offset values here
//         ),
          ),
      child: Stack(
        children: [
          Container(
            height: 50,
            width: 175,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/ui_components/appbar_bg.png"),

                alignment:
                    Alignment(-0.4, -0.4), // Set the x and y offset values here
              ),
            ),
          ),
          Container(
            height: 50,
            width: 175,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/ui_components/appbar_2.png"),

                // Set the x and y offset values here
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 13, bottom: 6),
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: fontSize ?? 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
