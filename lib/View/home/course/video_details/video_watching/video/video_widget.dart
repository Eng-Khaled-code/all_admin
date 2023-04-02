import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:middleman_all/View/home/course/video_details/video_watching/video/animation_player/animation_player.dart';
import 'package:middleman_all/View/home/course/video_details/video_watching/video/web_video_control.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'controls.dart';
import 'landscape_player/landscape_player.dart';
class VideoWidget extends StatefulWidget {
  const VideoWidget({Key? key,this.videoPlayerController}) : super(key: key);
  final VideoPlayerController? videoPlayerController;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {

  final List<String> samples = [
    'Default player',
    'Animation player',
    'Custom orientation player',
   'Landscape player',
  ];

  int selectedIndex = 0;

  changeSample(int index) {


    if (index==3) {
      Get.to(LandscapePlayer(),);
    } else{
      setState(()=>selectedIndex = index);
    }
  }

  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(videoPlayerController:widget.videoPlayerController!);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: SizedBox(
        height: Get.height*0.4,
        child:kIsWeb?webVedio():_buildMobileView(),
      ),
    );
  }

  FlickVideoPlayer webVedio(){
    return  FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  controls: WebVideoControl(
                        iconSize: 30,
                        fontSize: 14,
                  progressBarSettings: FlickProgressBarSettings(
                        height: 5,
                        handleRadius: 5.5,
                  ),
                  ),
                  videoFit: BoxFit.contain,
                  // aspectRatioWhenLoading: 4 / 3,
              ),
  );
  }


  Widget _buildMobileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        selectedIndex== 0
            ?
        defaultVideo()
            :
        selectedIndex==1
            ?
        AnimationPlayer(flickManager: flickManager)
            :
        selectedIndex==2
            ?
        orientationPlayer()
            :
        Container(),
        Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: samples.asMap().keys.map((index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      changeSample(index);
                    },
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          samples[index],
                          style: TextStyle(
                            color: index == selectedIndex
                                ? const Color.fromRGBO(100, 109, 236, 1)
                                : const Color.fromRGBO(173, 176, 183, 1),
                            fontWeight:
                            index == selectedIndex ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),
      ],
    );
  }

  orientationPlayer(){
    return FlickVideoPlayer(
      flickManager: flickManager,
      preferredDeviceOrientationFullscreen:const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      flickVideoWithControls:const  FlickVideoWithControls(
        controls: CustomOrientationControls(),
      ),
      flickVideoWithControlsFullscreen: const FlickVideoWithControls(
        videoFit: BoxFit.fitWidth,
        controls: CustomOrientationControls(),
      ),
    );
  }

  defaultVideo() {
    return FlickVideoPlayer(
      flickManager: flickManager,
      flickVideoWithControls: const FlickVideoWithControls(
        closedCaptionTextStyle: TextStyle(fontSize: 8),
        controls: FlickPortraitControls(),
      ),
      flickVideoWithControlsFullscreen: const FlickVideoWithControls(
        controls: FlickLandscapeControls(),
      ),
    );
  }
}
