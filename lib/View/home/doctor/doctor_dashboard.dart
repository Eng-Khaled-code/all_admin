import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/doctor_controller.dart';
import 'package:middleman_all/Controller/data/user_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'package:middleman_all/start_point/app_constant.dart';

class DoctorDashboard extends StatelessWidget {

  final DoctorController _doctorController=Get.find();
  final UserController _userController=Get.find();

  DoctorDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: ()async{
      await _doctorController.getBookingsByDoctor("out");
    },
    child:Obx(()=>

    _doctorController.isLoading.value
    ?
    loadingWidget()
        :
    Column(
      children: [
        _clinicStatusWidget(),
        Expanded(
          child: GridView(
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: <Widget>[
            dashboardCard(lable: "الانتظار",type: "doctor",counter:_doctorController.allWaitingLength.value ),
            dashboardCard(lable: "الانتظار اليوم",type: "doctor",counter:_doctorController.dayWaitingLength.value ),
            dashboardCard(lable: "تم الكشف",type: "doctor",counter:_doctorController.allWaitingLength.value ),
            dashboardCard(lable:"تم الكشف اليوم",type: "doctor",counter:_doctorController.dayFinishedLength.value ),

            dashboardCard(lable: "المقبول",type: "doctor",counter:_doctorController.allAcceptedLength.value ),
            dashboardCard(lable: "المقبول اليوم",type: "doctor",counter:_doctorController.dayAcceptedLength.value ),
            dashboardCard(lable: "المرفوض",type: "doctor",counter:_doctorController.allRefusedLength.value ),
            dashboardCard(lable:"المرفوض اليوم",type: "doctor",counter:_doctorController.dayRefusedLength.value ),
            dashboardCard(lable: "الملغي",type: "doctor",counter:_doctorController.allCanceledLength.value ),
            dashboardCard(lable:"الملغي اليوم",type: "doctor",counter:_doctorController.dayCanceledLength.value ),

          ],
          ),
        ),
      ],
    )));
  }

  _clinicStatusWidget() {

    return _userController.isClinickLoading.value?loadingWidget(margin: 2):RichText(
      textAlign: TextAlign.center,
      text: TextSpan(

        children: <TextSpan>[
          TextSpan(
              text:userInformation!.value.clinickStatus==0
          ?
          "هذه العيادة مغلقة حاليا ولا يمكنها استقبال الحجوزات لفتحها لإستقبال الحجوزات إضغط ":"العيادة يمكنها استقبال طلبات الان لغلقها إضغط ",
              style: const TextStyle(color: Colors.blue)),
          TextSpan(
              text: "هنا",
              style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color:userInformation!.value.clinickStatus==0?primaryColor:Colors.red,decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showPlaceStatusDialog()  ;               }),
        ],
      ),
    );
  }


  showPlaceStatusDialog() {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _controller = TextEditingController();

    Get.dialog(Directionality(
      textDirection: TextDirection.rtl,

      child: AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: const Text("تغيير حالة العيادة"),
          content: Form(
              key: _formKey,
              child: userInformation!.value.clinickStatus==0?CustomText(alignment:Alignment.centerRight,text:"هل تريد فتح العيادة"): Padding(
        padding:  const EdgeInsets.only(right:20.0),
        child: TextFormField(
          controller: _controller,
          validator: (String? value) {
        if (value!.isEmpty&&userInformation!.value.clinickStatus==0){
        return "يجب ان تدخل السبب";}
        },
          decoration:const InputDecoration(
              labelText: "سبب الإغلاق",
              labelStyle: TextStyle(fontSize: 13)),
        ),
      ),
    ),

      actions: <Widget>[TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
            Get.back();
            await _userController.updateUserFields(key:"d_clinick_status",value:userInformation!.value.clinickStatus==0?"1":"0",clinickReason:_controller.text);
            }
          },
          child: const Text("حفظ",
              style:
              TextStyle(fontSize: 13))),
      TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("إلغاء", style: TextStyle(fontSize: 13, color: Colors.red))),
      ],
    ),
    )
    );

  }

}
