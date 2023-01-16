import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:map_app/GuidenceMarker.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BottomMarkerDetail extends StatelessWidget {
  GuidenceMarker? marker;
  BottomMarkerDetail({this.marker});
  TextToSpeech textToSpeech = TextToSpeech();
  bool isSpeaking = false;
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: marker!.youtubeId!,
        flags: YoutubePlayerFlags(autoPlay: false, mute: false));
    Size size = MediaQuery.of(context).size;
    print(marker!.youtubeId!);
    return Container(
      height: 400,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Image.network(
                    marker!.imageUrl!,
                    width: size.width,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    marker!.name!,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      child: SingleChildScrollView(
                        child: Text(
                          marker!.description!,
                          overflow: TextOverflow.fade,
                          //maxLines: 3,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 5,
            child: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 220, 220, 220),
              child: IconButton(
                  onPressed: () async {
                    if (isSpeaking) {
                      textToSpeech.stop();
                      isSpeaking = false;
                      return;
                    }
                    isSpeaking = true;
                    double volume = 1.0;
                    textToSpeech.setVolume(volume);
                    textToSpeech.speak(marker!.description!);
                  },
                  icon: Image.asset("assets/speaking.png")),
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 220, 220, 220),
              child: IconButton(
                  onPressed: () {
                    textToSpeech.stop();
                    Navigator.pop(context);
                  },
                  icon: Image.asset("assets/close.png")),
            ),
          ),
        ],
      ),
    );
  }
}
