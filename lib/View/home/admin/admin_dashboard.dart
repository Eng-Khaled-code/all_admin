import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/start_point/app_constant.dart';
class AdminDashboard extends StatelessWidget {
  final AdminController _adminController=Get.find();

   AdminDashboard({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    bool
    _admin=userInformation!.value.userType=="admin",
    _fullAccess=userInformation!.value.userType=="full_access";
    return RefreshIndicator(
        onRefresh: ()async{


    _admin? await _adminController.operations(moduleName: "ecommerce",operationType:"load"):(){};
    _admin? await _adminController.operations(moduleName: "middleman",operationType:"load"):(){};
    await _adminController.operations(moduleName: "category",operationType:_fullAccess?"load full access": "load");
    _admin? await _adminController.operations(moduleName: "mps",operationType:"load"):(){};
    _fullAccess? await _adminController.operations(moduleName: "users",operationType: "load"):(){};
    _fullAccess? await _adminController.operations(moduleName: "category",operationType: "load dasboard data"):(){};

    //await _adminController.operations(moduleName: "books",operationType: "load");

        },
    child:Obx(()=>

    _adminController.isLoading.value
    ?
    loadingWidget()
        :
    GridView(
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    children: dashboardWidgetsList(_admin,_fullAccess)
    )));
  }

  List<Widget> dashboardWidgetsList(bool _admin,bool _fullAccess){
    List<Widget> resultList=[];
    List<Widget> from=<Widget>[

      _admin?Container():dashboardCard(lable: "كل المستخدمين",type: "doctor",counter:_adminController.users.length-1),
      _admin?Container():dashboardCard(lable: "المسئولين",type: "doctor",counter:_adminController.admins.length),
      _admin?Container():dashboardCard(lable: "الاطباء",type: "doctor",counter:_adminController.doctorUsers.length),
      _admin?Container():dashboardCard(lable: "المستخدمين",type: "doctor",counter:_adminController.normalUsers.length),
      _admin?Container():dashboardCard(lable: "مستخدم عقار",type: "doctor",counter:_adminController.middlemanUsers.length),
      _admin?Container():dashboardCard(lable: "مستخدم تسوق",type: "doctor",counter:_adminController.ecommerceUsers.length),
      _admin?Container():dashboardCard(lable: "الكتب",icon:CupertinoIcons.book,counter:_adminController.books.length),
      _admin?Container(): dashboardCard(lable: "الاقسام",icon: Icons.category,counter:categoriesList.length),

      dashboardCard(lable: "العقارات",type: "middleman",counter:_fullAccess?_adminController.mainDashboard['places_count']:_adminController.places.length),
      dashboardCard(lable: "الشقق",type: "middleman",counter:_fullAccess?_adminController.mainDashboard['flat_count']:_adminController.flatList.length ),
      _admin?Container():dashboardCard(lable: "شقق مشتراه",type: "middleman",counter: _adminController.mainDashboard['buy_flat_count']),
      dashboardCard(lable: "المحلات",type: "middleman",counter:_fullAccess? _adminController.mainDashboard['store_count']:_adminController.storeList.length),
      _admin?Container():dashboardCard(lable: "محلات مشتراه",type: "middleman",counter: _adminController.mainDashboard['buy_store_count']),
      dashboardCard(lable: "العماير",type: "middleman",counter:_fullAccess?_adminController.mainDashboard['block_count'] :_adminController.blockList.length),
      _admin?Container():dashboardCard(lable: "عماير مشتراه",type: "middleman",counter:_adminController.mainDashboard['buy_block_count'] ),
      dashboardCard(lable: "قطع الارض",type: "middleman",counter:_fullAccess?_adminController.mainDashboard['ground_count']:_adminController.groundList.length ),
      _admin?Container():dashboardCard(lable: "قطع الارض مشتراه",type: "middleman",counter:_adminController.mainDashboard['buy_ground_count'] ),
      dashboardCard(lable: "جميع الطلبات",type: "doctor",counter:_fullAccess?_adminController.mainDashboard['person_count']:_adminController.persons.length ),
      _admin?Container():dashboardCard(lable: "اشخاص تم إيجادهم",type: "doctor",counter:_adminController.mainDashboard['final_found_count'] ),
      _admin?Container():dashboardCard(lable: "تبليغ الفقد",type: "doctor",counter:_adminController.mainDashboard['miss_count'] ),
      dashboardCard(lable: "الانتظار فقد",type: "doctor",counter:_fullAccess?_adminController.mainDashboard['wait_miss_count'] :_adminController.waitingMissedList.length),
      dashboardCard(lable: "المقبول فقد",type: "doctor",counter:_fullAccess?_adminController.mainDashboard['accept_miss_count']:_adminController.acceptedMissedList.length ),
      dashboardCard(lable: "المرفوض فقد",type: "doctor",counter:_fullAccess?_adminController.mainDashboard['refuse_miss_count']:_adminController.refusedMissedList.length ),
      _admin?Container():dashboardCard(lable: "تبليغ الايجاد",type: "doctor",counter:_adminController.mainDashboard['found_count'] ),
      dashboardCard(lable: "الانتظار ايجاد",type: "doctor",counter:_fullAccess?_adminController.mainDashboard['wait_found_count']:_adminController.waitingFoundList.length ),
      dashboardCard(lable: "المقبول ايجاد",type: "doctor",counter:_fullAccess?_adminController.mainDashboard['accept_found_count']:_adminController.acceptedFoundList.length ),
      dashboardCard(lable: "المرفوض ايجاد",type: "doctor",counter:_fullAccess?_adminController.mainDashboard['refuse_found_count']:_adminController.refusedFoundList.length ),

    ];

    for(var widget in from)
    {
      if(widget.runtimeType != Container){
        resultList.add(widget);
      }
    }
    return resultList;

  }
}

