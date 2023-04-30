import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/text_icon.dart';
import '../widgets/theme_changer.dart';
import '../widgets/zikr_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isArabicOrUzbek = false;
  final List<String> zikrNames = [
    'Subahanalloh',
    'Alhamdulillah',
    'Allohu Akbar',
    'La ilaha illalloh',
    "Astag'firulloh",
    'Allohumma solli ala\nMuhammad',
    'Boshqa zikr'
  ];

  final List<String> arabicZikrNames = [
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'اللَّهُ أَكْبَرُ',
    'لَا إِلَٰهَ إِلَّا اللَّهُ',
    'أَسْتَغْفِرُ اللَّهَ',
    'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ',
    'Boshqa zikr'
  ];
  void _saveLanguagePreference(bool isArabicOrUzbek) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isArabicOrUzbek', isArabicOrUzbek);
  }
    void _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isArabicOrUzbek = prefs.getBool('isArabicOrUzbek') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            const ThemeChanger(),
            Positioned(
              top: 0,
              left: 0,
              child: NeumorphicButton(
                onPressed: () {
                  setState(() {
                    isArabicOrUzbek = !isArabicOrUzbek;
                    _saveLanguagePreference(isArabicOrUzbek);
                  });
                },
                style: NeumorphicStyle(
                  color: NeumorphicTheme.isUsingDark(context)
                      ? Colors.black54
                      : Colors.white,
                  depth:
                      NeumorphicTheme.of(context)!.themeMode == ThemeMode.dark
                          ? 0.5
                          : 4.5,
                  shape: NeumorphicShape.concave,
                  boxShape: const NeumorphicBoxShape.circle(),
                ),
                padding: const EdgeInsets.all(12.5),
                margin: const EdgeInsets.all(15),
                child: Center(
                    child: Text(
                  isArabicOrUzbek ? 'Uz' : 'Ar',
                  style: TextStyle(
                      color: NeumorphicTheme.isUsingDark(context)
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                )),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextIcon(),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: zikrNames.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: SizedBox(
                          width: 800,
                          height: 400,
                          child: ZikrButtons(
                              index: index,
                              zikrNames: isArabicOrUzbek
                                  ? arabicZikrNames
                                  : zikrNames)),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color iconsColor(BuildContext context) {
  final theme = NeumorphicTheme.of(context);
  if (theme!.isUsingDark) {
    return Colors.black54;
  } else {
    return Colors.white;
  }
}

Color textColor(BuildContext context) {
  if (NeumorphicTheme.isUsingDark(context)) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
