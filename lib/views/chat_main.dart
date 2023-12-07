import 'package:flutter/material.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Messaggi',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(220, 20, 60, 1),
                          Color.fromRGBO(255, 153, 0, 1)
                          //add more color here.
                        ],
                      ).createShader(
                        const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0),
                      ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [Text("qui ci vanno le chat")],
            ),
          ),
        ],
      ),
    );
  }
}
