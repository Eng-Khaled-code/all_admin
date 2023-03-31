import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final List<Color>? color;
  final String? text;
  final Function()? onPress;
  final Color? textColor;
  final double? width;
  CustomButton(
      {@required this.color,
      @required this.text,
      required this.onPress,
      @required this.textColor,
      this.width=double.infinity});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}


class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {


  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
seconds: 1
      ),
      lowerBound: 0.0,
      upperBound: 1.0,
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

    return GestureDetector(
      onTap: widget.onPress,
      child: Opacity(
        opacity: _controller!.value,
        child: Container(
         padding: const EdgeInsets.all(10),
          width: widget.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.color![0], widget.color![1]]),

              borderRadius: BorderRadius.circular(20.0)),
          child: Center(
            child: Text(
              widget.text!,
              textAlign: TextAlign.center,
              style: TextStyle(color: widget.textColor, fontSize: 14.0),
            ),
          ),
        ),
      ),
    );
  }
}
