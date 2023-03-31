import 'package:flutter/material.dart';
class SearchField extends StatelessWidget {
  final String? lable;
  final Function(String value)? onChange;
   const SearchField({Key? key,this.onChange,this.lable}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        elevation: 2,
        color: Colors.white,
        shape: const StadiumBorder(),child: TextField(
          onChanged: (value)=>onChange!(value),
          style:const TextStyle(color: Colors.grey, fontSize: 14),
          decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: lable,
              hintStyle:const TextStyle(color: Colors.grey),
              prefixIcon:const Icon(
                Icons.search,
                color: Colors.grey,
              )),
        ),
      ),
    );
  }

}
