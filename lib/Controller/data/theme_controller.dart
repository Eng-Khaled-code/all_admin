import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:middleman_all/View/utilities/strings.dart';
class ThemeController extends GetxController {

  RxString? themeMode;
  final GetStorage storage=GetStorage();
  ThemeController(){
    themeMode!(storage.read(Strings.mode)??Strings.lightMode);
  }
  void setThemeMode(String mode){
    themeMode!(mode);
    storage.write(Strings.mode,mode );
  }

}