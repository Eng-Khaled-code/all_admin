import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Models/middleman/place_model.dart';
import 'package:middleman_all/Services/main_operations.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/View/widgets/constant.dart';

import '../../View/utilities/strings.dart';
class MiddlemanController extends GetxController {

  String url = Strings.appRootUrl+"middleman/";
  RxBool isLoading = false.obs;
  RxBool isDataLoading = false.obs;
  RxBool isBuyerLoading = false.obs;
  List<PlaceModel> blockList=[];
  List<PlaceModel> flatList=[];
  List<PlaceModel> groundList=[];

  final MainOperation _mainOperation = MainOperation();



  @override
  void onInit() {
    super.onInit();
    loadPlaces();
  }

  Future<void> loadPlaces() async
  {

    isDataLoading(true);


    Map<String, String> postData = {"user_id": "${Strings.globalUserId}"};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "load_data.php");
    if (resultMap["status"] == 1) {

      loadAsPlaceModel(resultMap["data"]);

    } else {
      Get.snackbar("خطا",errorTranslation(resultMap["message"]));
    }
    isDataLoading(false);
  }

   loadAsPlaceModel(List list) {
    blockList=[];
    flatList=[];
    groundList=[];
    for (var element in list) {

      if(element['type']=="block")
      {
        blockList.add(PlaceModel.fromSnapshot(element));
      }
      else if(element['type']=="flat"||element['type']=="local_store")
      {
        flatList.add(PlaceModel.fromSnapshot(element));
      }
      else
      {
        groundList.add(PlaceModel.fromSnapshot(element));
      }

    }

  }

  Future<void> addOrUpdateDeleteOperation({
    String? addOrUpdate,
    String? operation,
    String? type,
    int? adminId,
    String? moreDetails,
    String? roufNum,
    String? size,
    String? metrePrice,
    String? address,
    int? opeId,

  }) async {

    isLoading(true);

    String _selectedType = (type == "شقة") ? "flat" : (type == "محل") ? "local_store" : (type == "عمارة") ? "block" : "ground";

    Map<String, String> postData =
    {
      "addOrUpdate": addOrUpdate!,
      "type": _selectedType,
      "admin_id": "$adminId",
      "more_details": moreDetails!,
      "rouf_num": type=="قطعة ارض"?"0":roufNum!,
      "size": size!,
      "metre_price": metrePrice!,
      "address": address!,
      "operation":type=="قطعة ارض"?"بيع": "$operation",
      "ope_id": "$opeId",

    };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "operations.php");
    if (resultMap["status"] == 1) {

      await loadPlaces();

    int _page=_selectedType=="flat"?1:_selectedType=="block"?3:4;
    currentIndex=_page;

    Get.snackbar("نجاح",addOrUpdate=="add"?"تمت الإضافة بنجاح":addOrUpdate=="update"?"تم التعديل بنجاح":"تم الحذف بنجاح");

    } else {
    if(addOrUpdate=="delete"){
    Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),toastLength: Toast.LENGTH_LONG,textColor: primaryColor,backgroundColor: Colors.white);
    }
    else
    {
    Get.snackbar("خطا",errorTranslation(resultMap["message"]));
    }
    }
    isLoading(false);
  }


  Future<void> addBuyer({
    int? opeId,
    int? buyerId,
  }) async {

    isBuyerLoading(true);

    Map<String, String> postData =
    {
      "ope_id": "$opeId",
      "buyer":buyerId.toString()
    };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "add_buyer.php");
    if (resultMap["status"] == 1) {

      await loadPlaces();
      Get.snackbar("نجاح","تم الحفظ بنجاح");

    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
          textColor: primaryColor,
          backgroundColor: Colors.white);
    }
    isBuyerLoading(false);
  }

}