import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Models/middleman/place_model.dart';
import 'package:middleman_all/Models/mps/missed_model.dart';
import 'package:middleman_all/Models/users/user_model.dart';
import 'package:middleman_all/Services/main_operations.dart';
import 'package:middleman_all/Services/ml_api.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import '../../View/utilities/strings.dart';

class AdminController extends GetxController {
  String url = Strings.appRootUrl + "admin/";
  RxBool isLoading = false.obs;
  RxDouble rxLat = 0.0.obs;
  RxDouble rxLong = 0.0.obs;
  RxString rxAddress = "".obs;

  List allProducts = [];
  List products = [];

  List allBooks = [];
  List books = [];

  List allCoursesList = [];
  List courses = [];

  List places = [];
  List<PlaceModel> blockList = [];
  List<PlaceModel> flatList = [];
  List<PlaceModel> groundList = [];
  List<PlaceModel> storeList = [];

  List users = [];
  RxList<UserModel> doctorUsers = <UserModel>[].obs;
  RxList<UserModel> middlemanUsers = <UserModel>[].obs;
  RxList<UserModel> normalUsers = <UserModel>[].obs;
  RxList<UserModel> ecommerceUsers = <UserModel>[].obs;
  RxList<UserModel> admins = <UserModel>[].obs;
  RxList<UserModel> coursesAdmin = <UserModel>[].obs;

  List persons = [];
  RxList<MissedModel> waitingMissedList = <MissedModel>[].obs;
  List<MissedModel> acceptedMissedList = [];
  List<MissedModel> refusedMissedList = [];
  RxList<MissedModel> waitingFoundList = <MissedModel>[].obs;
  List<MissedModel> acceptedFoundList = [];
  List<MissedModel> refusedFoundList = [];
  RxMap<String, dynamic> mainDashboard = <String, dynamic>{}.obs;
  final MainOperation _mainOperation = MainOperation();

  @override
  void onInit() {
    super.onInit();

    bool _admin = Strings.userInformation!.value.userType == "admin",
        _fullAccess = Strings.userInformation!.value.userType == "full_access";

    if (_admin) {
      operations(moduleName: "ecommerce", operationType: "load");
      operations(moduleName: "middleman", operationType: "load");
      operations(moduleName: "courses_list", operationType: "load");
      operations(moduleName: "mps", operationType: "load");
    } else if (_fullAccess) {
      operations(moduleName: "users", operationType: "load");
      operations(moduleName: "category", operationType: "load dasboard data");
      operations(moduleName: "books", operationType: "load");
    }

    operations(
        moduleName: "category",
        operationType: _fullAccess ? "load full access" : "load");
  }

  setMapData({String? address, double? lat, double? long}) {
    rxAddress(address);
    rxLat(lat);
    rxLong(long);
  }

