import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Controller/data/admin_controller.dart';
import '../../../widgets/constant.dart';

class DashbooardListWidget extends StatelessWidget {
  const DashbooardListWidget(
      {Key? key, this.adminController, this.admin, this.fullAccess})
      : super(key: key);
  final AdminController? adminController;
  final bool? admin;
  final bool? fullAccess;
  @override
  Widget build(BuildContext context) {
    return GridView(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: dashboardWidgetsList());
  }

  List<Widget> dashboardWidgetsList() {
    List<Widget> resultList = [];
    List<Widget> from = <Widget>[
      admin!
          ? Container()
          : dashboardCard(
              lable: "كل المستخدمين",
              type: "doctor",
              counter: adminController!.users.length - 1),
      admin!
          ? Container()
          : dashboardCard(
              lable: "المسئولين",
              type: "doctor",
              counter: adminController!.admins.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "الاطباء",
              type: "doctor",
              counter: adminController!.doctorUsers.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "المستخدمين",
              type: "doctor",
              counter: adminController!.normalUsers.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "مستخدم عقار",
              type: "doctor",
              counter: adminController!.middlemanUsers.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "مستخدم تسوق",
              type: "doctor",
              counter: adminController!.ecommerceUsers.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "الكتب",
              icon: CupertinoIcons.book,
              counter: adminController!.books.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "الاقسام",
              icon: Icons.category,
              counter: categoriesList.length),
      dashboardCard(
          lable: "العقارات",
          type: "middleman",
          counter: fullAccess!
              ? adminController!.mainDashboard['places_count']
              : adminController!.places.length),
      dashboardCard(
          lable: "الشقق",
          type: "middleman",
          counter: fullAccess!
              ? adminController!.mainDashboard['flat_count']
              : adminController!.flatList.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "شقق مشتراه",
              type: "middleman",
              counter: adminController!.mainDashboard['buy_flat_count']),
      dashboardCard(
          lable: "المحلات",
          type: "middleman",
          counter: fullAccess!
              ? adminController!.mainDashboard['store_count']
              : adminController!.storeList.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "محلات مشتراه",
              type: "middleman",
              counter: adminController!.mainDashboard['buy_store_count']),
      dashboardCard(
          lable: "العماير",
          type: "middleman",
          counter: fullAccess!
              ? adminController!.mainDashboard['block_count']
              : adminController!.blockList.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "عماير مشتراه",
              type: "middleman",
              counter: adminController!.mainDashboard['buy_block_count']),
      dashboardCard(
          lable: "قطع الارض",
          type: "middleman",
          counter: fullAccess!
              ? adminController!.mainDashboard['ground_count']
              : adminController!.groundList.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "قطع الارض مشتراه",
              type: "middleman",
              counter: adminController!.mainDashboard['buy_ground_count']),
      dashboardCard(
          lable: "جميع الطلبات",
          type: "doctor",
          counter: fullAccess!
              ? adminController!.mainDashboard['person_count']
              : adminController!.persons.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "اشخاص تم إيجادهم",
              type: "doctor",
              counter: adminController!.mainDashboard['final_found_count']),
      admin!
          ? Container()
          : dashboardCard(
              lable: "تبليغ الفقد",
              type: "doctor",
              counter: adminController!.mainDashboard['miss_count']),
      dashboardCard(
          lable: "الانتظار فقد",
          type: "doctor",
          counter: fullAccess!
              ? adminController!.mainDashboard['wait_miss_count']
              : adminController!.waitingMissedList.length),
      dashboardCard(
          lable: "المقبول فقد",
          type: "doctor",
          counter: fullAccess!
              ? adminController!.mainDashboard['accept_miss_count']
              : adminController!.acceptedMissedList.length),
      dashboardCard(
          lable: "المرفوض فقد",
          type: "doctor",
          counter: fullAccess!
              ? adminController!.mainDashboard['refuse_miss_count']
              : adminController!.refusedMissedList.length),
      admin!
          ? Container()
          : dashboardCard(
              lable: "تبليغ الايجاد",
              type: "doctor",
              counter: adminController!.mainDashboard['found_count']),
      dashboardCard(
          lable: "الانتظار ايجاد",
          type: "doctor",
          counter: fullAccess!
              ? adminController!.mainDashboard['wait_found_count']
              : adminController!.waitingFoundList.length),
      dashboardCard(
          lable: "المقبول ايجاد",
          type: "doctor",
          counter: fullAccess!
              ? adminController!.mainDashboard['accept_found_count']
              : adminController!.acceptedFoundList.length),
      dashboardCard(
          lable: "المرفوض ايجاد",
          type: "doctor",
          counter: fullAccess!
              ? adminController!.mainDashboard['refuse_found_count']
              : adminController!.refusedFoundList.length),
    ];

    for (var widget in from) {
      if (widget.runtimeType != Container) {
        resultList.add(widget);
      }
    }
    return resultList;
  }
}
