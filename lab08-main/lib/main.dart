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

  Duration duration = Duration.zero;

  Duration position = Duration.zero;

  double minValue = 0;
  double maxValue = 60;

  @override
  void initState() {
    super.initState();

    setAudio();
    audioPlayer.onPlayerStateChanged.listen((State) {
      setState(() {
        isplaying = State == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((newPostion) {
      setState(() {
        position = newPostion;
      });
    });
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);

    // String URL =
    //     "https://playfined";
    final player = AudioCache(prefix: 'assets/');
    final url = await player.load("Song2.mp3");
    audioPlayer.setUrl(url.path, isLocal: true);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  // var audio = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(2, 5, 6, 3),
            title: Text("Music"),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
          ),
          drawer: Drawer(
            backgroundColor: Color.fromARGB(255, 180, 183, 186),
          ),
          body: PageView(
            onPageChanged: (value) {
              audioPlayer.stop();
              minValue = 0;
              position = Duration.zero;
              // duration = audioPlayer.getDuration() as Duration;
              audioPlayer.seek(Duration.zero);
              maxValue = duration.inSeconds as double;
            },
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "https://th.bing.com/th/id/R.5ba6305ac7882af973e81b6556ad56eb?rik=i6TxTrzaK1TCaQ&pid=ImgRaw&r=0",
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Wish You Here💕 ",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Avaril Lavigne",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  MySlider(
                      minValue: minValue,
                      maxValue: maxValue,
                      position: position,
                      audioPlayer: audioPlayer),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${position.inMinutes}:${position.inSeconds % 60}"),
                        Text(
                            "${(duration - position).inMinutes}:${(duration - position).inSeconds % 60}"),
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
                          // await audioplayer.pause;
                        } else {
                          audioPlayer.resume();

                          // audioplayer.play(URL);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "https://th.bing.com/th/id/R.5ba6305ac7882af973e81b6556ad56eb?rik=i6TxTrzaK1TCaQ&pid=ImgRaw&r=0",
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Wish You Here💕 ",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Avaril Lavigne",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  MySlider(
                      minValue: minValue,
                      maxValue: maxValue,
                      position: position,
                      audioPlayer: audioPlayer),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${position.inMinutes}:${position.inSeconds % 60}"),
                        Text(
                            "${(duration - position).inMinutes}:${(duration - position).inSeconds % 60}"),
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
                          // await audioplayer.pause;
                        } else {
                          audioPlayer.resume();

                          // audioplayer.play(URL);
                        }
                      },
                    ),
                  ),
                ],
              ),

              //diff song
            ],
          )),
    );
  }
}

class MySlider extends StatelessWidget {
  const MySlider({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.position,
    required this.audioPlayer,
  }) : super(key: key);

  final double minValue;
  final double maxValue;
  final Duration position;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: minValue,
      max: maxValue,
      value: position.inSeconds.toDouble(),
      onChanged: (value) async {
        final position = Duration(seconds: value.toInt());
        await audioPlayer.seek(position);
      },
    );
  }
}
