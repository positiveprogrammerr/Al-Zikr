import 'dart:async';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class AnimatedNeumorphism extends StatefulWidget {
  final String zikrAr;
  final String zikrUz;
  const AnimatedNeumorphism(
      {Key? key, required this.zikrAr, required this.zikrUz})
      : super(key: key);

  @override
  State<AnimatedNeumorphism> createState() => _AnimatedNeumorphismState();
}

class _AnimatedNeumorphismState extends State<AnimatedNeumorphism> {
  AudioPlayer? _player;
  var adunit = 'ca-app-pub-1691688435320423/2705675841';

  bool isVibrationOn = false;
  bool isSoundOn = false;
  int count = 0;
  double turns = 0.0;
  bool isClicked = false;
  int _maxCount = 0;

  @override
  void initState() {
    super.initState();
    initBannerAd();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isSoundOn = prefs.getBool('isSoundOn') ?? true;
      });
    });
    _player = AudioPlayer();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isSoundOn = prefs.getBool('isSoundOn') ?? false;
      });
    });
  }

  Future<void> _playTasbehSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (!isSoundOn) {
        await _player!.setAsset('assets/s.mp3');
        await _player!.setSpeed(4.6);
        await _player!.play();
      } else {
        await _player!.stop();
      }
      // Update the value of isSoundOn in state and save to shared preferences
    } catch (e) {
      print('Error playing tasbeh sound: $e');
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  late BannerAd bannerAd;
  bool isAdLoaded = false;

  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adunit,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        }),
        request: const AdRequest());

    bannerAd.load();
  }

  void _resetCount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: NeumorphicTheme.isUsingDark(context)
              ? Colors.black
              : Colors.white,
          title: Text(
            'Hisob qayta tiklansinmi?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: NeumorphicTheme.isUsingDark(context)
                  ? Colors.white
                  : Colors.black,
              fontFamily: GoogleFonts.mPlus1().fontFamily,
            ),
          ),
          content: Text(
            'Hisobni qayta tiklamoqchimisiz?',
            style: TextStyle(
              color: NeumorphicTheme.isUsingDark(context)
                  ? Colors.white
                  : Colors.black,
              fontFamily: GoogleFonts.mPlus1().fontFamily,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      color: NeumorphicTheme.isUsingDark(context)
                          ? Colors.black
                          : Colors.white,
                      depth: NeumorphicTheme.isUsingDark(context) ? 0 : 5.2,
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(15)),
                    ),
                    child: NeumorphicButton(
                      child: Text(
                        'Bekor qilish',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.mPlus1().fontFamily,
                            color: NeumorphicTheme.isUsingDark(context)
                                ? Colors.white
                                : Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Neumorphic(
                    style: NeumorphicStyle(
                      color: NeumorphicTheme.isUsingDark(context)
                          ? Colors.black
                          : Colors.white,
                      depth: NeumorphicTheme.isUsingDark(context) ? 0 : 5.2,
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(15)),
                    ),
                    child: NeumorphicButton(
                      child: Text(
                        'Tiklash',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.mPlus1().fontFamily,
                            color: NeumorphicTheme.isUsingDark(context)
                                ? Colors.white
                                : Colors.black),
                      ),
                      onPressed: () {
                        setState(() {
                          count = 0;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> toggleSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool newIsSoundOn = !isSoundOn;
    await prefs.setBool('isSoundOn', newIsSoundOn);
    setState(() {
      isSoundOn = newIsSoundOn;
    });
  }

  void vibrate() {
    if (isVibrationOn) {
      Vibration.vibrate(duration: 50);
    }
  }

  void vibrate2() {
    Vibration.vibrate(duration: 800);
  }

  void _increment() {
    setState(() {
      if (_maxCount > 0) {
        if (count < _maxCount) {
          _playTasbehSound();
          count++;
          vibrate(); // <-- Add this line to play the vibration feedback
        } else {
          count = _maxCount;
          vibrate2(); // <-- Add this line to play the vibration feedback
        }
      } else {
        _playTasbehSound();
        count++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool containsArabic = RegExp(r'[\u0600-\u06FF]+').hasMatch(widget.zikrAr);
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.all(size.width * 0.02),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: NeumorphicStyle(
                        depth: NeumorphicTheme.isUsingDark(context) ? 0 : 5.2,
                        shape: NeumorphicShape.concave,
                        color: NeumorphicTheme.isUsingDark(context)
                            ? Colors.black54
                            : Colors.white,
                        boxShape: const NeumorphicBoxShape.circle(),
                      ),
                      child: Icon(
                        Icons.home,
                        color: NeumorphicTheme.isUsingDark(context)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.06,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.all(size.width * 0.01),
                      onPressed: () {
                        setState(() {
                          isVibrationOn = !isVibrationOn;
                        });
                      },
                      style: NeumorphicStyle(
                        depth: NeumorphicTheme.isUsingDark(context) ? 0 : 5.2,
                        shape: NeumorphicShape.concave,
                        color: NeumorphicTheme.isUsingDark(context)
                            ? Colors.black54
                            : Colors.white,
                        boxShape: const NeumorphicBoxShape.circle(),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: size.width * 0.02),
                        child: Visibility(
                          visible: isVibrationOn,
                          replacement: SvgPicture.asset(
                            'assets/vib_off.svg',
                            color: NeumorphicTheme.isUsingDark(context)
                                ? Colors.white
                                : Colors.black,
                            width: size.width * 0.082,
                            height: size.width * 0.082,
                          ),
                          child: SvgPicture.asset(
                            'assets/vib.svg',
                            color: NeumorphicTheme.isUsingDark(context)
                                ? Colors.white
                                : Colors.black,
                            width: size.width * 0.082,
                            height: size.width * 0.082,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.06,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.all(size.width * 0.02),
                      onPressed: toggleSound,
                      style: NeumorphicStyle(
                        depth: NeumorphicTheme.isUsingDark(context) ? 0 : 5.2,
                        shape: NeumorphicShape.concave,
                        color: NeumorphicTheme.isUsingDark(context)
                            ? Colors.black54
                            : Colors.white,
                        boxShape: const NeumorphicBoxShape.circle(),
                      ),
                      child: Center(
                        child: isSoundOn
                            ? Icon(
                                Icons.volume_off_rounded,
                                color: NeumorphicTheme.isUsingDark(context)
                                    ? Colors.white
                                    : Colors.black,
                              )
                            : Icon(
                                Icons.volume_up_rounded,
                                color: NeumorphicTheme.isUsingDark(context)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.04,
                    ),
                    NeumorphicButton(
                      onPressed: () {
                        setState(() {
                          if (_maxCount == 100) {
                            _maxCount = 0;
                          } else {
                            _maxCount = 100;
                          }
                        });
                      },
                      style: NeumorphicStyle(
                        depth: _maxCount == 100
                            ? NeumorphicTheme.isUsingDark(context)
                                ? 3
                                : 1
                            : NeumorphicTheme.isUsingDark(context)
                                ? 0
                                : 5.2,
                        shape: _maxCount == 100
                            ? NeumorphicShape.concave
                            : NeumorphicShape.concave,
                        color: NeumorphicTheme.isUsingDark(context)
                            ? Colors.black54
                            : Colors.white,
                        boxShape: const NeumorphicBoxShape.circle(),
                      ),
                      child: Center(
                        child: NeumorphicText(
                          "100",
                          style: NeumorphicStyle(
                            depth:
                                NeumorphicTheme.isUsingDark(context) ? 0 : 5.2,
                            color: _textColor(context),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    NeumorphicButton(
                      onPressed: () {
                        setState(() {
                          if (_maxCount == 33) {
                            _maxCount = 0;
                          } else {
                            _maxCount = 33;
                          }
                        });
                      },
                      style: NeumorphicStyle(
                        depth: _maxCount == 33
                            ? NeumorphicTheme.isUsingDark(context)
                                ? 3
                                : 1
                            : NeumorphicTheme.isUsingDark(context)
                                ? 0
                                : 5.2,
                        shape: _maxCount == 33
                            ? NeumorphicShape.concave
                            : NeumorphicShape.concave,
                        color: NeumorphicTheme.isUsingDark(context)
                            ? Colors.black54
                            : Colors.white,
                        boxShape: const NeumorphicBoxShape.circle(),
                      ),
                      child: Center(
                        child: NeumorphicText(
                          "33",
                          style: NeumorphicStyle(
                            depth:
                                NeumorphicTheme.isUsingDark(context) ? 0 : 5.2,
                            color: _textColor(context),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.all(size.width * 0.02),
                      onPressed: _resetCount,
                      style: NeumorphicStyle(
                        depth: NeumorphicTheme.isUsingDark(context) ? 0 : 5.2,
                        shape: NeumorphicShape.concave,
                        color: NeumorphicTheme.isUsingDark(context)
                            ? Colors.black54
                            : Colors.white,
                        boxShape: const NeumorphicBoxShape.circle(),
                      ),
                      child: Icon(
                        Icons.restart_alt_rounded,
                        color: NeumorphicTheme.isUsingDark(context)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.001,
                    ),
                  ]),
                ),
              ],
            ),
        widget.zikrAr.isEmpty||widget.zikrUz.isEmpty?     Container(margin: const EdgeInsets.only(bottom: 60),
          child: Center(
            child: FittedBox(
              child: Column(
                children: [
                  !containsArabic
                      ? NeumorphicText(
                        widget.zikrAr=='Allohumma solli ala\nMuhammad'?'Allohumma solli ala Muhammad':widget.zikrAr.toString(),
                          textStyle: NeumorphicTextStyle(
                              fontSize: 26, fontWeight: FontWeight.w500),
                          style: NeumorphicStyle(
                            depth: 0,
                            color: _textColor(context),
                          ),
                        )
                      : NeumorphicText(
                          widget.zikrAr.toString(),
                          textStyle: NeumorphicTextStyle(
                              fontSize: 33, fontWeight: FontWeight.w700),
                          style: NeumorphicStyle(
                            depth: 0,
                            color: _textColor(context),
                          ),
                        ),
                  NeumorphicText(
                    widget.zikrUz.toString(),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 19,
                      fontFamily: GoogleFonts.mPlus1().fontFamily,
                    ),
                    style: NeumorphicStyle(
                      depth: 0,
                      color: _textColor(context),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  NeumorphicButton(
                    margin: const EdgeInsets.only(top: 12),
                    onPressed: () {
                      _increment();
                      vibrate();
                    },
                    style: NeumorphicStyle(
                      color: NeumorphicTheme.isUsingDark(context)
                          ? Colors.black54
                          : Colors.white,
                      depth: NeumorphicTheme.of(context)!.themeMode ==
                              ThemeMode.dark
                          ? 0.5
                          : 7,
                      shape: NeumorphicShape.concave,
                      boxShape: const NeumorphicBoxShape.circle(),
                    ),
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: NeumorphicText(
                            "$count",
                            style: NeumorphicStyle(
                              depth: 0,
                              color: _textColor(context),
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontSize: 90,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ): Center(
              child: FittedBox(
                child: Column(
                  children: [
                    !containsArabic
                        ? NeumorphicText(
                          widget.zikrAr=='Allohumma solli ala\nMuhammad'?'Allohumma solli ala Muhammad':widget.zikrAr.toString(),
                            textStyle: NeumorphicTextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500),
                            style: NeumorphicStyle(
                              depth: 0,
                              color: _textColor(context),
                            ),
                          )
                        : NeumorphicText(
                            widget.zikrAr.toString(),
                            textStyle: NeumorphicTextStyle(
                                fontSize: 33, fontWeight: FontWeight.w700),
                            style: NeumorphicStyle(
                              depth: 0,
                              color: _textColor(context),
                            ),
                          ),
                    NeumorphicText(
                      widget.zikrUz.toString(),
                      textStyle: NeumorphicTextStyle(
                        fontSize: 19,
                        fontFamily: GoogleFonts.mPlus1().fontFamily,
                      ),
                      style: NeumorphicStyle(
                        depth: 0,
                        color: _textColor(context),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    NeumorphicButton(
                      margin: const EdgeInsets.only(top: 12),
                      onPressed: () {
                        _increment();
                        vibrate();
                      },
                      style: NeumorphicStyle(
                        color: NeumorphicTheme.isUsingDark(context)
                            ? Colors.black54
                            : Colors.white,
                        depth: NeumorphicTheme.of(context)!.themeMode ==
                                ThemeMode.dark
                            ? 0.5
                            : 7,
                        shape: NeumorphicShape.concave,
                        boxShape: const NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: NeumorphicText(
                              "$count",
                              style: NeumorphicStyle(
                                depth: 0,
                                color: _textColor(context),
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontSize: 90,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: double.infinity,
              child: AdWidget(ad: bannerAd),
            )
          : const SizedBox(),
    );
  }
}

Color? _iconsColor(BuildContext context) {
  final theme = NeumorphicTheme.of(context);
  if (theme!.isUsingDark) {
    return theme.current!.accentColor;
  } else {
    return null;
  }
}

Color _textColor(BuildContext context) {
  if (NeumorphicTheme.isUsingDark(context)) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
