import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';

class SettingToggleTile extends StatelessWidget {
  String title;

  IconData iconData;
  bool toggleValue;
  bool proRequired;
  Function onPressFunc;

  SettingToggleTile({
    Key? key,
    required this.title,
    required this.toggleValue,
    required this.iconData,
    required this.onPressFunc,
    required this.proRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      backgroundColor: Colors.white,
      marginVertical: 10,
      paddingHorizontal: 10,
      child: SwitchListTile(
        value: toggleValue,
        onChanged: (isEnabled) {
          onPressFunc(isEnabled);
        },
        title: Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        // subtitle: Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 5),
        //   child: RichText(
        //     text: TextSpan(
        //       style: DefaultTextStyle.of(context).style,
        //       children: <TextSpan>[
        //         TextSpan(text: subtitle ?? "", style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12)),
        //         const TextSpan(text: ' '),
        //       ],
        //     ),
        //   ),
        // ),
        // subtitle: Text(
        //   subtitle ?? "",
        //   style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
        // ),

        // Text(subtitle, style: Theme.of(context).textTheme.subtitle2),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5,
        ),
        secondary: Icon(
          iconData,
          size: 26,
          color: const Color(0xFFCFBAF0),
        ),
      ),
    );
  }
}
