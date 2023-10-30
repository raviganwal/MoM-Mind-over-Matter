import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSubtitle extends StatelessWidget {
  String title;
  HomeSubtitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
