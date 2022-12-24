import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:mobile_app/backend/models/MeditationModel.dart';
import '../projectColors.dart';
import '../../main.dart';
import '/backend/services/db.dart';
import 'package:mobile_app/frontend/screens/newMyMood.dart';

class PlayMeditation extends StatelessWidget {
  int minutes;
  int seconds;
  MeditationModel data;
  PlayMeditation(int this.minutes, int this.seconds, MeditationModel this.data,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: Color(0xFFFFFFFF)),
      ),
      home: PlayMeditationPage(minutes, seconds, data),
    );
  }
}

class PlayMeditationPage extends StatefulWidget {
  int minutes;
  int seconds;
  MeditationModel data;
  PlayMeditationPage(
      int this.minutes, int this.seconds, MeditationModel this.data,
      {super.key});

  static PageRouteBuilder getRoute(
      int minutes, int seconds, MeditationModel data) {
    minutes = minutes;
    seconds = seconds;
    data = data;
    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }, pageBuilder: (_, __, ___) {
      return PlayMeditationPage(minutes, seconds, data);
    });
  }

  @override
  _PlayMeditationPageState createState() =>
      _PlayMeditationPageState(minutes, seconds, data);
}

class _PlayMeditationPageState extends State<PlayMeditationPage> {
  int minutes;
  int seconds;
  MeditationModel data;
  _PlayMeditationPageState(
      int this.minutes, int this.seconds, MeditationModel this.data);
  final audioPlayer = AudioPlayer();
  bool isPlaying = true;
  double _currentSliderValue = 50;
  Timer? timer;

  void _startCountDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if ((seconds > 0 && minutes >= 0) || (seconds >= 0 && minutes > 0)) {
          if (seconds > 0) {
            seconds--;
          } else {
            minutes--;
            seconds = 59;
          }
        } else {
          _stopTimer();
          audioPlayer.stop();
          Navigator.pop(context);
        }
      });
    });
  }

  void _stopTimer() {
    timer?.cancel();
  }

  @override
  void initState() {
    super.initState();

    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    final player = AudioCache(prefix: 'assets/audio/');
    final url = await player.load(data.path_sound);
    await audioPlayer.setVolume(_currentSliderValue / 100);
    await audioPlayer.setUrl(url.path, isLocal: true);
    await audioPlayer.resume();
    _startCountDown();
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
                  data.title,
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
                child: SvgPicture.asset(data.path_icon),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Slider(
                  activeColor: Color(0xff6750a4),
                  inactiveColor: Color(0xffE7E0EC),
                  value: _currentSliderValue,
                  max: 100,
                  divisions: 100,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                      audioPlayer.setVolume(value / 100);
                    });
                  },
                ),
              ),
              Text(
                "${minutes >= 10 ? minutes.toString() : "0" + minutes.toString()}:${seconds >= 10 ? seconds.toString() : "0" + seconds.toString()}",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff000000),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff6750a4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow,
                    size: MediaQuery.of(context).size.width * 0.16,
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                    _stopTimer();
                  } else {
                    await audioPlayer.resume();
                    _startCountDown();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
