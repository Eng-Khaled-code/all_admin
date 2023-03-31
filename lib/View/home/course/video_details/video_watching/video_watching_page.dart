import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/question_model.dart';
import 'package:middleman_all/Models/courses/video_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'package:video_player/video_player.dart';

import 'add_question.dart';
import 'question_card.dart';
class VideoWatchingPage extends StatefulWidget {
  final VideoModel? model;
  final CoursesController? coursesController;


  VideoWatchingPage({Key? key, this.model,this.coursesController}) : super(key: key);

  @override
  State<VideoWatchingPage> createState() => _VideoWatchingPageState();
}

class _VideoWatchingPageState extends State<VideoWatchingPage> {

  VideoPlayerController? videoPlayerController;
  bool showVideoActions=true;
  IconData playPauseIcon=Icons.pause;
  IconData soundIcon=Icons.volume_up;
  IconData fullscreenIcon=CupertinoIcons.fullscreen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    videoPlayerController=VideoPlayerController.network(widget.model!.videoUrl!)..play()..initialize()
        .then((value) => setState((){}));
  }

  @override
  Widget build(BuildContext context) {


    widget.coursesController!.questionOperations(type: "load",videoId: widget.model!.id);

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton:_floatAB(),
          body:RefreshIndicator(
              onRefresh: ()async{
                await widget.coursesController!.questionOperations(type: "load",videoId: widget.model!.id);
              },
              child:SingleChildScrollView(
    physics:const AlwaysScrollableScrollPhysics(),

    child: Column(children: [
                  _videoWatchWidget(),
                  const SizedBox(height: 10),
                  CustomText(text: "  "+widget.model!.name!,fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black,alignment: Alignment.topRight,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(text: widget.model!.desc!,color: Colors.black,textAlign: TextAlign.start,maxLine: 10),
                  ),
                  const Divider(color: Colors.white,thickness: 5),
                  CustomText(text: "   الاسئلة",fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black,alignment: Alignment.topRight),
                  _dataWidget(),

                ],),
              )) ,
        ),
      ),
    );
  }

  Widget _dataWidget() {

    return Obx(
            ()=>widget.coursesController!.isQuestionLoading.value
            ?
        loadingWidget()
            :
        widget.coursesController!.questionList.isEmpty?noDataCard(text:  "لا توجد اسئلة",icon: Icons.question_mark):

        ListView.builder(
            padding: const EdgeInsets.only(bottom: 50),
            shrinkWrap: true,
            physics:const NeverScrollableScrollPhysics(),

    itemCount: widget.coursesController!.questionList.length,
            itemBuilder: (context,position){
              QuestionModel _model=QuestionModel.fromSnapshot(widget.coursesController!.questionList[position]);
              return QuestionCard(questionModel: _model,coursesController: widget.coursesController,);
            }

        ));
  }

  FloatingActionButton _floatAB() {
    return FloatingActionButton.extended(
        onPressed: (){
          videoPlayerController!.pause();
          Get.to(AddQuestion(videoId: widget.model!.id,coursesController: widget.coursesController,));
          },
        icon:const Icon(Icons.question_mark),label:const Text("إضافة سؤال"));
  }

  _videoWatchWidget() {
    return SizedBox(
        height: Get.height * .4,
        width: double.infinity,
        child:

        Stack(children:
        [

          VideoPlayer(videoPlayerController!),
           _loadWidget(),
         // Positioned(bottom: 0,child: Opacity(opacity: .5,child: Container(width: double.infinity,height: 70,color: Colors.black,),))

          _videoActionsWidget(),
          VideoProgressIndicator(videoPlayerController!, allowScrubbing: true,),

    ])


    ,

    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController!.dispose();
  }

 Widget _loadWidget() {
    return !videoPlayerController!.value.isInitialized
    ?
    const Center(child: CircularProgressIndicator(strokeWidth: .7,))
        :
    Container();
  }

 Widget _videoActionsWidget()
 {
   return Positioned(
       bottom:0,
       child: Row(mainAxisSize: MainAxisSize.min,
     mainAxisAlignment: MainAxisAlignment.spaceBetween
     ,children: [
     _playPauseButton(),
     Text(videoPlayerController!.value.position.inSeconds.toString()),
     _soundButton(),
     _fullScreenButton()
   ],),);

 }

  _playPauseButton(){
    return IconButton(onPressed: (){
      if(videoPlayerController!.value.isInitialized){

        if(playPauseIcon==Icons.pause)
      {
        playPauseIcon=Icons.play_arrow;
        videoPlayerController!.pause();

      }
      else{
          playPauseIcon=Icons.pause;
          videoPlayerController!.play();

      }

      setState(() {
      });
      }
    }, icon: Icon(playPauseIcon));
  }


  _soundButton(){
    return IconButton(onPressed: (){
      if(videoPlayerController!.value.isInitialized) {

        if(soundIcon == Icons.volume_up )
        {

          soundIcon = Icons.volume_off;
          videoPlayerController
            !.setVolume(0);
        }
        else
        {
          soundIcon= Icons.volume_up;
          videoPlayerController
          !.setVolume(100);
        }
      setState(() {
      });
    }
    },
        icon: Icon(soundIcon));
  }


  _fullScreenButton(){
    return IconButton(onPressed: (){
      if(videoPlayerController!.value.isInitialized) {

        if(fullscreenIcon == CupertinoIcons.fullscreen )
        {

          fullscreenIcon = CupertinoIcons.fullscreen_exit;

      }
      else
      {
           fullscreenIcon= CupertinoIcons.fullscreen;
}
      setState(() {
      });
    }
    },
        icon: Icon(fullscreenIcon));
  }

}
