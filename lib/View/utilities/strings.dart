import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../Models/users/user_model.dart';

class Strings{

  static Rx<UserModel>? userInformation;
  static int? globalUserId;
  static const String appRootUrl="https://all-api-flutter.000webhostapp.com/";
  static const String appIconUrl=appRootUrl+"all_icon.jpg";
  static const coursesImagesDirectoryUrl=appRootUrl+"courses/courses_images/";
  static const coursesVideosDirectoryUrl=appRootUrl+"courses/videos/";
  static const List<String> userTypesList=["مسئول","عقارات","تسوق","اطباء","محاضر","مستخدم"];
  static String userType="مسئول";
  static String categoryType='تسوق';


  static const String appIconAssets="assets/images/icon.png";
  static const String cancel="Cancel";
  static const String appName="Ecommerce admin";
  static const String products="Products";
  static const String orders="Orders";
  static const String categories="Categories";
  static const String setting="Setting";
  static const String help="Help";
  static const String brands="Brands";
  static const String sold="Sold";
  static const String revenue="Revenue";
  static const String users="Users";
  static const String returned="Returned";

  static const String mode="mode";
  static const String darkMode="dark";
  static const String lightMode="light";

  static const String largeDesign ="large";
  static const String smallDesign="small";


}