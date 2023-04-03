import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'constant.dart';

class CustomTextField extends StatefulWidget {
  final String? lable;
  final Color? color;
  final Function(String value)? onSave;
  final Function()? onTap;

  final String? initialValue;
  const CustomTextField({
    Key? key,
    @required this.lable,
    @required this.onSave,
    @required this.initialValue,
    this.onTap,
    this.color = primaryColor,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
      lowerBound: 0,
      upperBound: 1,
    )..addListener(() {
        setState(() {});
      });
    _controller!.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  bool hidePass = true;
  IconData hidePassIcon = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    IconData icon = widget.lable == "الإيميل"
        ? Icons.mail
        : widget.lable == "اسم المنتج"
            ? Icons.shopping_basket
            : widget.lable == "كلمة المرور"
                ? Icons.lock
                : widget.lable == "العنوان"
                    ? Icons.add_location
                    : widget.lable == "المساحة بالمتر المربع"
                        ? Icons.ac_unit
                        : widget.lable == "سعر المتر" || widget.lable == "السعر"
                            ? Icons.money
                            : widget.lable == "عدد الطوابق" ||
                                    widget.lable == "رقم الطابق" ||
                                    widget.lable == "الكمية"
                                ? Icons.confirmation_number
                                : widget.lable == "رقم التليفون"
                                    ? Icons.call
                                    : widget.lable == "السؤال"
                                        ? Icons.question_mark
                                        : widget.lable == "الاسم"
                                            ? Icons.person
                                            : widget.lable == "الوحدة"
                                                ? Icons.ac_unit
                                                : widget.lable == "القسم"
                                                    ? Icons.category
                                                    : widget.lable ==
                                                            "اسم الكتاب"
                                                        ? CupertinoIcons.book
                                                        : widget.lable ==
                                                                    "العرض" ||
                                                                widget.lable ==
                                                                    "نسبة الخصم"
                                                            ? Icons.money_off
                                                            : Icons.description;

    TextInputType inputeType = widget.lable == "كلمة المرور"
        ? TextInputType.emailAddress
        : widget.lable == "سعر المتر" ||
                widget.lable == "المساحة بالمتر المربع" ||
                widget.lable == "السعر" ||
                widget.lable == "نسبة الخصم"
            ? const TextInputType.numberWithOptions(decimal: true)
            : widget.lable == "عدد الطوابق" ||
                    widget.lable == "رقم الطابق" ||
                    widget.lable == "الكمية"
                ? TextInputType.number
                : widget.lable == "رقم التليفون"
                    ? TextInputType.phone
                    : TextInputType.text;

    return Opacity(
      opacity: _controller!.value,
      child: TextFormField(
        onTap: () => widget.onTap ?? () {},
        initialValue: widget.initialValue,
        readOnly: widget.lable == "العنوان",
        maxLines: widget.lable == "تفاصيل اكثر" ||
                widget.lable == "العنوان" ||
                widget.lable == "السؤال"
            ? 3
            : widget.lable == "الشرح"
                ? 8
                : 1,
        keyboardType: inputeType,
        obscureText: widget.lable == "كلمة المرور" ? hidePass : false,
        onSaved: (value) => widget.onSave!(value!),
        validator: (value) {
          bool isNumeric(String s) {
            if (s == null) {
              return false;
            }
            return double.tryParse(s) != null;
          }

          bool isInteger(String s) {
            if (s == null) {
              return false;
            }
            return double.tryParse(s) != null && !s.contains('.');
          }

          bool phoneValidate = (value!.startsWith("011") ||
                  value.startsWith("012") ||
                  value.startsWith("010") ||
                  value.startsWith("015")) &&
              isNumeric(value) &&
              value.length == 11;
          if (value.isEmpty) {
            return "من فضلك إدخل " + widget.lable!;
          } else if (widget.lable == "الإيميل" &&
              GetUtils.isEmail(value) == false) {
            return "الإيميل غير صحيح";
          } else if (widget.lable == "كلمة المرور" && value.length < 8) {
            return "كلمة المرور يجب الا تقل عن ثمانية احرف";
          } else if ((widget.lable == "عدد الطوابق" ||
                  widget.lable == "رقم الطابق" ||
                  widget.lable == "الكمية") &&
              isInteger(value) == false) {
            return "من فضلك إدخل رقم";
          } else if ((widget.lable == "سعر المتر" ||
                  widget.lable == "السعر" ||
                  widget.lable == "نسبة الخصم") &&
              isNumeric(value) == false) {
            return "من فضلك إدخل قيمة";
          } else if (widget.lable == "المساحة بالمتر المربع" &&
              isNumeric(value) == false) {
            return "من فضلك إدخل رقم";
          } else if (widget.lable == "رقم التليفون" && !phoneValidate) {
            return "رقم التليفون غير صحيح";
          } else if (widget.lable == "نسبة الخصم" &&
              (double.tryParse(value)! > 80)) {
            return "لا يجب ان تزيد نسبة الخصم عن 80 بالمئه";
          }
        },
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * .04),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(icon),
          ),
          suffixIcon: widget.lable == "كلمة المرور"
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    icon: Icon(hidePassIcon),
                    onPressed: () {
                      setState(() {
                        if (hidePass) {
                          hidePass = false;
                          hidePassIcon = Icons.visibility;
                        } else {
                          hidePass = true;
                          hidePassIcon = Icons.visibility_off;
                        }
                      });
                    },
                  ),
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          labelText: widget.lable,
          labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * .035,
          ),
        ),
      ),
    );
  }
}
