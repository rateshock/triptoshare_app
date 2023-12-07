import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class bubbleText extends StatefulWidget {
  const bubbleText({
    super.key,
    required this.listaMessaggi,
    required this.myUID,
  });

  final listaMessaggi;
  final myUID;

  @override
  State<bubbleText> createState() => _bubbleTextState();
}

class _bubbleTextState extends State<bubbleText> {
  @override
  Widget build(BuildContext context) {
    for (var c in widget.listaMessaggi.docs) {
      return Row(
        children: [Text("data")],
      );
    }
    return Container(); //
  }
}
