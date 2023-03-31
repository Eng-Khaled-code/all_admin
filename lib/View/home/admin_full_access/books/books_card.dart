
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Models/main_admin/book_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

class BookCard extends StatelessWidget {
 final BookModel? model;
 final AdminController? adminController;
 const BookCard({Key? key, this.model,this.adminController}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child:Column(
          children: [
            _bookTopRow(),
            _bookImage(),
          ],
        )
    );
  }

  _bookTopRow() {
    int _length=model!.name!.length;
    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){


      showReasonDialog(title:"تغيير اسم الكتاب",initialValue:model!.name ,lable: "اسم الكتاب",onPress: (name){
        Get.back();
        adminController!.operations(moduleName: "books",operationType:"update",
          usernameOrCategory:name,id:model!.id!);

      });

      },
        child: CustomText(text:model!.name!.substring(0,_length>30?30:_length),color:Colors.black,fontWeight:FontWeight.bold ,maxLine: 1),
      ),
    ),
    Row(
    children: [
    likeWidget(counter: model!.likeCount.toString(),icon: Icons.favorite,iconColor: Colors.pink),
    likeWidget(counter: model!.blackCount.toString(),icon: Icons.visibility_off,iconColor: Colors.grey),
    ],
    ),
    ],
    );
  }

 GestureDetector _bookImage() {
   return GestureDetector(
     onTapDown: (details)=> _showPopUpMenue(details),
     child:Container(
       width:double.infinity,
       height: 170,
       decoration: BoxDecoration(border: Border.all(color: primaryColor),borderRadius: BorderRadius.circular(15),image:
       DecorationImage(image: NetworkImage(model!.imageUrl!), fit: BoxFit.cover,onError: (k,l)=>Image.asset(
         "assets/images/errorimage.png",
         fit: BoxFit.fill,
       ),),
       ),

     ),);
  }


 _showPopUpMenue(TapDownDetails details) {
   final List<String> _updateTypes=["تغيير الكتاب","تغيير الصورة"];
   showMenu(
   context: Get.context!,
   position:RelativeRect.fromLTRB(
   details.globalPosition.dx,
   details.globalPosition.dy,
   details.globalPosition.dx,
   details.globalPosition.dy,),
   elevation: 3.2,
   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

   items:_updateTypes.map((String choice) {
   return PopupMenuItem(
   value: choice,
   onTap:(){
     if(choice=="تغيير الكتاب")
     {

       getBookFile(onFileSelected: (file)async{

         await adminController!.operations(moduleName:"books",operationType:"update book file",
         id:model!.id,bookFile:file,phoneOrMissedType:model!.bookUrl!.split('/').last,);

       });


     }
     else
     {
       getImageFile(
         onFileSelected: (File file)async{
           adminController!.operations(moduleName:"books",operationType:"update book image",
           id:model!.id,imageFile:file,addressOrCategoryDescription:model!.imageUrl!.split('/').last,);

         }
       );}
   },
   child:  Text(
   choice,
   style:const TextStyle(fontSize: 12),
   ),
   );
   }).toList());

 }

}