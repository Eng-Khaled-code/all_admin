import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';

import '../../../utilities/strings.dart';
import 'dashboard_list_widgets.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({Key? key}) : super(key: key);

  final AdminController adminController = Get.find();

  final bool admin = Strings.userInformation!.value.userType == "admin";
  final bool fullAccess =
      Strings.userInformation!.value.userType == "full_access";

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: Obx(() => adminController.isLoading.value
            ? loadingWidget()
            : DashbooardListWidget(
                admin: admin,
                fullAccess: fullAccess,
                adminController: adminController)));
  }

  onRefresh() async {
    admin
        ? await adminController.operations(
            moduleName: "ecommerce", operationType: "load")
        : () {};
    admin
        ? await adminController.operations(
            moduleName: "middleman", operationType: "load")
        : () {};
    await adminController.operations(
        moduleName: "category",
        operationType: fullAccess ? "load full access" : "load");
    admin
        ? await adminController.operations(
            moduleName: "mps", operationType: "load")
        : () {};
    fullAccess
        ? await adminController.operations(
            moduleName: "users", operationType: "load")
        : () {};
    fullAccess
        ? await adminController.operations(
            moduleName: "category", operationType: "load dasboard data")
        : () {};

    //await _adminController.operations(moduleName: "books",operationType: "load");
  }
}
