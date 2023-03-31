import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/ecommerce_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
class EcommerceDashboard extends StatelessWidget {

  final EcommerceController _ecommerceDataController=Get.find();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: ()async{
      await _ecommerceDataController.loadDiscountsAndCategoryAndProductsList("refresh");
    },
    child:Obx(()=>

    _ecommerceDataController.isLoading.value
    ?
    loadingWidget()
        :
    GridView(
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    children: <Widget>[
    dashboardCard(lable: "المنتجات",icon: Icons.shopping_basket,counter: _ecommerceDataController.productList.length ),
    dashboardCard(lable: "الطلبات",icon: Icons.library_books,counter: _ecommerceDataController.ordersList.length ),
    dashboardCard(lable: "المنتجات غير مراجعة",icon: Icons.remove_shopping_cart_outlined,counter: _ecommerceDataController.unSeenCartCount ),
    dashboardCard(lable: "المنتجات المقبولة",icon: Icons.shopping_cart,counter: _ecommerceDataController.acceptedCartCount ),
    dashboardCard(lable: "المنتجات المرفوضة",icon: Icons.remove_shopping_cart_outlined,counter: _ecommerceDataController.refusedCartCount ),
    dashboardCard(lable: "الخصومات",icon: Icons.money_off,counter: _ecommerceDataController.discountList.length ),
    dashboardCard(lable: "الخصومات الفعالة",icon: Icons.money_off,counter: _ecommerceDataController.onDiscountCount),
    dashboardCard(lable: "الخصومات غير فعالة",icon: Icons.money_off,counter: _ecommerceDataController.offDiscountCount ),
    dashboardCard(lable: "الاقسام",icon: Icons.shopping_basket,counter:categoriesList.length ),
    ],
    )));
  }}
