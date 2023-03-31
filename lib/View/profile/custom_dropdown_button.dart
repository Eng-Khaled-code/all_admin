import 'package:flutter/material.dart';
import 'package:middleman_all/View/profile/profile_constant.dart';
class CustomDropdownButton extends StatefulWidget {

  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("اليوم",style: TextStyle(color: Colors.black54,),),
        DropdownButton<String>(
          items: <String>["السبت","الأحد","الإثنين","الثلاثاء","الأربعاء","الخميس","الجمعة"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: selectedDay,
          isExpanded: true,
          underline: Container(
            height: 1.2,
            color: Colors.black38,
          ),
          onChanged: (String? newValue) {

            setState(()=>selectedDay=newValue!);
        },


        ),
      ],
    );
  }
}
