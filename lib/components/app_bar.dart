import 'package:flutter/material.dart';

class TripAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBackButton;
  const TripAppBar({
    Key? key,
    required this.hasBackButton,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: hasBackButton == true
          ? GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            )
          : null,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "Triptoshare",
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      actions: [],
    );
  }
}
