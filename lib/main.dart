import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:middleman_all/View/auth/log_in.dart';
import 'package:get_storage/get_storage.dart';
import 'Controller/data/theme_controller.dart';
import 'View/utilities/themes/app_thems/dark_them_data.dart';
import 'View/utilities/themes/app_thems/light_them_data.dart';
import 'start_point/binding.dart';

main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Middleman All',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(),
      darkTheme: darkThemeData(),
      themeMode: ThemeController().getThemeMode(),
      getPages: [
        GetPage(
            name: "/",
            page: () => const Directionality(
                textDirection: TextDirection.rtl,
                child: LogIn())), //,binding: MyBindings()),
      ],
      initialBinding: MyBindings(),
    );
  }
}
