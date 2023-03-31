
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';

class GoogleMapsWidget extends StatefulWidget {
  final double? lat;
  final double? long;
  final String? markerTitle;
  final String? type;
  GoogleMapsWidget({Key? key,this.lat, this.long,this.markerTitle,this.type}):super(key: key);

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {

  CameraPosition? _kGooglePlex;

  final Set<Marker> _markers={};
  final AdminController _adminController=Get.find();

  @override
  Widget build(BuildContext context) {
      if(widget.lat==null||widget.long==null)
      {
          Get.back();
      }
      else
      {
        _kGooglePlex= CameraPosition(
          target: LatLng(widget.lat!, widget.long!),
          zoom: 14.4746,
        );


        _markers.add(getCustomMarker(lat: widget.lat!,long: widget.long!,title: widget.markerTitle));
        setState(() {

        });
      }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppbar(title:widget.type=="show_map"?"العنوان":"تحديد العنوان",actions:Container()),
       body:
       _kGooglePlex==null
           ?
       loadingWidget()
           :
       GoogleMap(
       mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex!,
      markers: _markers,
      onTap: (LatLng latLng)async{
        if(widget.type=="get_address"){

        List<Placemark> places=await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        String title=places.first.country!+"-"+places.first.administrativeArea!+"-"+places.first.locality!;
        _adminController.setMapData(
        lat:latLng.latitude,
        long:latLng.longitude,
        address:title);

    _markers.remove(const Marker(markerId: MarkerId( "1")));
        _markers.add(getCustomMarker(lat: latLng.latitude,long: latLng.longitude,title: title));

         setState(() {});
        }
      },
      onMapCreated: (GoogleMapController controller) {
       }
      ) ,
      ),
    );
  }


  Marker getCustomMarker({double? lat,double? long ,String? title}){

    return Marker(infoWindow: InfoWindow(title: title),markerId:const MarkerId("1"),position: LatLng(lat!,long!),draggable:widget.type=="get_address"? true:false,
        onDragEnd: (LatLng latLng){
    if(widget.type=="get_address"){
      _adminController.setMapData(
          lat:latLng.latitude,
          long:latLng.longitude,
          address:title);

    }

        });
  }
}