  Future<void> operations(
      {String? moduleName,
      String? operationType,
      int? id = 0,
      String? addressOrCategoryDescription = "",
      String? usernameOrCategory = "",
      String? emailOrAdminToken = "",
      String? passwordOrStopReason = "",
      String? phoneOrMissedType = "",
      String? countryImageName = "",
      String? userStatusOrClinicStatus = "",
      String? lat,
      String? long,
      File? bookFile,
      File? imageFile,
      String? userType = ""}) async {
    isLoading(true);

    String _suggestedImage = await _getSuggestions(
        operationType: operationType, imageName: countryImageName);

    Map<String, String> postData = _getPostData(
        bookFile: bookFile,
        lat: lat,
        long: long,
        imageFile: imageFile,
        moduleName: moduleName,
        operationType: operationType,
        id: id,
        addressOrCategoryDescription: addressOrCategoryDescription,
        usernameOrCategory: usernameOrCategory,
        emailOrAdminToken: emailOrAdminToken,
        passwordOrStopReason: passwordOrStopReason,
        userType: userType,
        phoneOrMissedType: phoneOrMissedType,
        countryImageName: operationType == "add suggestion"
            ? _suggestedImage
            : countryImageName,
        userStatusOrClinicStatus: userStatusOrClinicStatus);

    String phpPageName = moduleName == "ecommerce"
        ? "products_admin"
        : moduleName == "courses_list"
            ? "course_admin"
            : moduleName == "middleman"
                ? "middleman_admin"
                : moduleName == "category"
                    ? "category_admin"
                    : moduleName == "mps"
                        ? "mps/mps_admin"
                        : moduleName == "books"
                            ? "read_books/books_admin"
                            : "user_admin";

    if (_suggestedImage == "" && operationType == "add suggestion") {
      Fluttertoast.showToast(msg: "غير موجود لدينا هذ الشخص");
    } else {
      Map<String, dynamic> resultMap = await _mainOperation.postOperation(
          postData,
          (moduleName == "mps" || moduleName == "books"
                  ? Strings.appRootUrl
                  : url) +
              phpPageName +
              ".php");
      if (resultMap["status"] == 1) {
        if (operationType == "load dasboard data") {
          mainDashboard(resultMap['data']);
        } else {
          _fillingLists(list: resultMap['data'], moduleName: moduleName);
          _categorizeLists(moduleName: moduleName);
          _action(moduleName: moduleName, operationType: operationType);
        }
      } else {
        Get.snackbar("خطا", errorTranslation(resultMap["message"]));
      }
    }

    isLoading(false);
  }

  Map<String, String> _getPostData(
      {String? moduleName,
      String? operationType,
      int? id = 0,
      String? userType = "",
      String? addressOrCategoryDescription = "",
      String? usernameOrCategory = "",
      String? emailOrAdminToken = "",
      String? passwordOrStopReason = "",
      String? phoneOrMissedType = "",
      String? countryImageName = "",
      String? lat = "",
      String? long = "",
      File? bookFile,
      File? imageFile,
      String? userStatusOrClinicStatus = ""}) {
    Map<String, String>? _postData;
    if (moduleName == "ecommerce" ||
        moduleName == "middleman" ||
        moduleName == "courses_list") {
      _postData = {
        "type": operationType!,
        "id": "$id",
        "status": userStatusOrClinicStatus!,
        "reason": passwordOrStopReason!,
        "admin_id": "${Strings.globalUserId}",
        "admin_token": emailOrAdminToken!
      };
    } else if (moduleName == "category") {
      _postData = {
        "type": operationType!,
        "category_id": "$id",
        "category_status": userStatusOrClinicStatus!,
        "category_description": addressOrCategoryDescription!,
        "category": usernameOrCategory!,
        'category_type': Strings.categoryType == "تسوق" ? "ecommerce" : "course"
      };
    } else if (moduleName == "mps") {
      _postData = {
        "type": operationType!,
        "id": "$id",
        "status": userStatusOrClinicStatus!,
        "refuse_reason": passwordOrStopReason!,
        "missed_type": phoneOrMissedType!,
        "image_name": countryImageName!,
        "admin_id": "${Strings.globalUserId}",
        "admin_token": emailOrAdminToken!
      };
    } else if (moduleName == "books") {
      String _imageName = "",
          _base64image = "",
          _fileName = "",
          _base64File = "";
      if (operationType == "add") {
        _imageName = imageFile!.path.split("/").last;
        _fileName = bookFile!.path.split("/").last;
        _base64File = base64Encode(bookFile.readAsBytesSync());
        _base64image = base64Encode(imageFile.readAsBytesSync());
      } else if (operationType == "update book image") {
        _imageName = imageFile!.path.split("/").last;
        _base64image = base64Encode(imageFile.readAsBytesSync());
      } else if (operationType == "update book file") {
        _fileName = bookFile!.path.split("/").last;
        _base64File = base64Encode(bookFile.readAsBytesSync());
      }

      _postData = {
        "type": operationType!,
        "book_id": "$id",
        "book_name": usernameOrCategory!,
        "book_name_english": _fileName,
        "old_book_name_english": phoneOrMissedType!,
        "base64_file": _base64File,
        "base64_image": _base64image,
        "od_image_name": addressOrCategoryDescription!,
        "image_name": _imageName,
        "user_id": "${Strings.globalUserId}"
      };
    } else {
      _postData = {
        "type": operationType!,
        "user_id": "$id",
        "user_or_clinic_status": userStatusOrClinicStatus!,
        "password": passwordOrStopReason!,
        "phone": phoneOrMissedType!,
        "country": countryImageName!,
        "address": addressOrCategoryDescription!,
        "lat": "$lat",
        "long": "$long",
        "username": usernameOrCategory!,
        "user_type": userType!,
        "email": emailOrAdminToken!
      };
    }

    return _postData;
  }

