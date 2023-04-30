import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger extends StatefulWidget {
  const ThemeChanger({super.key});

  @override
  State<ThemeChanger> createState() => _ThemeChangerState();
}

class _ThemeChangerState extends State<ThemeChanger> {

  void _toggleThemeMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // ignore: use_build_context_synchronously
  ThemeMode currentMode = NeumorphicTheme.of(context)!.themeMode;
  ThemeMode newMode =
      currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  await prefs.setInt('theme_mode', newMode.index);
  setState(() {
    NeumorphicTheme.of(context)!.themeMode = newMode;
  });
}
Future<void> theme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ThemeMode initialMode = ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
  setState(() {
    NeumorphicTheme.of(context)!.themeMode = initialMode;
  });
}

  @override
void initState() {
  super.initState();
  theme();
}


  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: NeumorphicButton(
      onPressed: () {
  _toggleThemeMode();
},
        style: NeumorphicStyle(
          color: NeumorphicTheme.isUsingDark(context)
              ? Colors.black54
              : Colors.white,
          depth: NeumorphicTheme.of(context)!.themeMode == ThemeMode.dark
              ? 0.5
              : 4.5,
          shape: NeumorphicShape.concave,
          boxShape: const NeumorphicBoxShape.circle(),
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(14),
        child: Center(
          child: NeumorphicTheme.of(context)!.themeMode == ThemeMode.dark
              ? const Icon(
                  Icons.light_mode_rounded,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.dark_mode_rounded,
                ),
        ),
      ),
    );
  }
}
