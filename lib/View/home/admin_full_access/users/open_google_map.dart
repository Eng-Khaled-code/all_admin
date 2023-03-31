
import 'package:middleman_all/View/home/admin_full_access/users/google_map_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';


Future<void> openMyMap({String? tapType,double? lat,double? long,String? title}) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Fluttertoast.showToast(msg: "يجب تشغيل خدمة الموقع الجغرافي",toastLength: Toast.LENGTH_LONG);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

    }
  }

  if (permission == LocationPermission.deniedForever) {
  }

   Get.to(GoogleMapsWidget(type:tapType,lat:lat,long:long
    ,markerTitle: title,));



}
