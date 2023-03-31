
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/ecommerce_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'order_card.dart';
class OrdersPage extends StatelessWidget {

   OrdersPage({Key? key}) : super(key: key);

  final EcommerceController _ecommerceDataController=Get.find();

  @override
  Widget build(BuildContext context) {
    return

      _dataWidget()


    ;
  }

  _dataWidget(){
    return RefreshIndicator(
      onRefresh: ()async{
          await _ecommerceDataController.loadDiscountsAndCategoryAndProductsList("refresh");
        },
      child:  Obx(()=>

      _ecommerceDataController.isLoading.value
          ?
      loadingWidget()
          :_ecommerceDataController.ordersList.isEmpty
          ?
      noDataCard(text: "لا توجد طلبات حتي الان",icon:Icons.library_books)
          :
    Expanded(
    child:SizedBox(
        child: ListView.builder(
            itemCount:_ecommerceDataController.ordersList.length,
            itemBuilder: (context,position){
              return OrderCard(model:_ecommerceDataController.ordersList[position],ecommerceController: _ecommerceDataController,);

            }

        ),
      )),
      ),
    );
  }



}