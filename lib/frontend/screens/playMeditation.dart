import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_color_generator/material_color_generator.dart';
import '../projectColors.dart';
import '../../main.dart';
import '/backend/services/db.dart';
import 'package:mobile_app/frontend/screens/newMyMood.dart';

class PlayMeditation extends StatelessWidget {
  const PlayMeditation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: Color(0xFFFFFFFF)),
      ),
      home: PlayMeditationPage(),
    );
  }
}

class PlayMeditationPage extends StatefulWidget {
  const PlayMeditationPage({Key? key}) : super(key: key);

  static PageRouteBuilder getRoute() {
    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }, pageBuilder: (_, __, ___) {
      return PlayMeditationPage();
    });
  }

  @override
  _PlayMeditationPageState createState() => _PlayMeditationPageState();
}

class _PlayMeditationPageState extends State<PlayMeditationPage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    final player = AudioCache(prefix: 'assets/audio/');
    final url = await player.load('fire.mp3');
    await audioPlayer.setUrl(url.path, isLocal: true);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          elevation: 0,
          title: buildAppBarTitleMaditationPage(context),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(firstColor),
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      backgroundColor: Color(firstColor),
      body: buildBodyMainPage(context),
    );
  }

  buildAppBarTitleMaditationPage(BuildContext context) {
    return Text(
      'Медитация',
      style: TextStyle(
        fontSize: 22,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  buildBodyMainPage(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
        width: MediaQuery.of(context).size.width * 0.93,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
          width: MediaQuery.of(context).size.width,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(28),
            ),
            color: Color(0xFFeee8f4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'Дождь',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Color(0xFF2980B9),
                  border: Border.all(
                    width: 1,
                    color: Color(0xFF2980B9),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(23),
                  ),
                ),
                child: SvgPicture.asset("assets/images/rain.svg"),
              ),
              // Slider(
              //   value: 0,
              //   max: 100,
              //   divisions: 100,
              //   onChanged: (double value) {
              //     setState(() {
              //       _currentSliderValue = value;
              // })
              Text(
                "03:00",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff000000),
                ),
              ),
              CircleAvatar(
                radius: 35,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  iconSize: 50,
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
