import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Services/main_operations.dart';
import 'package:middleman_all/View/home/course/add_course.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/start_point/app_constant.dart';

class CoursesController extends GetxController
{

  String url = appRootUrl+"courses/";
  RxBool isLoading = false.obs;
  RxBool isSectionLoading=false.obs;
  RxBool isVideoLoading=false.obs;
  RxBool isQuestionLoading=false.obs;

  late List courses=[];
  late List allcourses=[];
  late List coursesCategories=[];
  late List discountList=[];
  late List sectionsList=[];
  late List videoList=[];
  late List questionList=[];

  @override
  void onInit() {
    super.onInit();
    courseOperations(operationType: "load");
  }
  final MainOperation _mainOperation = MainOperation();

  courseOperations({String? price="0",String? operationType,int?id=0,String? name="",File? image,String? oldImageName="",String? desc="",int? categoryId=0,int? status=0})async{
    name=="dis_ope"?(){}:isLoading(true);

    String _imageName="", _base64image="";

    if(operationType=="add"||operationType=="update course image")
    {
    _imageName=image!.path.split("/").last;
    _base64image=base64Encode(image.readAsBytesSync());
    }
    else if(operationType=="delete"){
      _imageName=oldImageName!;
    }

    Map<String,String> _postData={"price":price!,"status":"$status","type":operationType!,
    "id":"$id","desc":desc!,"name":name!,"base64_image":_base64image,
    "old_image_name":oldImageName!,"image_name":_imageName,"user_id": "$globalUserId","category_id":"$categoryId"};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(_postData, url + "course_admin.php");
    if (resultMap["status"] == 1) {

    allcourses=[];
    coursesCategories=[];
    allcourses=resultMap['data'];
    coursesCategories=resultMap['courses_categories'];
    discountList=[];
    discountList=resultMap['discounts'];

    if(resultMap['courses_categories'].isNotEmpty){
      courseCategory=resultMap['courses_categories'][0]['name'];
      courseCategoryId=resultMap['courses_categories'][0]['id'].toString();
    }
    else
      {
      courseCategory=null;
      courseCategoryId=null;
      }
    coursesSearch(value:"");
    if(operationType!="load")
    {
    Get.back();
    Fluttertoast.showToast(msg:operationType=="add"?"تم اضافة الكورس بنجاح":operationType=="update course name"?"تم تعديل اسم الكورس بنجاح":operationType=="update course image"?"تم تعديل غلاف الكورس بنجاح":operationType=="update course status"?"تم تعديل حالة عرض الكورس بنجاح":operationType=="update course desc"?"تم تعديل شرح الكورس بنجاح":operationType=="delete"?"تم حذف الكورس بنجاح":"");
    }
    } else {
    print(resultMap["message"]);
    Get.snackbar("خطا",errorTranslation(resultMap["message"]));
    }
    name=="dis_ope"?(){}:isLoading(false);

  }

  void coursesSearch({String? value}){
    courses=[];
    for (var element in allcourses) {

      bool
      _searchValue=value==""?true:element['name'].contains(value);

      if(_searchValue)
      {
        courses.add(element);
      }

    }
  }

