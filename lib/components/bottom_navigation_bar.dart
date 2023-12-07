import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';

class TripBottomBar extends StatefulWidget {
  const TripBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onClicked,
    required this.userId,
  }) : super(key: key);

  final currentIndex;
  final onClicked;
  final String? userId;

  @override
  State<TripBottomBar> createState() => _TripBottomBarState();
}

class _TripBottomBarState extends State<TripBottomBar> {
  Timer? timer;
  int counter = 0;
  int counterMessaggi = 0;

  String? myUUID = "";

  void checkForNewNotifications() async {
    var url = Uri.https("triptoshare.it",
        "/wp-content/themes/triptoshare/method-notifiche.php");
    var response = await http.post(url, body: {
      "action": "areThereNewNotifications",
      "userId": widget.userId,
    });

    setState(() {
      counter = response.body != "" ? int.parse(response.body) : counter;
    });
  }

  void checkPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myUUID = prefs.getString('UUID');
  }

  @override
  void initState() {
    super.initState();
    checkPrefs();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      checkForNewNotifications();
      checkNewMessages(myUUID);
    });
  }

  @override
  void deactivate() {
    timer?.cancel();
  }

  Future<int?> checkNewMessages(myUUID) async {
    var contatore = 0;
    if (myUUID == "") return contatore;
    //print(myUUID);
    final newMessages = await FirebaseFirestore.instance
        .collection("groups")
        .where("members", arrayContains: myUUID)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        var lastText = docSnapshot.data()['lastText'];
        if (lastText[1] != myUUID) {
          if (lastText[2] == 0) {
            contatore++;
          }
        }
      }
    });

    setState(() {
      counterMessaggi = contatore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(220, 20, 60, 1),
            Color.fromRGBO(255, 153, 0, 1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      //height: 60,
      child: BottomNavigationBar(
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/ico_impostazioni_on.svg',
              height: 30,
              width: 30,
              fit: BoxFit.scaleDown,
            ),
            icon: SvgPicture.asset(
              'assets/icons/ico_impostazioni.svg',
              height: 30,
              width: 30,
              fit: BoxFit.scaleDown,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/ico_altoparlante_on.svg',
              height: 30,
              width: 30,
              fit: BoxFit.scaleDown,
            ),
            icon: badges.Badge(
              showBadge: counter == 0 ? false : true,
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.cyan,
                borderRadius: BorderRadius.circular(4),
              ),
              position: badges.BadgePosition.topStart(top: -18, start: 18),
              child: SvgPicture.asset(
                'assets/icons/ico_altoparlante.svg',
                height: 30,
                width: 30,
                fit: BoxFit.scaleDown,
              ),
              badgeContent: Text(
                counter > 9 ? "9+" : counter.toString(),
                style: TextStyle(
                  fontSize: counter > 9 ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/ico_esplora_on.svg',
              height: 30,
              width: 30,
              fit: BoxFit.scaleDown,
            ),
            icon: SvgPicture.asset(
              'assets/icons/ico_esplora.svg',
              height: 30,
              width: 30,
              fit: BoxFit.scaleDown,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/ico_feed_on.svg',
              height: 30,
              width: 30,
              fit: BoxFit.scaleDown,
            ),
            icon: badges.Badge(
              showBadge: counterMessaggi == 0 ? false : true,
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.cyan,
                borderRadius: BorderRadius.circular(4),
              ),
              position: badges.BadgePosition.topStart(top: -18, start: 18),
              child: SvgPicture.asset(
                'assets/icons/ico_feed.svg',
                height: 30,
                width: 30,
                fit: BoxFit.scaleDown,
              ),
              badgeContent: Text(
                counterMessaggi > 9 ? "9+" : counterMessaggi.toString(),
                style: TextStyle(
                  fontSize: counterMessaggi > 9 ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/ico_donnaaccount_on.svg',
              height: 30,
              width: 30,
              fit: BoxFit.scaleDown,
            ),
            icon: SvgPicture.asset(
              'assets/icons/ico_donnaaccount.svg',
              height: 30,
              width: 30,
              fit: BoxFit.scaleDown,
            ),
            label: '',
          ),
        ],
        backgroundColor: Colors.transparent,
        currentIndex: widget.currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: widget.onClicked,
      ),
    );
  }
}
