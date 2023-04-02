// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/View/home/admin/search_field.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import '../../../utilities/strings.dart';
import 'users_card.dart';

class UsersPage extends StatefulWidget {

  UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final AdminController _adminController=Get.find();
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        _searchWidget(),
        _usersTypeWidget(),
        _dataWidget()

      ],

    );
  }


  Widget _dataWidget() {

    bool
    _admin=Strings.userType=="مسئول",
        _normalUser=Strings.userType=="مستخدم",
        _doctor=Strings.userType=="اطباء",
        _middleman=Strings.userType=="عقارات",
        _ecommerce=Strings.userType=="تسوق",
        _course=Strings.userType=="محاضر";

    return Expanded(
      child: Obx(
              ()=>RefreshIndicator(
              onRefresh: ()async{
                await _adminController.operations(operationType: "load",moduleName: "users");
                setState(() {});
              },
              child:_adminController.isLoading.value
                  ?
              loadingWidget()
                  :
              Strings.userType=="مسئول"&& _adminController.admins.isEmpty?noDataCard(text:  "لا يوجد مسئولين",icon: Icons.person):
              Strings.userType=="اطباء"  && _adminController.doctorUsers.isEmpty?noDataCard(text:  "لا يوجد أطباء",icon: Icons.person):
              Strings.userType=="مستخدم"  && _adminController.normalUsers.isEmpty?noDataCard(text:  "لا يوجد مستخدمين",icon: Icons.person):
              Strings.userType=="عقارات"  && _adminController.middlemanUsers.isEmpty?noDataCard(text:  "لا يوجد وسطاء للعقارات",icon: Icons.person):
              Strings.userType=="تسوق"  && _adminController.ecommerceUsers.isEmpty?noDataCard(text:  "لا يوجد موزعين",icon: Icons.person):
              Strings.userType=="محاضر"  && _adminController.coursesAdmin.isEmpty?noDataCard(text:  "لا يوجد محاضرين",icon: Icons.person):

    ListView.builder(
                  itemCount: _admin
                      ?
                  _adminController.admins.length
                      :
                  _normalUser
                      ?
                  _adminController.normalUsers.length
                      :
                  _doctor
                      ?
                  _adminController.doctorUsers.length
                      :
                  _ecommerce
                      ?
                  _adminController.ecommerceUsers.length
                      :
                  _middleman
                      ?
                  _adminController.middlemanUsers.length
                      :
                  _course
                      ?
                  _adminController.coursesAdmin.length
                      :
                  0,
                  itemBuilder: (context,position){
                    return
                      UserCard(
                          model:
                          _admin
                              ?
                          _adminController.admins[position]
                              :
                          _normalUser
                              ?
                          _adminController.normalUsers[position]
                              :
                          _doctor
                              ?
                          _adminController.doctorUsers[position]
                              :
                          _ecommerce
                              ?
                          _adminController.ecommerceUsers[position]
                              :
                          _course
                              ?
                          _adminController.coursesAdmin[position]:
                          _adminController.middlemanUsers[position]
                          ,
                          adminController: _adminController


                      );
                  }

              ))

      ),
    );
  }


  CustomSelectionList _usersTypeWidget() {
    return CustomSelectionList(list:Strings.userTypesList ,listType: "userType2",onTap:  (String? text){
    setState(()=> Strings.userType=text!);});
  }

  SearchField _searchWidget() {
    return SearchField(lable: "بحث بإسم المستخدم ...",onChange: (value){
      _adminController.usersSearch(value: value);
      setState((){});
    },);

  }
}