  void _fillingLists({List? list, String? moduleName}) {
    if (moduleName == "ecommerce") {
      allProducts = [];
      allProducts = list!;
    } else if (moduleName == "middleman") {
      places = [];
      places = list!;
    } else if (moduleName == "category") {
      categoriesList = [];
      categoriesList = list!;
    } else if (moduleName == "courses_list") {
      allCoursesList = [];
      allCoursesList = list!;
    } else if (moduleName == "mps") {
      persons = [];
      persons = list!;
    } else if (moduleName == "books") {
      allBooks = [];
      allBooks = list!;
    } else {
      users = [];
      users = list!;
    }
  }

  void _categorizeLists({String? moduleName}) {
    moduleName == "ecommerce"
        ? productsSearch(value: "")
        : moduleName == "middleman"
            ? middlemanSearch(value: "")
            : moduleName == "category"
                ? (selectedCategory =
                    selectedCategory ?? categoriesList.first['name'])
                : moduleName == "mps"
                    ? mpsSearch(value: "")
                    : moduleName == "books"
                        ? booksSearch(value: "")
                        : moduleName == "courses_list"
                            ? coursesSearch(value: "")
                            : usersSearch(value: "");
  }

  void _action({String? moduleName, String? operationType}) {
    bool _add = operationType == "add",
        _changeUserType = operationType == "change user type",
        _changeStatus = operationType == "change status",
        _update = operationType == "update" ||
            operationType == "update book file" ||
            operationType == "update book image",
        _addSuggestion = operationType == "add suggestion",
        _load = operationType == "load" || operationType == "load full access";

    if (_add && (moduleName == "users" || moduleName == "books")) {
      Get.back();
      Fluttertoast.showToast(msg: "تم الاضافة بنجاح");
    } else {
      !_load
          ? Fluttertoast.showToast(
              msg: _changeStatus
                  ? "تم تغيير الحالة بنجاح"
                  : _changeUserType
                      ? "تم تغيير نوع المستخدم بنجاح"
                      : _update
                          ? "تم التعديل بنجاح"
                          : _addSuggestion
                              ? "تم إرسال الاقتراحات بنجاح"
                              : "تم الاضافة بنجاح")
          : () {};
    }
  }

  void mpsSearch({String? value}) {
    waitingMissedList = <MissedModel>[].obs;
    acceptedMissedList = [];
    refusedMissedList = [];
    waitingFoundList = <MissedModel>[].obs;
    acceptedFoundList = [];
    refusedFoundList = [];

    for (var item in persons) {
      bool _missed = item['missed_type'] == "فقد",
          _found = item['missed_type'] == "إيجاد",
          _waiting = item['missed_status'] == 'انتظار',
          _accepted = item['missed_status'] == 'مقبول',
          _refused = item['missed_status'] == 'مرفوض',
          _searchValue =
              value == "" ? true : item['last_place'].contains(value);

      if (_missed && _waiting && _searchValue) {
        waitingMissedList.add(MissedModel.fromSnapshot(item));
      } else if (_missed && _accepted && _searchValue) {
        acceptedMissedList.add(MissedModel.fromSnapshot(item));
      } else if (_missed && _refused && _searchValue) {
        refusedMissedList.add(MissedModel.fromSnapshot(item));
      } else if (_found && _waiting && _searchValue) {
        waitingFoundList.add(MissedModel.fromSnapshot(item));
      } else if (_found && _accepted && _searchValue) {
        acceptedFoundList.add(MissedModel.fromSnapshot(item));
      } else if (_found && _refused && _searchValue) {
        refusedFoundList.add(MissedModel.fromSnapshot(item));
      }
    }
  }

