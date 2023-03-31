import 'package:flutter/material.dart';
import 'dart:io';
import 'package:middleman_all/View/widgets/constant2.dart';

class ProductImage extends StatefulWidget {
  ProductImageState createState() => ProductImageState();
}

class ProductImageState extends State<ProductImage> {
  static File? imageFile;
  static String? imagePath="";

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          child:   imageFile !=null
                  ? InkWell(
                      onTap: onTap,
                      child:
                          Image.file(File(imageFile!.path), fit: BoxFit.cover))
                  : imageFile == null && imagePath == ""
                      ? Padding(
                          padding:const EdgeInsets.all(8.0),
                          child: OutlineButton(
                            onPressed: onTap,
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5), width: 1),
                            child: Icon(Icons.add_a_photo,
                                size: 80, color: Colors.grey.withOpacity(.5)),
                          ))
                      : InkWell(
                          onTap: onTap,
                          child: Image.network(
                            imagePath!,
                            fit: BoxFit.fill,
                          ))),
    );
  }

  onTap(){
    getImageFile(onFileSelected: (File file)=>setState(()=>
    imageFile = file));
  }}
