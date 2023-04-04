import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controller/data/theme_controller.dart';
import '../../Controller/data/user_controller.dart';
import '../help_page/help_page.dart';
import '../home/home_files/home_page.dart';
import '../profile/profile_page.dart';
import '../rate_page/rate_page.dart';
import '../setting/setting_page.dart';

// ignore: must_be_immutable
class CustomDrawerTile extends StatefulWidget {
  const CustomDrawerTile({Key? key, this.text, this.icon}) : super(key: key);
  final IconData? icon;
  final String? text;

  @override
  State<CustomDrawerTile> createState() => _CustomDrawerTileState();
}

class _CustomDrawerTileState extends State<CustomDrawerTile> {
  @override
  Widget build(BuildContext context) {
    Color color = widget.text == "تسجيل الخروج"
        ? Colors.red
        : widget.text == "سياسة الخصوصية"
            ? Colors.greenAccent
            : Colors.blueAccent;
    return ListTile(
      title: Text(widget.text!),
      leading: Icon(
        widget.icon,
        color: color,
      ),
      onTap: () => onTap(),
      trailing: widget.text == "الوضع المظلم" ? switchMode() : null,
    );
  }

  Switch switchMode() {
    bool value2 = ThemeController().isDarkMode();

    return Switch(
        value: value2,
        onChanged: (value) {
          ThemeController().changeThemeMode();
          setState(() {
            value2 = ThemeController().isDarkMode();
          });
        });
  }

  contactUs() async {
    await launchUrl(
      Uri(scheme: "tel", path: "tel://01159245717"),
    );
  }

  logOut() {
    Get.dialog(
      Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text("تنبيه"),
          content: const Text(
            "هل تريد تسجيل الخروج بالفعل",
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
            TextButton(
              onPressed: () {
                final UserController userController = Get.find();
                userController.logOut();
              },
              child: const Text("موافق"),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }

  onTap() {
    if (widget.text == "للتواصل") {
      contactUs();
    } else if (widget.text == "تسجيل الخروج") {
      logOut();
    } else if (widget.text == "الرئيسية") {
      Get.offAll(const HomePage());
    } else if (widget.text == "تحديث البيانات") {
      Get.to(() => ProfilePage());
    } else if (widget.text == "سياسة الخصوصية") {
      Get.to(() => const HelpPage());
    } else if (widget.text == "الإعدادات") {
      Get.to(() => const SettingPage());
    } else if (widget.text == "التقييمات") {
      Get.to(() => RatePage());
    } else if (widget.text == "التقييمات") {
      Get.to(() => RatePage());
    }
  }
}
