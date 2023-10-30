import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';

class SettingTileItem extends StatelessWidget {
  String title;
  String? subtitle;
  IconData iconData;
  Function onPressFunc;
  SettingTileItem({
    required this.title,
    required this.iconData,
    required this.onPressFunc,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      paddingHorizontal: 5,
      paddingVertical: 5,
      marginVertical: 10,
      backgroundColor: Colors.white,
      child: ListTile(
        horizontalTitleGap: 2,
        leading: Icon(
          iconData,
          size: 22,
          color: const Color(0xFFCFBAF0),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        subtitle: (subtitle == null)
            ? null
            : Text(subtitle!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade500,
                )),
        onTap: () => onPressFunc(),
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          size: 22,
        ),
      ),
    );
  }
}
