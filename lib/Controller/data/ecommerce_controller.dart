import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Models/ecommerce/discount_model.dart';
import 'package:middleman_all/Models/ecommerce/order_model.dart';
import 'package:middleman_all/Models/ecommerce/product_model.dart';
import 'package:middleman_all/Services/main_operations.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/start_point/app_constant.dart';

class EcommerceController extends GetxController {

  String url = appRootUrl+"ecommerce/";
  RxBool isLoading = false.obs;
  RxBool isCategoryLoading = false.obs;

  List<ProductModel> productList=[];
  List<DiscountModel> discountList=[];
  List<OrderModel> ordersList=[];
  int offDiscountCount=0;
  int onDiscountCount=0;
  int refusedCartCount=0;
  int acceptedCartCount=0;
  int unSeenCartCount=0;

  final MainOperation _mainOperation = MainOperation();


  @override
  void onInit() {
    super.onInit();
    loadDiscountsAndCategoryAndProductsList("load");
  }

  Future<void> loadDiscountsAndCategoryAndProductsList(String type) async
  {

    isLoading(true);
    Map<String, String> postData = {"admin_id": "$globalUserId"};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "load_products.php");
    if (resultMap["status"] == 1) {
      categoriesList=resultMap["categories"];
      if(type!="refresh") {
        selectedCategory =
        categoriesList.isNotEmpty ? categoriesList.first : "";
      }
      loadingListAsProductModel(resultMap['data']);
      loadingListAsDiscountModel(resultMap['discounts']);
      loadingListAsOrderModel(resultMap['orders']);

    } else {
      Get.snackbar("خطا",errorTranslation(resultMap["message"]));
    }
    isLoading(false);
  }

   loadingListAsProductModel(List resultList)
   {
     productList=[];
     for (var element in resultList){
       ProductModel _model=ProductModel.fromSnapshot(element);
       productList.add(_model);
     }
   }
  loadingListAsOrderModel (List resultList)
  {
    unSeenCartCount=0;
    refusedCartCount=0;
    acceptedCartCount=0;
    ordersList=[];
    for (var element in resultList){
      OrderModel _model=OrderModel.fromSnapshot(element);
      ordersList.add(_model);
      for(var item in _model.orderCartList!)
       {
         if(item['cart_status']==null||item['cart_status']==0){
           unSeenCartCount++;
         }else if(item['cart_status']==1){
           acceptedCartCount++;
         }else if(item['cart_status']==2){
           refusedCartCount++;
         }

       }
    }
  }

  Future<void> addOrUpdateDeleteProduct({
    String? addOrUpdateOrDelete="",
    String? category="",
    File? imageFile,
    String?imageUrl="",
    String? moreDetails="",
    String? name="",
    String? quantity="",
    String? unit="",
    String? price="",
    int? productId=0,

  }) async {

    isLoading(true);

    String imageName=imageFile !=null?imageFile.path.split("/").last:imageUrl!.split("/").last;
    String base64 = imageFile !=null?base64Encode(imageFile.readAsBytesSync()):"";

    Map<String, String> postData =
    {
      "type": addOrUpdateOrDelete!,
      "product_name": name!,
      "admin_id":"$globalUserId",
      "desc": moreDetails!,
      "category": category!,
      "price": price!,
      "quantity": quantity!,
      "unit": unit!,
      "image_name":imageName,
      "old_image_name": imageFile != null?imageUrl!.split("/").last:"no",
       "base64":base64,
      "product_id": "$productId",
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "product_operations.php");
    if (resultMap["status"] == 1) {

      await loadDiscountsAndCategoryAndProductsList("load");

      currentIndex=1;

    Get.snackbar("نجاح",addOrUpdateOrDelete=="add"?"تمت الإضافة بنجاح":addOrUpdateOrDelete=="update"?"تم التعديل بنجاح":"تم الحذف بنجاح");

    } else {
    if(addOrUpdateOrDelete=="delete"){
    Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),toastLength: Toast.LENGTH_LONG,textColor: primaryColor,backgroundColor: Colors.white);
    }
    else
    {
    Get.snackbar("خطا",errorTranslation(resultMap["message"]));
    }
    }
    isLoading(false);
  }



  Future<void> addOrUpdateDeleteProductDiscount({
    String? type,
    int? discountId=0,
    int? productId=0,

  }) async {

    isLoading(true);

    Map<String, String> postData =
    {
    "type": type!,
    "discount_id": "$discountId",
    "product_id": "$productId",
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
    postData, url + "discount_product.php");
    if (resultMap["status"] == 1) {
    await loadDiscountsAndCategoryAndProductsList("refresh");
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
        postData, url + "discount.php");
    if (resultMap["status"] == 1) {
      loadingListAsDiscountModel(resultMap['data']);
      type!="load"?Fluttertoast.showToast(msg:type=="add"?"تمت الإضافة بنجاح":type=="update"?"تم التعديل بنجاح":type=="delete"?"تم الحذف بنجاح":(status==1?"تم تفعيل العرض بالفعل":"تمإيقاف العرض بالفعل")):(){};

    } else {
      Get.snackbar("خطا",errorTranslation(resultMap["message"]));
    }
    isLoading(false);
  }




  loadingListAsDiscountModel(List resultList)
  {
    offDiscountCount=0;
    onDiscountCount=0;
    discountList=[];
    for (var element in resultList){
      DiscountModel _model=DiscountModel.fromSnapshot(element);
      discountList.add(_model);

      if(_model.status==0){
        offDiscountCount++;
      }else if(_model.status==1){
        onDiscountCount++;
      }
    }
  }


  Future<void> ordersOperation({String? type,int? productId=0,int? cartId=0,int? quantity }) async
  {

    isLoading(true);
    Map<String, String> postData = {
      "product_id": "$productId",
      "cart_id":"$cartId",
      "quantity":"$quantity",
      "type":type!,
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "admin_order.php");
    if (resultMap["status"] == 1) {
      Fluttertoast.showToast(msg:type=="accept"?"تمت الموافقة بنجاح":"تم الرفض بنجاح");
      await loadDiscountsAndCategoryAndProductsList("refresh");
    } else {
      Get.snackbar("خطا",errorTranslation(resultMap["message"]));
    }
    isLoading(false);

  }
}