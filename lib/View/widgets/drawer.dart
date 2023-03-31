import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/user_controller.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/View/profile/profile_page.dart';
import 'package:middleman_all/View/rate_page/rate_page.dart';
import 'package:middleman_all/start_point/app_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constant.dart';
import 'custom_text.dart';

class CustomDrawer extends StatelessWidget {

  final UserController _userController=Get.find();

  @override
  Widget build(BuildContext context) {
    String _userType=userInformation!.value.userType!;

    return Drawer(

      child: ListView(
        children: <Widget>[
          drawerHeader(),
          drawerBodyTile(Icons.home, Colors.blue, "الرئيسية", ()=> Get.offAll(HomePage())),
          drawerBodyTile(Icons.settings, Colors.blue, "تحديث البيانات",  ()=>Get.to(ProfilePage()) ),
          _userType=="full_access"||_userType=="admin"?Container():drawerBodyTile(Icons.star_rate, Colors.blue, "التقييمات",  ()=> Get.to(RatePage())),
         _userType=="full_access"||_userType=="admin"?Container():drawerBodyTile(Icons.call, Colors.blue, " للتواصل",  () async=> await launch("tel://01159245717"),),
          const Divider(color: primaryColor),
          drawerBodyTile(Icons.arrow_back, Colors.red, "تسجيل الخروج", ()=> Get.dialog(
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      shape:const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0))
                    ),
                      title:const Text("تنبيه"),
                      content: const Text("هل تريد تسجيل الخروج بالفعل",style: TextStyle(fontSize: 14),),
                      actions: <Widget>[
                        TextButton(onPressed: ()=>Get.back(), child:const Text("إلغاء")),
                        TextButton(onPressed: ()=>_userController.logOut(), child: const Text("موافق"),),
                      ],
                    ),
                  ),
                  barrierDismissible: true,

                )
          ),
        ],
      ),
    );
  }


  drawerHeader()=> Obx((){
      String _imageUrl=userInformation!.value.imageUrl!;
      String _username=userInformation!.value.userName!;
      String _email=userInformation!.value.email!;
    return
    UserAccountsDrawerHeader(
    decoration: const BoxDecoration(color: primaryColor),
    currentAccountPicture: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(backgroundImage: NetworkImage(_imageUrl==""?appIconUrl:_imageUrl),backgroundColor: Colors.grey,),
    ),
    accountEmail: CustomText(text:"الإيميل : "+_email,color: Colors.black54,alignment: Alignment.topRight,fontSize: 12,),
    accountName:  CustomText(text:"الاسم : "+_username,color: Colors.black54,alignment: Alignment.bottomRight,fontSize: 12,),
    );},
    );


  Widget drawerBodyTile(
      IconData icon, Color color, String text, Function()? onTap) {
    return ListTile(
      title: Text(text),
      leading: Icon(
        icon,
        color: color,
      ),
      onTap: onTap,
    );
  }
}
