import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
   await MobileAds.instance.initialize();
   RequestConfiguration requestConfiguration = RequestConfiguration();
   MobileAds.instance.updateRequestConfiguration(requestConfiguration);
      SharedPreferences prefs = await SharedPreferences.getInstance();
  ThemeMode initialMode = ThemeMode.values[prefs.getInt('theme_mode') ?? 0];


  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
   MyApp(initialMode: initialMode,)
  );
}

class MyApp extends StatelessWidget {
   final ThemeMode initialMode;

  const MyApp({super.key, this.initialMode = ThemeMode.light});

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Al Zikr',
      themeMode: initialMode,
      theme: const NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF), 
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme:const NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      home: const HomeScreen(),
    );
  }
}
