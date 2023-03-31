import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/middleman_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
class MiddlemanDashboard extends StatelessWidget {

  final MiddlemanController _middlemanController=Get.find();

  MiddlemanDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: ()async{
          await _middlemanController.loadPlaces();
        },
        child:Obx(()=>

        _middlemanController.isDataLoading.value
            ?
        loadingWidget()
            :
        Column(
          children: [
            Expanded(
              child: GridView(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                children: <Widget>[
                  dashboardCard(lable: "الشقق والمحلات",type: "middleman",counter:_middlemanController.flatList.length ),
                  dashboardCard(lable: "قطع الارض",type: "middleman",counter:_middlemanController.groundList.length  ),
                  dashboardCard(lable: "عمارة",type: "middleman",counter:_middlemanController.blockList.length  ),

                ],
              ),
            ),
          ],
        )));
  }}