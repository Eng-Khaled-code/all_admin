import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/user_controller.dart';
import 'package:middleman_all/Models/users/rate_model.dart';
import 'package:middleman_all/View/rate_page/rate_card.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

class RatePage extends StatelessWidget {
  final UserController _userController = Get.find();

  RatePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _userController.getComments();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: const CustomText(
              text: "التقييمات",
              alignment: Alignment.centerRight,
              fontSize: 20,
            ),
            leading: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor)),
                child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: primaryColor,
                      size: 20,
                    ),
                    onPressed: () => Get.back())),
          ),
          body: Obx(
            () => SizedBox(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _userController.getComments();
                },
                child: _userController.isCommentLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _userController.userComments.isEmpty
                        ? noDataCard("لا توجد تقييمات")
                        : ListView.builder(
                            itemCount: _userController.userComments.length,
                            itemBuilder: (context, position) {
                              return RateCard(
                                  model: RateModel.fromSnapshot(
                                      _userController.userComments[position]));
                            }),
              ),
            ),
          )),
    );
  }

  noDataCard(String message) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 300,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_emotions, size: 50, color: primaryColor),
          const SizedBox(height: 15.0),
          CustomText(text: message)
        ],
      ),
    );
  }
}
