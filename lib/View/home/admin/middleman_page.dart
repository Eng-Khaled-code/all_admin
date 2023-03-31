// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/View/home/middleman/place_view/place_card.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'search_field.dart';

class MiddlemanPage extends StatefulWidget {

   MiddlemanPage({Key? key}) : super(key: key);

  @override
  State<MiddlemanPage> createState() => _MiddlemanPageState();
}
String middlemanType="شقة";

class _MiddlemanPageState extends State<MiddlemanPage> {
  final AdminController _adminController=Get.find();

  final List<String> _middlemanTypes=["شقة","محل","عمارة","قطعة ارض"];
  @override
  Widget build(BuildContext context) {

    return  Column(
      children: [
        _searchWidget(),
        _typesWidget(),
        _dataWidget(),
      ],
    );
  }

 Widget _dataWidget() {
    int _itemCount=
 middlemanType=="شقة"
     ?
 _adminController.flatList.length
     :
 middlemanType=="عمارة"
     ?
 _adminController.blockList.length
     :
 middlemanType=="قطعة ارض"
     ?
 _adminController.groundList.length
     :
 middlemanType=="محل"
     ?
 _adminController.storeList.length
     :
 0;
    return Expanded(
      child: Obx(
              ()=>RefreshIndicator(
              onRefresh: ()async{
                await _adminController.operations(operationType: "load",moduleName: "middleman");
              },
              child:_adminController.isLoading.value
                  ?
              loadingWidget()

                  :
              _adminController.flatList.isEmpty&&middlemanType=="شقة"?noDataCard(text:  "لا توجد شقق",icon: Icons.account_balance):
              _adminController.blockList.isEmpty&&middlemanType=="عمارة"?noDataCard(text:  "لا توجد عماير",icon: Icons.account_balance):
              _adminController.groundList.isEmpty&&middlemanType=="قطعة ارض"?noDataCard(text:  "لا توجد قطع ارض",icon: Icons.account_balance):
              _adminController.storeList.isEmpty&&middlemanType=="محل"?noDataCard(text:  "لا توجد محلات",icon: Icons.account_balance):

              ListView.builder(
                  itemCount: _itemCount,
                  itemBuilder: (context,position){
                    switch(middlemanType)
                    {
                      case "شقة":
                        return  PlaceCard(model:_adminController.flatList[position],type: "admin",adminController: _adminController,);
                      case "عمارة":
                        return  PlaceCard(model:_adminController.blockList[position],type: "admin",adminController: _adminController);
                      case "قطعة ارض":
                        return PlaceCard(model:_adminController.groundList[position],type: "admin",adminController: _adminController);
                      case "محل":
                        return PlaceCard(model:_adminController.storeList[position],type: "admin",adminController: _adminController);
                      default:
                        return Container();
                    }
                  }

              ))

      ),
    );
 }


  SearchField _searchWidget() {
    return SearchField(lable: "بحث بالعنوان ...",onChange: (value){
      _adminController.middlemanSearch(value: value);
      setState((){});
    },);
  }

  CustomSelectionList _typesWidget() {
    return
      CustomSelectionList(list:_middlemanTypes,listType: "middleman",onTap:  (String? text){
      setState(()=> middlemanType=text!);
      });
  }
}