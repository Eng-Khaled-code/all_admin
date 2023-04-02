import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class AddVideo extends StatefulWidget {
   final int? videoId;
   String? name;
   String? videoUrl;
   String? videoDesc;
   final int? secId;
   final String? opeType;
   final int? courseId;
   final CoursesController? coursesController;
   AddVideo({Key? key,this.courseId=0,this.coursesController,this.videoUrl,this.videoId=0,this.secId=0,this.name="",this.videoDesc="" ,this.opeType="add"}) :super(key: key);

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  final _formKey = GlobalKey<FormState>();
  File? _videoFile;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.opeType=="update"){
      _videoPlayerController=VideoPlayerController.network(widget.videoUrl!)..initialize().then((d){setState(() {

      });});
    }
  }
  @override
  Widget build(BuildContext context) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar:customAppbar(title:widget.opeType=="add"?"إضافة فيديو":"تعديل الفيديو",actions: Container()),
      body: Obx(() =>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child:
              widget.coursesController!.isVideoLoading.value
                  ?
              loadingWidget()
                  :
              SingleChildScrollView(
                child: Column(
                  children: [

                    _courseVideo(),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      initialValue: widget.name,
                      lable: "عنوان الفيديو",
                      onSave: (value){
                        widget.name=value;
                      },),
                    const SizedBox(height: 10.0),

                    CustomTextField(
                      initialValue: widget.videoDesc,
                      lable: "الشرح",
                      onSave: (value){
                        widget.videoDesc=value;
                      },),
                    const SizedBox(height: 25.0),
                    _addButton(),
                  ],
                ),
              ),


            ),
          ),
      ),
            ),

  );
  }

  CustomButton _addButton() {
    return CustomButton(
        color: const[
          primaryColor,
          Color(0xFF0D47A1),
        ],
        text:widget.opeType=="add"? "إضافة":"تعديل",
        onPress: () async{
          _formKey.currentState!.save();

          if(_formKey.currentState!.validate()){
            if(_videoFile==null&&widget.videoUrl==""){
              Fluttertoast.showToast(msg: "يجب ان تختار فيديو");
          }else{
             await widget.coursesController!.videoOperations(type:widget.opeType,
            name: widget.name,courseId: widget.courseId,desc: widget.videoDesc,video: _videoFile,secId: widget.secId,videoId: widget.videoId,vNameForDelOrUp:widget.videoUrl==null?"": widget.videoUrl!.split("/").last);}
          }
        },
        textColor: Colors.white);
  }

  _courseVideo(){

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
          height: MediaQuery.of(Get.context!).size.height * 0.3,
          width: double.infinity,
          child:
          _videoFile != null
              ?
          InkWell(
              onTap: ()=>getVideoFile(onVideoSelected: (File file){
                if(_videoPlayerController!=null)
              {
                _videoPlayerController!.dispose();
              }
                _videoFile=file;

                _videoPlayerController=VideoPlayerController.file(_videoFile!)..initialize().then((d){setState(() {});});
              }),
              child:
              VideoPlayer(_videoPlayerController!))

              :
          widget.videoUrl != null
          ?
          InkWell(
              onTap: ()=>getVideoFile(onVideoSelected: (File file){
                if(_videoPlayerController!=null)
                {
                  _videoPlayerController!.dispose();
                }
                _videoFile=file;

              _videoPlayerController=VideoPlayerController.file(_videoFile!)..initialize().then((d){setState(() {});});

              }),
              child:
              VideoPlayer(_videoPlayerController!))

              :
          Padding(
              padding:const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: ()=>getVideoFile(onVideoSelected: (File file)
                {
                  _videoFile=file;

                  _videoPlayerController=VideoPlayerController.file(_videoFile!)..initialize().then((d){setState(() {

                  });});
                }),
                style:OutlinedButton.styleFrom(side: BorderSide(
                    color: Colors.grey.withOpacity(0.5), width: 1)),
                child: Icon(Icons.video_call,
                    size: 80, color: Colors.grey.withOpacity(.5)),
              )))

    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoFile=null;
    _videoPlayerController!.dispose();
  }
}