import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/View/home/admin_full_access/books/add_book.dart';
import 'package:middleman_all/View/home/admin_full_access/users/add_user.dart';
import 'package:middleman_all/View/home/course/add_course.dart';
import 'package:middleman_all/View/home/middleman/user_operations.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'package:middleman_all/View/widgets/drawer.dart';
import 'package:middleman_all/start_point/app_constant.dart';
import '../ecommerce/discount/operation_dialog.dart';
import 'app_modules_screens.dart';
import 'nav_bar_lists.dart';
int currentIndex=0;

class HomePage extends StatefulWidget {

 const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key=GlobalKey<ScaffoldState>();

  String? _userType;
  String _mainAppbarTitle="الرئيسية";
  late final AdminController _adminController=Get.find();

  @override
  Widget build(BuildContext context) {
    _userType=userInformation!.value.userType!;
    return WillPopScope(
    onWillPop:()=> _onWillPop(context),
    child:Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _key,
        appBar:_appBar() ,
          bottomNavigationBar:_navBar(),
          drawer: CustomDrawer(),
          body:  loadingAppBody(userType: _userType),
     floatingActionButton: _userType=="full_access"?_floatingActionButton():_userType=="course_admin"&&currentIndex==0?_floatingActionButtonForCourse():null,
    ))); }

  _appBar(){
    return AppBar(
      title:CustomText(text:_mainAppbarTitle,fontWeight: FontWeight.bold,fontSize: 16,
        alignment: _userType=="admin"?Alignment.centerRight:Alignment.center,),
      leading: _drawerButton(),
      actions: [_userType=="admin"?Container():_notiButton()],
    );
  }

  FloatingActionButton? _floatingActionButton(){
    bool _user=currentIndex==1,_book=currentIndex==2,_category=currentIndex==3;
    return currentIndex==0?null:FloatingActionButton.extended(
      onPressed: ()=>_category?operationDialog(type: "إضافة قسم لل"+categoryType,controller: _adminController)
          :
      Get.to(_user?AddUser():AddBook()),icon
        :
    Icon(_user?Icons.person_add:_book?CupertinoIcons.book:Icons.category),label
        :
    Text(_user?"إضافة مستخدم":_book?"إضافة كتاب":"إضافة قسم"),);
  }

  FloatingActionButton? _floatingActionButtonForCourse(){
    return FloatingActionButton.extended(
      onPressed: (){
        if(courseCategory==null)
        {
          Fluttertoast.showToast(msg:"لا توجد اقسام للكورسات حاليا يرجي ابلاغ المسئول");
        }
        else
          {
            Get.to(AddCourse());
          }
        },icon:const Icon(CupertinoIcons.book),label:const Text("إضافة كورس"),);
  }

  _navBar(){
    return Padding(
      padding: const EdgeInsets.only(top:16.0),
      child: _bottomNavigationBar(),
    );
  }

  Widget _notiButton()=>Container(margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color: Colors.white,),
      child: IconButton(icon:const Icon(Icons.notifications,color: primaryColor,size: 20,),onPressed:
          ()=>_key.currentState!.openDrawer()
  ));

  Widget _drawerButton()=>Container(margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color: Colors.white,),
      child: IconButton(icon:const Icon(Icons.menu,color: primaryColor,size: 20,),onPressed:
          ()=>_key.currentState!.openDrawer()
  ));

  leaveApp(BuildContext context)async{

    Get.dialog(
        SizedBox(
          height: 300,
          child: Directionality(
              textDirection: TextDirection.rtl,
              child:AlertDialog(
                scrollable: true,shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(10)),
                title: CustomText(alignment:Alignment.topRight,text:
                  "خروج",fontWeight: FontWeight.bold,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("إلغاء"))
                  ,TextButton(onPressed: ()=>SystemNavigator.pop(), child:const Text("تأكيد"))
                ],
                content: CustomText(text:"هل تريد الخروج من التطبيق بالفعل",alignment:Alignment.topRight),
              )),
        )
    );
    return true;
  }

  Future<bool> _onWillPop(BuildContext context) async{
      if(_key.currentState!.isDrawerOpen){
        Navigator.pop(context);
      }
      else{
        await leaveApp(context);
      }
      return false;

  }

  setTitle() {
    _mainAppbarTitle=currentIndex==0
        ?
    "الرئيسية"
        :
    currentIndex==1&&_userType=="middleman"
        ?
    "الشقق والمحلات"
        :
    currentIndex==2&&_userType=="middleman"
        ?
    "العمليات"
        :

    currentIndex==3&&_userType=="middleman"
        ?
    "عمارة"
        :
    currentIndex==4&&_userType=="middleman"
        ?
    "قطعة ارض"
        :

    currentIndex==1&&(_userType=="ecommerce"||_userType=="admin")
        ?
    "المنتجات"
        :
    currentIndex==2&&_userType=="ecommerce"
        ?
    "إضافة منتج"
        :
    currentIndex==3&&_userType=="ecommerce"
        ?
    "الطلبات"
        :
    (currentIndex==4&&_userType=="ecommerce")||(currentIndex==1&&_userType=="course_admin")
        ?
    "العروض والخصومات"
        :
    currentIndex==1&&_userType=="doctor"
        ?
    "حجوزات اليوم"
        :
    currentIndex==2&&_userType=="doctor"
        ?
    "الحجوزات"
        :
    currentIndex==2&&_userType=="admin"
        ?
        "الكورسات"
        :

    currentIndex==3&&_userType=="admin"
        ?
    "العقارات"
        :
    currentIndex==4&&_userType=="admin"
        ?
    "تبليغ الفقد"
        :
        currentIndex==5&&_userType=="admin"?
            "تبليغ الايجاد"
            :
    currentIndex==1&&_userType=="full_access"
        ?
    "المستخدمين"
        :
    currentIndex==2&&_userType=="full_access"
        ?
    "الكتب"
        :
    currentIndex==3&&_userType=="full_access"
        ?
    "الاقسام"
        :

    ""
    ;
  }

  Widget _bottomNavigationBar() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          items:_userType=="course_admin"?getCoursesList():_userType=="middleman"?getMiddlemanList():_userType=="ecommerce"?
          getEcommerceList():_userType=="admin"?getAdminList():_userType=="doctor"?getDoctorsList():getFullAccessAdminList(),
          currentIndex: currentIndex,
          onTap: (index) {
            currentIndex=index;
            if(index==2){
              UserOperations.addOrUpdate="إضافة";
            }
            setTitle();
            setState((){});
          },
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black45,
          unselectedLabelStyle: const TextStyle(color: Colors.black45,fontSize: 9),
          showUnselectedLabels: false,
          showSelectedLabels: false,

        ));
  }


}