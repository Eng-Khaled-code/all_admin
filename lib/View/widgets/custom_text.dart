import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constant.dart';

class CustomText extends StatefulWidget {
  final String text;

  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final Color color;

  final Alignment alignment;

  final int? maxLine;

  const CustomText(
      {Key? key,
      this.text = '',
      this.fontSize = 14,
      this.color = primaryColor,
      this.alignment = Alignment.center,
      this.maxLine = 2,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText>
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
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment,
      child: Opacity(
        opacity: _controller!.value,
        child: Text(
          widget.text,
          textAlign: widget.textAlign,
          overflow: TextOverflow.ellipsis,
          maxLines: widget.maxLine,
          style: TextStyle(
            color: widget.color,
            fontWeight: widget.fontWeight,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    );
  }
}
