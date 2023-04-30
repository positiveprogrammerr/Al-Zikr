import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/zikr_screen.dart';
import '../screens/home_screen.dart';

class ZikrButtons extends StatefulWidget {
  final int index;
  final List<String> zikrNames;
  const ZikrButtons({super.key, required this.index, required this.zikrNames});

  @override
  State<ZikrButtons> createState() => _ZikrButtonsState();
}

class _ZikrButtonsState extends State<ZikrButtons> {
  String zikrArabic = '';
  String zikrUzbek = '';

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: () {
        if (widget.index == 0) {
          setState(() {
            zikrArabic = widget.zikrNames[0];
            zikrUzbek = 'Allohni poklab yod etaman';
          });
        } else if (widget.index == 1) {
          setState(() {
            zikrArabic = widget.zikrNames[1];
            zikrUzbek = 'Allohga hamd bo’lsin';
          });
        } else if (widget.index == 2) {
          setState(() {
             zikrArabic = widget.zikrNames[2];
            zikrUzbek = 'Alloh Buyukdir';
          });
        } else if (widget.index == 3) {
          setState(() {
            zikrArabic = widget.zikrNames[3];
            zikrUzbek = 'Allohdan o‘zga iloh yo‘q';
          });
        } else if (widget.index == 4) {
          setState(() {
             zikrArabic = widget.zikrNames[4];
            zikrUzbek = 'Alloh kechirsin';
          });
        } else if (widget.index == 5) {
          setState(() {
            zikrArabic = widget.zikrNames[5];
            zikrUzbek = 'Ey Alloh Muhammadga rahmat yog’dir';
          });
      
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimatedNeumorphism(
                zikrAr: zikrArabic,
                zikrUz: zikrUzbek,
              ),
            ));
      },
      style: NeumorphicStyle(
        color: iconsColor(context),
        depth: NeumorphicTheme.of(context)!.themeMode == ThemeMode.dark
            ? 0.5
            : 4.5,
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: FittedBox(
          child: Text(widget.zikrNames[widget.index],
              textAlign: TextAlign.center,
              style: TextStyle(
                      fontFamily: GoogleFonts.mPlus1().fontFamily,
                      fontSize: 18,
                      // ignore: unrelated_type_equality_checks
                      color: NeumorphicTheme.of(context)!.themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    )
          ),
        ),
      ),
    );
  }
}
