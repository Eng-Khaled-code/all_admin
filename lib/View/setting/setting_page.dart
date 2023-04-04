import 'package:flutter/material.dart';
import '../drawer/drawer_tile.dart';
import '../widgets/custom_text.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar:
            AppBar(title: const CustomText(text: "الإعدادات", fontSize: 18)),
        body: ListView(
            padding: const EdgeInsets.all(10),
            children: const <Widget>[
              CustomDrawerTile(
                icon: Icons.mode_night,
                text: "الوضع المظلم",
              ),
            ]),
      ),
    );
  }
}
