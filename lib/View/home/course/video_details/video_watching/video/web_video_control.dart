import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:provider/provider.dart';


/// Default portrait controls.
class WebVideoControl extends StatelessWidget {
  const WebVideoControl(
      {Key? key,
      this.iconSize = 20,
      this.fontSize = 12,
      this.progressBarSettings,})
      : super(key: key);

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// [dataManager] is used to handle video controls.
  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [FlickProgressBarSettings] settings.
  final FlickProgressBarSettings? progressBarSettings;

  @override
  Widget build(BuildContext context) {
    return FlickShowControlsActionWeb(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 20,),
              child: const FlickAnimatedVolumeLevel(
                decoration: BoxDecoration(
                  color: Colors.black26,
                ),
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
          Positioned.fill(
            child: FlickAutoHideChild(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlickVideoProgressBar(
                      flickProgressBarSettings: progressBarSettings,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlickPlayToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          FlickSoundToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          Row(
                            children: <Widget>[
                              FlickCurrentPosition(
                                fontSize: fontSize,
                              ),
                              FlickAutoHideChild(
                                child: Text(
                                  ' / ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: fontSize),
                                ),
                              ),
                              FlickTotalDuration(
                                fontSize: fontSize,
                              ),
                            ],
                          ),
                          Expanded(                            child: Container(),
                          ),
                          FlickFullScreenToggle(
                            size: iconSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
