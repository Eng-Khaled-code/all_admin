import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:middleman_all/Services/main_operations.dart';
import 'package:middleman_all/View/auth/log_in.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/Models/users/user_model.dart';
import 'package:middleman_all/View/profile/profile_constant.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import '../../View/home/ecommerce/operation_view/ecommerce_operations.dart';
import '../../View/home/middleman/user_operations.dart';
import '../../View/utilities/strings.dart';

class UserController extends GetxController {
  String url = Strings.appRootUrl + "auth/";

  List userPhones = [];
  List userWorkDays = [];
  List userCountries = [];
  List userComments = [];
  RxString? splachError;
  RxBool isLoading = false.obs;
  RxBool isPhoneLoading = false.obs;
  RxBool isClinickLoading = false.obs;
  RxBool isWorkDaysLoading = false.obs;
  RxBool isCommentLoading = false.obs;
  RxBool isImageLoading = false.obs;
  RxBool isUsernameLoading = false.obs;
  RxBool isAddressLoading = false.obs;
  RxBool isAboutDoctor = false.obs;
  RxBool isCountryLoading = false.obs;
  RxString page = 'splach'.obs;
  // UserModel? userInformation;
  GetStorage prefs = GetStorage();
  final MainOperation _mainOperation = MainOperation();

  @override
  void onInit() {
    super.onInit();
    checkLogIn();
  }

  checkLogIn() {
    page(prefs.read("log_in") == null
        ? "log_in"
        : prefs.read("log_in") == "log_in"
            ? "log_in"
            : "splach");
    if (page == "splach".obs) {
      Strings.globalUserId = int.tryParse(prefs.read("user_id"));

      openMyHomePage(
          email: "",
          password: "",
          type: "load",
          userId: "${Strings.globalUserId}",
          userType: "");
    }
  }

  Future<void> openMyHomePage(
      {String? email,
      String? password,
      String? type,
      String? userId,
      String? userType}) async {
    isLoading(true);
    page('splach');
    //await FirebaseMessaging.instance.getToken().then((String? token)async{

    Map<String, String> postData = {
      "email": email!,
      "password": password!,
      "type": type!,
      "user_type": userType!,
      "user_id": userId!,
      "token": "test"
    };

    Map<String, dynamic> resultMap =
        await _mainOperation.postOperation(postData, url + "on_app_start.php");
    if (resultMap["status"] == 1) {
      prefs.write("user_id", "${resultMap["data"]["user_id"]}");
      Strings.globalUserId = resultMap["data"]["user_id"];
      prefs.write("log_in", "splach");

      Strings.userInformation = UserModel.fromSnapshot(resultMap["data"]).obs;
      Widget myWidget = Strings.userInformation!.value.userType == "ecommerce"
          ? EcommerceOperations()
          : UserOperations();
          
      Get.offAll(() => HomePage(middleManAddOrUpdate: myWidget));
      Get.snackbar("", "تم تسجيل الدخول بنجاح");

      phoneOperations(type: "load", phoneId: "", number: "");
      countryOperations(type: "load", countryId: "", country: "");
      Strings.userInformation!.value.userType == "doctor"
          ? workDaysOperations(type: "load")
          : () {};
    } else {
      if (type == "log_in") {
        page("log_in");

        Get.snackbar(
          "خطأ",
          errorTranslation(resultMap["message"]),
        );
      } else {
        splachError = errorTranslation(resultMap["message"]).obs;
      }
    }
    isLoading(false);

    /* }).catchError(( comingError){
      error = comingError;
      isLoading=false;
      update();
      return false;

  });
*/
  }

  Future<void> updateImage({
    File? image,
    String? addOrUpdatePhoto,
  }) async {
    isImageLoading(true);

    String imageName = image!.path.split("/").last;
    String base64 = base64Encode(image.readAsBytesSync());

    Map<String, String> postData = {
      "addOrUpdatePhoto": addOrUpdatePhoto!,
      "userId": Strings.userInformation!.value.userId.toString(),
      "image_name": imageName,
      "old_image_name":
          Strings.userInformation!.value.imageUrl!.split("/").last,
      "base64": base64
    };

    Map<String, dynamic> resultMap =
        await _mainOperation.postOperation(postData, url + "update_photo.php");
    if (resultMap["status"] == 1) {
      Strings.userInformation = UserModel.fromSnapshot(resultMap['data']).obs;
      Fluttertoast.showToast(
          msg: "تم تحديث صورة الملف الشخصي بنجاح",
          toastLength: Toast.LENGTH_LONG,
          textColor: primaryColor,
          backgroundColor: Colors.white);
    } else {
      Fluttertoast.showToast(
          msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
          textColor: primaryColor,
          backgroundColor: Colors.white);
    }
    isImageLoading(false);
  }

  void logOut() {
    prefs.write("user_id", "");
    prefs.write("log_in", "log_in");
    page('log_in');
    Strings.userType = "مسئول";
    currentIndex = 0;
    Get.offAll(() =>
        const Directionality(textDirection: TextDirection.rtl, child: LogIn()));
    Get.snackbar("", "تم تسجيل الخروج بنجاح");
    update();
  }

