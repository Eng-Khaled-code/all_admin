import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/middleman_controller.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/View/widgets/constant.dart';

import 'place_card.dart';
class PlacesPage extends StatelessWidget {
  final MiddlemanController _middlemanController=Get.find();

  PlacesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int itemCount=
    currentIndex==1
        ?
    _middlemanController.flatList.length
        :
    currentIndex==3
        ?
    _middlemanController.blockList.length
        :
    currentIndex==4
        ?
    _middlemanController.groundList.length
        :
    0;
    return  Obx(
        ()=>RefreshIndicator(
        onRefresh: ()async{
          await _middlemanController.loadPlaces();
        },
        child:_middlemanController.isDataLoading.value
            ?
        const Center(child: CircularProgressIndicator())

            :
        _middlemanController.flatList.isEmpty&&currentIndex==1?noDataCard(text:  "لا توجد شقق",icon: Icons.account_balance):
        _middlemanController.blockList.isEmpty&&currentIndex==3?noDataCard(text:  "لا توجد عماير",icon: Icons.account_balance):
        _middlemanController.groundList.isEmpty&&currentIndex==4?noDataCard(text:  "لا توجد قطع ارض",icon: Icons.account_balance):

        ListView.builder(
        itemCount: itemCount,
    itemBuilder: (context,position){
          switch(currentIndex)
          {
            case 1:
              return  PlaceCard(model:_middlemanController.flatList[position]);
            case 3:
              return _middlemanController.blockList.isEmpty?noDataCard(text:  "لا توجد عماير",icon: Icons.account_balance): PlaceCard(model:_middlemanController.blockList[position],middlemanController:_middlemanController ,);
            case 4:
              return _middlemanController.groundList==[]?noDataCard(text:  "لا توجد قطع ارض",icon: Icons.account_balance):  PlaceCard(model:_middlemanController.groundList[position],middlemanController:_middlemanController ,);
            default:
              return Container();
          }
        }

    ))



    );
  }

}