import 'package:get/get.dart';
import 'package:middleman_all/Models/users/user_model.dart';

Rx<UserModel>? userInformation;
int? globalUserId;
String appIconUrl="http://192.168.43.109/all_api/all_icon.jpg";
String appRootUrl="http://192.168.43.109/all_api/";
final List<String> userTypesList=["مسئول","عقارات","تسوق","اطباء","محاضر","مستخدم"];
String userType="مسئول";
String categoryType='تسوق';
