import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();

  final String label;
  final onTap;
  final double width;
  final double height;
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox.expand(
        child: ElevatedButton(
          onPressed: widget.onTap,
          child: Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
