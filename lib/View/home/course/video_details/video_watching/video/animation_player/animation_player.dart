
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:middleman_all/View/home/course/video_details/video_watching/video/animation_player/portrait_video_controls.dart';
import 'landscape_controls.dart';

class AnimationPlayer extends StatefulWidget {
  const AnimationPlayer({Key? key,this.flickManager}) : super(key: key);
  final  FlickManager? flickManager;
  @override
  _AnimationPlayerState createState() => _AnimationPlayerState();
}

class _AnimationPlayerState extends State<AnimationPlayer> {


  bool _pauseOnTap = true;
  double playBackSpeed = 1.0;

  @override
  void dispose() {
    widget.flickManager!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Expanded(
            child: FlickVideoPlayer(
              flickManager: widget.flickManager!,
              flickVideoWithControls: AnimationPlayerPortraitVideoControls(pauseOnTap: _pauseOnTap),
              flickVideoWithControlsFullscreen:const FlickVideoWithControls(
                controls: AnimationPlayerLandscapeControls(),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
             const Text('On tap action -- '),
              Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _pauseOnTap = true;
                        });
                      },
                      child:const Text('Pause')),
                  Switch(
                    value: !_pauseOnTap,
                    onChanged: (value) {
                      setState(() {
                        _pauseOnTap = !value;
                      });
                    },
                    activeColor: Colors.red,
                    inactiveThumbColor: Colors.blue,
                    inactiveTrackColor: Colors.blue[200],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pauseOnTap = false;
                      });
                    },
                    child:const Text(
                      'Mute',
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
             const Text('Playback speed -- '),
              Row(
                children: [
                  Slider(
                    value: playBackSpeed,
                    onChanged: (val) {},
                    onChangeEnd: (val) {
                      widget.flickManager!.flickVideoManager?.videoPlayerController!
                          .setPlaybackSpeed(val);
                      setState(() {
                        playBackSpeed = val;
                      });
                    },
                    min: 0.25,
                    max: 2,
                  ),
                  Text(playBackSpeed.toStringAsFixed(2).toString()),
                ],
              )
            ],
          ),
        ],
    );
  }
}
