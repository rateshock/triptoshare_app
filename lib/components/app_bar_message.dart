import 'package:flutter/material.dart';
import 'package:tripapp/components/helper.dart';
import 'package:tripapp/views/profilo_account.dart';
import 'package:tripapp/views/profilo_utente.dart';

class TripAppBarMessage extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBackButton;
  const TripAppBarMessage({
    Key? key,
    required this.hasBackButton,
    required this.useridTo,
    required this.firstName,
    required this.lastName,
    required this.profilePictureURL,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final String useridTo;
  final String firstName;
  final String lastName;
  final String profilePictureURL;

  @override
  Widget build(BuildContext context) {
    String profilePicture =
        "https://triptoshare.it/wp-content/themes/triptoshare/$profilePictureURL";

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
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return ProfiloUtente(
                      userId: useridTo,
                    );
                  },
                ),
              );
            },
            child: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(profilePicture),
              backgroundColor: Colors.transparent,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return ProfiloUtente(userId: useridTo);
                  },
                ),
              );
            },
            child: Text(
              "$firstName $lastName",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Spacer(),
        ],
      ),
      actions: [],
    );
  }
}
