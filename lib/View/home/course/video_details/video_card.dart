
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/video_model.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'package:video_player/video_player.dart';

import 'add_video.dart';
import 'video_watching/video_watching_page.dart';

class VideoCard extends StatefulWidget {
  final VideoModel ? model ;
  final CoursesController ? coursesController  ;
  final int? courseId;

  VideoCard({Key? key, this.model, this.coursesController,this.courseId=0})
      : super(key: key);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {

  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    videoPlayerController=VideoPlayerController.network(widget.model!.videoUrl!)..initialize().then((value) => setState((){}));
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(VideoWatchingPage(model: widget.model,coursesController:widget.coursesController));
      },
      child: Card(
        margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: _dataRowWidget()
        ),
      ),
    );
  }

  Row _dataRowWidget(){
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _videoImage(),
          const SizedBox(width: 5),
          _dataColumn()
        ]
    );
  }

  ClipRRect _videoImage() {
    return
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
    child:SizedBox(
        height: Get.height * .18,
        width: Get.width * .3,
        child:
        videoPlayerController!.value.isInitialized?
        VideoPlayer(videoPlayerController!)
              :
          const Center(child: CircularProgressIndicator(strokeWidth: .7,),)
    ,

      ));
  }

  Expanded _dataColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _videoTitle(),
          _videoDescription(),
          _dateWidget(),
          _operationsWidget(),

        ]
      ),
    );
  }

  _operationsWidget(){
    return operationRow(() =>_onPressUpdate(), ()=>_onPressDelete(), true);
  }

  Directionality _dateWidget() {
    String date = widget.model
    !.createdAt!;
    return Directionality(
    textDirection: TextDirection.ltr,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    CustomText(text: "  الساعة =>  "+date.substring(date.length-8,date.length-3),maxLine: 1,color: Colors.black,fontSize: 12,),
    CustomText(text: date.substring(0,date.length-8),maxLine: 1,color: Colors.black,fontSize: 12,),

    ]
    ,
    )
    ,
    );
  }

  CustomText _videoTitle() {
    return CustomText(
      text: widget.model!.name!, color: Colors.black, fontWeight: FontWeight.bold,
      maxLine: 1, textAlign: TextAlign.right, alignment: Alignment.topRight,);
  }

  Text _videoDescription() {
    return Text(widget.model!.desc!, maxLines: 2,
      textAlign: TextAlign.start,
      style: const TextStyle(overflow: TextOverflow.ellipsis),);
  }

  _onPressDelete()async{
Get.back();
await widget.coursesController!.videoOperations(
  videoId: widget.model!.id,
  type: "delete",
    vNameForDelOrUp:widget.model!.videoUrl!.split("/").last,
    courseId: widget.courseId,
    secId: widget.model!.secId
  );
}

  _onPressUpdate() {
    Get.to(AddVideo(coursesController:widget.coursesController,opeType: "update",courseId:widget.courseId ,secId: widget.model!.secId,videoDesc: widget.model!.desc,videoId: widget.model!.id,videoUrl: widget.model!.videoUrl,name: widget.model!.name,));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController!.dispose();
  }
}