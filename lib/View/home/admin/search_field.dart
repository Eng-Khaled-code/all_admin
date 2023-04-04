import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/helper_methods.dart';

class SearchField extends StatelessWidget {
  final String? lable;
  final Function(String value)? onChange;
  const SearchField({Key? key, this.onChange, this.lable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2,
        color: Helper.isDarkMode(context) ? Get.theme.cardColor : Colors.white,
        shape: const StadiumBorder(),
        child: TextField(
          onChanged: (value) => onChange!(value),
          style: const TextStyle(color: Colors.grey, fontSize: 14),
          decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: lable,
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              )),
        ),
      ),
    );
  }
}
