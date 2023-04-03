import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String? text;
  final Function()? onPress;

  const CustomAlertDialog(
      {Key? key,
      @required this.title,
      @required this.text,
      @required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            title!,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("إلغاء")),
            TextButton(onPressed: onPress, child: const Text("تأكيد"))
          ],
          content: Text(
            text!,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ));
  }
}
