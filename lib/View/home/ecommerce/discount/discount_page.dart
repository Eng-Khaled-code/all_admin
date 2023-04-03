import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/ecommerce_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'discount_card.dart';
import 'operation_dialog.dart';

class DiscountPage extends StatelessWidget {
  final EcommerceController _ecommerceDataController = Get.find();

  DiscountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_addDiscountWidget(context), _dataWidget()],
    );
  }

  Expanded _dataWidget() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await _ecommerceDataController.discountOperations(type: "load");
        },
        child: Obx(
          () => _ecommerceDataController.isLoading.value
              ? loadingWidget()
              : _ecommerceDataController.discountList.isEmpty
                  ? noDataCard(text: "لا توجد عروض", icon: Icons.money_off)
                  : SizedBox(
                      child: ListView.builder(
                          itemCount:
                              _ecommerceDataController.discountList.length,
                          itemBuilder: (context, position) {
                            return DiscountCard(
                              model: _ecommerceDataController
                                  .discountList[position],
                              ecommerceController: _ecommerceDataController,
                            );
                          }),
                    ),
        ),
      ),
    );
  }

  Padding _addDiscountWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomButton(
          color: const [
            primaryColor,
            Color(0xFF0D47A1),
          ],
          text: "إضافة عرض",
          onPress: () => operationDialog(
              type: "إضافة عرض", controller: _ecommerceDataController),
          textColor: Colors.white),
    );
  }
}
