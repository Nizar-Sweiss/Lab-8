// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final audioPlayer = AudioPlayer();
  bool isplaying = false;
  Duration sliderDuration = Duration.zero;
  Duration sliderPosition = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio(songName: "Song2.mp3");

    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isplaying = event == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        sliderDuration = newDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((newPostion) {
      setState(() {
        sliderPosition = newPostion;
      });
    });
  }

  Future setAudio({required String songName}) async {
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    final player = AudioCache(prefix: 'assets/');
    final url = await player.load(songName);
    audioPlayer.setUrl(url.path, isLocal: true);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color homeBackgroundColor = Color.fromARGB(130, 180, 183, 186);
    String imgNetworkURL =
        "https://th.bing.com/th/id/OIP.EzvVcoFwoLgsrEE8jx1a_AHaHa?pid=ImgDet&rs=1";

    String musicTitle = "Music Title";
    String musicSubTitle = "Music SubTitle";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          // To be UnCommment after development, at deployment time. Or when ever AppBar is going to be use.
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(2, 5, 6, 3),
            title: Text("Music"),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
          ),
          drawer: Drawer(
            backgroundColor: homeBackgroundColor,
          ),
          body: Container(
            color: homeBackgroundColor,
            child: PageView(
              onPageChanged: (value) {
                audioPlayer.stop();
                sliderPosition = Duration.zero;
                audioPlayer.seek(Duration.zero);
              },
              children: [
                MusicAlbom(
                    imgNetworkURL:
                        "https://th.bing.com/th/id/R.5ba6305ac7882af973e81b6556ad56eb?rik=i6TxTrzaK1TCaQ&pid=ImgRaw&r=0",
                    musicTitle: "Wish You Here💕",
                    musicSubTitle: "Avaril Lavigne",
                    position: sliderPosition,
                    audioPlayer: audioPlayer,
                    duration: sliderDuration,
                    isplaying: isplaying),
                MusicAlbom(
                    imgNetworkURL: imgNetworkURL,
                    musicTitle: musicTitle,
                    musicSubTitle: musicSubTitle,
                    position: sliderPosition,
                    audioPlayer: audioPlayer,
                    duration: sliderDuration,
                    isplaying: isplaying),

                //diff song
              ],
            ),
          )),
    );
  }
}

class MusicAlbom extends StatelessWidget {
  const MusicAlbom({
    Key? key,
    required this.imgNetworkURL,
    required this.musicTitle,
    required this.musicSubTitle,
    required this.position,
    required this.audioPlayer,
    required this.duration,
    required this.isplaying,
  }) : super(key: key);

  final String imgNetworkURL;
  final String musicTitle;
  final String musicSubTitle;
  final Duration position;
  final AudioPlayer audioPlayer;
  final Duration duration;
  final bool isplaying;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            imgNetworkURL,
            width: double.infinity,
            height: 350,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          musicTitle,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        SizedBox(height: 4),
        Text(
          musicSubTitle,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        MySlider(
          maxValue: duration.inSeconds + 0, // Works, to convert int to Double
          // maxValue: duration.inSeconds as Double, // does NOT Work, to convert int to Double
          position: position,
          audioPlayer: audioPlayer,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getMusicPositionForSlider(position)),
              Text(getMusicDurationLeftForSlider(position, duration)),
            ],
          ),
        ),
        CircleAvatar(
          radius: 35,
          child: IconButton(
            icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
            iconSize: 50,
            onPressed: () async {
              if (isplaying) {
                audioPlayer.pause();
              } else {
                audioPlayer.resume();
              }
            },
          ),
        ),
      ],
    );
  }
}

class MySlider extends StatelessWidget {
  const MySlider({
    Key? key,
    required this.maxValue,
    required this.position,
    required this.audioPlayer,
  }) : super(key: key);

  final double maxValue;
  final Duration position;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    double sliderDuration = maxValue;
    print("sliderDuration = $sliderDuration");
    print("position = ${position.inSeconds.toDouble()}");
    return Slider(
      max: sliderDuration,
      value: position.inSeconds.toDouble(),
      onChanged: (value) async {
        final position = Duration(seconds: value.toInt());
        await audioPlayer.seek(position);
      },
    );
  }
}

String getMusicPositionForSlider(Duration position) {
  String timeLeft = "${position.inMinutes}:${position.inSeconds % 60}";
  return timeLeft;
}

String getMusicDurationLeftForSlider(Duration position, Duration duration) {
  String timeLeft =
      "${(duration - position).inMinutes}:${(duration - position).inSeconds % 60}";
  return timeLeft;
}