  void middlemanSearch({String? value}) {
    blockList = [];
    flatList = [];
    groundList = [];
    storeList = [];
    for (var element in places) {
      bool _block = element['type'] == "block",
          _flat = element['type'] == "flat",
          _localStore = element['type'] == "local_store",
          _ground = element['type'] == "ground",
          _searchValue =
              value == "" ? true : element['address'].contains(value);

      if (_block && _searchValue) {
        blockList.add(PlaceModel.fromSnapshot(element));
      } else if (_flat && _searchValue) {
        flatList.add(PlaceModel.fromSnapshot(element));
      } else if (_localStore && _searchValue) {
        flatList.add(PlaceModel.fromSnapshot(element));
      } else if (_ground && _searchValue) {
        groundList.add(PlaceModel.fromSnapshot(element));
      }
    }
  }

  void productsSearch({String? value}) {
    products = [];
    for (var element in allProducts) {
      bool _searchValue =
          value == "" ? true : element['product_name'].contains(value);

      if (_searchValue) {
        products.add(element);
      }
    }
  }

  void coursesSearch({String? value}) {
    courses = [];
    for (var element in allCoursesList) {
      bool _searchValue = value == "" ? true : element['name'].contains(value);

      if (_searchValue) {
        courses.add(element);
      }
    }
  }

  void booksSearch({String? value}) {
    books = [];
    for (var element in allBooks) {
      bool _searchValue = value == "" ? true : element['name'].contains(value);

      if (_searchValue) {
        books.add(element);
      }
    }
  }

  void usersSearch({String? value}) {
    doctorUsers = <UserModel>[].obs;
    middlemanUsers = <UserModel>[].obs;
    normalUsers = <UserModel>[].obs;
    ecommerceUsers = <UserModel>[].obs;
    admins = <UserModel>[].obs;
    coursesAdmin = <UserModel>[].obs;
    for (var element in users) {
      bool _doctor = element['type'] == "doctor",
          _ecommerce = element['type'] == "ecommerce",
          _middleman = element['type'] == "middleman",
          _admin = element['type'] == "admin",
          _normalUser = element['type'] == "user",
          _coursAdmin = element['type'] == "course_admin",
          _searchValue =
              value == "" ? true : element['username'].contains(value);

      if (_doctor && _searchValue) {
        doctorUsers.add(UserModel.fromSnapshotForAdmin(element));
      } else if (_ecommerce && _searchValue) {
        ecommerceUsers.add(UserModel.fromSnapshotForAdmin(element));
      } else if (_middleman && _searchValue) {
        middlemanUsers.add(UserModel.fromSnapshotForAdmin(element));
      } else if (_admin && _searchValue) {
        admins.add(UserModel.fromSnapshotForAdmin(element));
      } else if (_normalUser && _searchValue) {
        normalUsers.add(UserModel.fromSnapshotForAdmin(element));
      } else if (_coursAdmin && _searchValue) {
        coursesAdmin.add(UserModel.fromSnapshotForAdmin(element));
      }
    }
  }

  Future<String> _getSuggestions(
      {String? operationType, String? imageName}) async {
    String _suggestedImage = "";
    if (operationType == "add suggestion") {
      Map<String, dynamic> resultMap =
          await MlServices().getSuggestions(imageName!);

      String condition = resultMap["status"];
      if (condition == "1") {
        _suggestedImage = resultMap["result"];
      }
    }
    return _suggestedImage;
  }
}