  Future<void> addOrUpdateDeleteCourseDiscount({
    String? type,
    int? discountId=0,
    int? courseId=0,

  }) async {

    isLoading(true);

    Map<String, String> postData =
    {
      "type": type!,
      "discount_id": "$discountId",
      "course_id": "$courseId",
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "discount_course.php");
    if (resultMap["status"] == 1) {
      await courseOperations(name: "dis_ope",operationType: "load");
      Fluttertoast.showToast(msg: "تم التنفيذ بنجاح");
    } else {

      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),toastLength: Toast.LENGTH_LONG,textColor: primaryColor,backgroundColor: Colors.white);

    }
    isLoading(false);
  }


  Future<void> discountOperations({String? type,int? disId=0,String? desc="",String? name="",String? percentage="",String? endIn="",int? status=0 }) async
  {

    isLoading(true);
    Map<String, String> postData = {
      "user_id": "$globalUserId",
      "percentage":percentage!,
      "status":"$status",
      "discount_id":"$disId",
      "name":name!,
      "desc":desc!,
      "end_in":endIn!,
      "type":type!,
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, appRootUrl + "ecommerce/discount.php");
    if (resultMap["status"] == 1) {
      discountList=resultMap['data'];
      type!="load"?Fluttertoast.showToast(msg:type=="add"?"تمت الإضافة بنجاح":type=="update"?"تم التعديل بنجاح":type=="delete"?"تم الحذف بنجاح":(status==1?"تم تفعيل العرض بالفعل":"تمإيقاف العرض بالفعل")):(){};

    } else {
      Get.snackbar("خطا",errorTranslation(resultMap["message"]));
    }
    isLoading(false);
  }


  Future<void> sectionOperations({String? type,int? secId=0,int? courseId=0,String? name="" }) async
  {

    isSectionLoading(true);
    Map<String, String> postData = {
      "sec_id":"$secId",
      "name":name!,
      "course_id":"$courseId",
      "type":type!,
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "section_ope.php");
    if (resultMap["status"] == 1) {
      type!="load"?Fluttertoast.showToast(msg:type=="add"?"تمت الإضافة بنجاح":type=="update"?"تم التعديل بنجاح":type=="delete"?"تم الحذف بنجاح":""):(){};

      sectionsList= resultMap['data'];
    } else {
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"]));
    }
    isSectionLoading(false);
  }


  Future<void> videoOperations({String? type,int? courseId=0,int? videoId=0,int? secId=0,String? name="" ,String? desc="",File? video,String? vNameForDelOrUp=""}) async
  {

    isVideoLoading(true);

    String _videoFileName="",_base64video="";
    if(type=="add"||(type=="update"&&!video.isNull))
    {
      _videoFileName=video!.path.split("/").last;
      _base64video=base64Encode(video.readAsBytesSync());

     }
    else if(type=="delete")
    {
     _videoFileName=vNameForDelOrUp!;
     }

    Map<String, String> postData = {
      "sec_id":"$secId",
      "name":name!,
      "id":"$videoId",
      "type":type!,
      "desc":desc!,
      "video_file_name":type=="update"&&video.isNull?vNameForDelOrUp!:_videoFileName,
      "base64video":_base64video,
      "old_video_file_name":type=="update"&&video.isNull?"no":vNameForDelOrUp!,
      "course_id":"$courseId"
  };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "video_ope.php");
    if (resultMap["status"] == 1) {
      type!="load"?Fluttertoast.showToast(msg:type=="add"?"تمت إضافة الفيديو بنجاح":type=="update"?"تم تعديل الفيديو بنجاح":type=="delete"?"تم حذف الفيديو بنجاح":""):(){};

      videoList= resultMap['data'];
    } else {
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"]));
    }
    isVideoLoading(false);
  }


  Future<void> questionOperations({String? type,int? quesId=0,int? videoId=0,String? question="",String? res1="" ,String? res2="",String? res3="",String? res4="",int? trueIndex}) async
  {

    isQuestionLoading(true);
    Map<String, String> postData = {
      "que_id":"$quesId",
      "question":question!,
      "res1":res1!,
      "res2":res2!,
      "res3":res3!,
      "res4":res4!,
      "video_id":"$videoId",
      "true_index":"$trueIndex",
      "type":type!,
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "question.php");
    if (resultMap["status"] == 1) {
      type!="load"?Fluttertoast.showToast(msg:type=="add"?"تمت إضافة السؤال بنجاح":type=="update"?"تم تعديل السؤال بنجاح":type=="delete"?"تم حذف السؤال بنجاح":""):(){};
      questionList= resultMap['data'];

      if(type=="add"||type=="update")
      {
        Get.back();
      }

    } else {
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"]));
    }
    isQuestionLoading(false);
  }

}