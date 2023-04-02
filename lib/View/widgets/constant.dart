import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utilities/strings.dart';
import 'custom_text.dart';

const Color primaryColor=Colors.blue;
const Color primaryColorDark=Colors.black;

 String? selectedCategory;
 List categoriesList=[];

BoxDecoration customDecoration(){
  return BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white);
}

String errorTranslation(String englishErrr) {

  if(englishErrr=="sorry thier was a problem"){
    return "نعتذر يوجد خطأ ما من فضلك اعد فتح التطبيق";
  }
  else if(englishErrr=="your account locked by admin"){
    return "هذا الحساب مغلق يرجي التواصل مع مالك التطبيق";
  }
  else if(englishErrr=="email not correct"){
    return "الإيميل غير صحيح";
  }
  else if(englishErrr=="email or password not valid"){
    return "الايميل او كلمة المرور غير صحيحة";
  }
  else if(englishErrr=="failed to open database"){
    return "نعتذر يوجد خطأ يرجي إبلاغ مالك التطبيق";
  }

  else if(englishErrr=="error while addition"){
    return "لم تتم الإضافة";
  }
  else if(englishErrr=="error while update"){
    return "لم يتم التعديل";
  } else if(englishErrr=="error while uploading image"){
    return "يوجد خطا اثناء رفع الصورة لقواعد البيانات";
  }
  else if(englishErrr=="error while uploading video"){
    return "يوجد خطا اثناء رفع الفيديو لقواعد البيانات";
  }
  else if(englishErrr=="already suggested")
  {
    return "لا توجد إقتراحات جديدة";
  }
  else {
    return englishErrr;
  }}

Widget noDataCard({String? text,IconData? icon}) {
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: Container(
      margin: const EdgeInsets.all(8),
      width:double.infinity ,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color:Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Icon(icon, size: 60),
          const SizedBox(height: 15),
          CustomText(text:text!,color: Colors.black45,fontSize: 14,fontWeight: FontWeight.bold,),
          const SizedBox(height: 50),
        ],
      ),
    ),
  );}

Padding dashboardCard({String?lable, IconData? icon,int? counter,String? type=""}){
  return  Padding(
    padding: const EdgeInsets.all(15.0),
    child: Card(
      elevation: 2.0,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [TextButton.icon(
            onPressed: null,
            icon: Icon(type=="doctor"?Icons.person:type=="middleman"?Icons.account_balance:icon,color: Colors.blue,),
            label: SizedBox(
              width: 80,
              child: Text(
                  lable!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color:Colors.blue,fontWeight: FontWeight.bold,
                    fontSize: 16.0,)

              ),
            ),
          ),
          Text(
              counter.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color:Colors.blue,fontWeight: FontWeight.bold,
                fontSize: 22.0,)

          ),]
      ),
    ),
  );
}

Align loadingWidget({double? margin=50}) {
  return Align(alignment: Alignment.topCenter,child: Container(margin:EdgeInsets.all(margin!),height:20,width:20,child:const CircularProgressIndicator(strokeWidth: 2,)));
}

Container coloredContainer({String? text,Color color=primaryColor}) {
  return
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: color),
      child: CustomText(text:text!,color: Colors.white,),);
}

Row adminProfileWidget({String? name="",String? image="",String? date,Color? color=Colors.black ,String? opertionType=""}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(width: 5,),
      CircleAvatar(backgroundImage: NetworkImage(image==""?Strings.appIconUrl:image!),backgroundColor: Colors.grey,),
      const SizedBox(width: 15,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CustomText(text: name!,color: color!,alignment: Alignment.centerRight,fontWeight: FontWeight.bold,maxLine: 1,),
          date==""?Container():customDateWidget(date: date,textColor: color),

          opertionType==""?Container():Container(padding:const EdgeInsets.symmetric(horizontal: 5.0,vertical: 2.0),child: CustomText(text: opertionType!,color: Colors.white,alignment: Alignment.centerRight,fontSize: 12,) ,decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(8.0)),)

        ],
      ),],);
}

customDateWidget({String? date,Color? textColor =Colors.black,double? fontSize=12}) {
  return Directionality(textDirection:TextDirection.ltr,child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
  CustomText(text: "  الساعة =>  "+date!.substring(date.length-8,date.length-3),color: textColor!,alignment: Alignment.bottomRight,fontSize: fontSize!,maxLine: 1,),
  CustomText(text: date.substring(0,date.length-8),color: textColor,alignment: Alignment.bottomRight,fontSize: fontSize,maxLine: 1,),

  ],
  ));
}

Container imageWidget({String? image ,double? height=250 ,double? width=double.infinity}) {
  return Container(
    margin:const EdgeInsets.only(left: 5.0,right: 5.0),
    height: height,
    width: width,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child:  FadeInImage.assetNetwork(
        placeholder: "assets/images/loading.gif",
        image:
        image!,
        fit: BoxFit.fill,
        imageErrorBuilder:(e,r,t)=> Image.asset(
          "assets/images/errorimage.png",
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}

AppBar  customAppbar({String? title,Widget? actions}) {
  return AppBar(
    backgroundColor: Colors.white,
    title: CustomText(text:
    title!,
      alignment: Alignment.centerRight,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
    actions: [
      actions!
    ],
    leading:
    Container(margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor)),
        child: IconButton(icon:const Icon(Icons.arrow_back,color: primaryColor,size: 20,)
            ,onPressed:  ()=>Get.back())) ,

  );
}

void showDialogFor({Function()? onPress,String? contentText,String? title}) {
 Get.dialog(
        SizedBox(
        height: 300,
        child: Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                        scrollable: true,
                        shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                        title: Text("تنبيه "+title!),
                        content: Text(contentText!,style:const TextStyle(fontSize: 14),),
                        actions: <Widget>[
                            TextButton(onPressed: ()=>Get.back(), child:const Text("إلغاء")),
                            TextButton(onPressed: onPress,child: Text(title))
                        ],

                ),
        ),
        ),
barrierDismissible: true,
);
}