  Future<void> phoneOperations(
      {String? type, String? phoneId, String? number}) async {
    isPhoneLoading(true);

    Map<String, String> postData = {
      "user_id": Strings.userInformation!.value.userId.toString(),
      "type": type!,
      "phone_id": phoneId!,
      "number": number!
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "phone_operation.php");
    if (resultMap["status"] == 1) {
      userPhones = resultMap["data"];
      if (type != "load") {
        Get.snackbar(
            "نجاح",
            type == "add"
                ? "تمت اضافة الهاتف بنجاح"
                : type == "update"
                    ? "تم تعديل الهاتف بنجاح"
                    : "تم حذف الهاتف بنجاح");
      }
    } else {
      Fluttertoast.showToast(
          msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
          textColor: primaryColor,
          backgroundColor: Colors.white);
    }
    isPhoneLoading(false);
  }

  Future<void> workDaysOperations(
      {String? type,
      int? dayId = 0,
      String? startTime = "",
      String? endTime = ""}) async {
    isWorkDaysLoading(true);
    Map<String, String> postData = {
      "doc_id": "${Strings.globalUserId}",
      "type": type!,
      "start_time": startTime!,
      "end_time": endTime!,
      "day": selectedDay,
      "day_id": "$dayId"
    };

    Map<String, dynamic> resultMap =
        await _mainOperation.postOperation(postData, url + "work_days.php");
    if (resultMap["status"] == 1) {
      userWorkDays = resultMap["data"];
      if (type != "load") {
        Get.snackbar(
            "نجاح",
            type == "add"
                ? "تمت اضافة الموعد بنجاح"
                : type == "update"
                    ? "تم تعديل الموعد بنجاح"
                    : "تم حذف الموعد بنجاح");
      }
    } else {
      Fluttertoast.showToast(
          msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
          textColor: primaryColor,
          backgroundColor: Colors.white);
    }
    isWorkDaysLoading(false);
  }

  Future<void> countryOperations(
      {String? type, String? countryId, String? country}) async {
    isCountryLoading(true);

    Map<String, String> postData = {
      "user_id": Strings.userInformation!.value.userId.toString(),
      "type": type!,
      "country_id": countryId!,
      "country": country!
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "country_operation.php");
    if (resultMap["status"] == 1) {
      userCountries = resultMap["data"];
      if (type != "load") {
        Get.snackbar(
            "نجاح",
            type == "add"
                ? "تمت اضافة الدولة بنجاح"
                : type == "update"
                    ? "تم تعديل الدولة بنجاح"
                    : "تم حذف الدولة بنجاح");
      }
    } else {
      Fluttertoast.showToast(
          msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
          textColor: primaryColor,
          backgroundColor: Colors.white);
    }
    isCountryLoading(false);
  }

  Future<void> updateUserFields(
      {String? key, String? value, String? clinickReason = ""}) async {
    key == "username"
        ? isUsernameLoading(true)
        : key == "address"
            ? isAddressLoading(true)
            : key == "about_doctor"
                ? isAboutDoctor(true)
                : isClinickLoading(true);

    Map<String, String> postData = {
      "user_id": Strings.userInformation!.value.userId.toString(),
      "key": key!,
      "value": value!,
    };

    Map<String, dynamic> resultMap =
        await _mainOperation.postOperation(postData, url + "update_user.php");
    if (resultMap["status"] == 1) {
      if (key == "d_clinick_status" && value == "0") {
        Map<String, String> postData2 = {
          "user_id": Strings.userInformation!.value.userId.toString(),
          "key": "d_closing_reason",
          "value": clinickReason!,
        };
        Map<String, dynamic> result2Map = await _mainOperation.postOperation(
            postData2, url + "update_user.php");

        if (result2Map["status"] == 1) {
          Strings.userInformation =
              UserModel.fromSnapshot(result2Map["data"]).obs;
          Fluttertoast.showToast(
              msg: key == "0" ? "تم فتح العيادةبنجاح" : "تم إغلاق العيادة");
        } else {
          Fluttertoast.showToast(msg: errorTranslation(result2Map["message"]));
        }
      } else {
        Strings.userInformation = UserModel.fromSnapshot(resultMap["data"]).obs;
        Fluttertoast.showToast(
            msg: key == "username"
                ? "تم تعديل الاسم بنجاح"
                : key == "address"
                    ? "تم تعديل العنوان بنجاح"
                    : key == "about_doctor"
                        ? "تم تعديل التخصص بنجاح"
                        : "تم فتح العيادة بنجاح");
      }
    } else {
      Fluttertoast.showToast(
          msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
          textColor: primaryColor,
          backgroundColor: Colors.white);
    }

    key == "username"
        ? isUsernameLoading(false)
        : key == "address"
            ? isAddressLoading(false)
            : key == "about_doctor"
                ? isAboutDoctor(false)
                : isClinickLoading(false);
  }

  Future<void> getComments() async {
    isCommentLoading(true);

    Map<String, String> postData = {
      "user1_id": Strings.userInformation!.value.userId.toString(),
      "type": "load",
      "user2_id": "",
      "comment": "",
      "rate": "",
      "user_type": "middleman"
    };

    Map<String, dynamic> resultMap =
        await _mainOperation.postOperation(postData, url + "get_comments.php");
    if (resultMap["status"] == 1) {
      userComments = resultMap["data"];
    } else {
      Fluttertoast.showToast(
          msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
          textColor: primaryColor,
          backgroundColor: Colors.white);
    }
    isCommentLoading(false);
  }
}
