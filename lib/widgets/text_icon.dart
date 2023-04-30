import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class TextIcon extends StatelessWidget {
  const TextIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Zikr tanlang!",
          style: TextStyle(
            color: _textColor(context),
            fontFamily: GoogleFonts.mPlus1().fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Icon(FlutterIslamicIcons.tasbih2,
            size: 33, color: iconsColor(context)),
      ],
    );
  }
}

Color _textColor(BuildContext context) {
  if (NeumorphicTheme.isUsingDark(context)) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

Color iconsColor(BuildContext context) {
  final theme = NeumorphicTheme.of(context);
  if (theme!.isUsingDark) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}