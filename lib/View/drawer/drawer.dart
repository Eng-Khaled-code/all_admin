import 'package:flutter/material.dart';
import '../utilities/strings.dart';
import 'drawer_header.dart';
import 'drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Strings.userInformation == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  const CustomDrawerHeader(),
                  const CustomDrawerTile(
                    icon: Icons.home,
                    text: "الرئيسية",
                  ),
                  const CustomDrawerTile(
                    icon: Icons.account_circle_outlined,
                    text: "تحديث البيانات",
                  ),
                  Strings.userInformation!.value.userType == "full_access" ||
                          Strings.userInformation!.value.userType == "admin"
                      ? Container()
                      : const CustomDrawerTile(
                          icon: Icons.star_rate,
                          text: "التقييمات",
                        ),
                  Strings.userInformation!.value.userType == "full_access" ||
                          Strings.userInformation!.value.userType == "admin"
                      ? Container()
                      : const CustomDrawerTile(
                          icon: Icons.call,
                          text: "للتواصل",
                        ),
                  const Divider(
                    color: Colors.blueAccent,
                  ),
                  const CustomDrawerTile(
                      icon: Icons.settings, text: "الإعدادات"),
                  const CustomDrawerTile(
                      icon: Icons.help, text: "سياسة الخصوصية"),
                  const CustomDrawerTile(
                    icon: Icons.arrow_back,
                    text: "تسجيل الخروج",
                  ),
                ],
              ));
  }
}
