import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/ecommerce/discount_model.dart';
import 'package:middleman_all/View/home/ecommerce/discount/operation_dialog.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';

import 'discount_card.dart';

class CourseDiscountPage extends StatelessWidget {
  final CoursesController _courseControoler = Get.find();

  CourseDiscountPage({Key? key}) : super(key: key);

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
          await _courseControoler.discountOperations(type: "load");
        },
        child: Obx(
          () => _courseControoler.isLoading.value
              ? loadingWidget()
              : _courseControoler.discountList.isEmpty
                  ? noDataCard(text: "لا توجد عروض", icon: Icons.money_off)
                  : SizedBox(
                      child: ListView.builder(
                          itemCount: _courseControoler.discountList.length,
                          itemBuilder: (context, position) {
                            return DiscountCard(
                              model: DiscountModel.fromSnapshot(
                                  _courseControoler.discountList[position]),
                              courseController: _courseControoler,
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
          onPress: () =>
              operationDialog(type: "إضافة عرض", controller: _courseControoler),
          textColor: Colors.white),
    );
  }
}
