import 'package:flutter/material.dart';

class TestCard extends StatefulWidget {
  const TestCard({super.key});

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, //
      width: MediaQuery.of(context).size.width - 150,
      // padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://triptoshare.it/wp-content/themes/triptoshare/user-profile-pictures/131.jpeg'),
              fit: BoxFit.cover)),
      child: Row(children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text("Nome Cognome",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text("like and subscribe",
              style: TextStyle(color: Colors.white, fontSize: 15)),
        )
      ]),
    );
  }
}
