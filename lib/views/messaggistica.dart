import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/views/banned.dart';
import 'package:tripapp/views/chat_page.dart';
import '../components/helper.dart';

class Messaggistica extends StatefulWidget {
  const Messaggistica({Key? key, required this.myUID}) : super(key: key);
  final myUID;

  @override
  State<Messaggistica> createState() => _MessaggisticaState();
}

class _MessaggisticaState extends State<Messaggistica> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatStream = Stream.empty();
  bool _isUserBanned = false;
  String? userid = "";

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchData();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('userId');
    });
    print(userid);
    chatStream = FirebaseFirestore.instance
        .collection("groups")
        .where("members", arrayContains: userid)
        .where("bloccato", isEqualTo: 0)
        .orderBy("updatedOn", descending: true)
        .snapshots();
  }

  Future<void> fetchData() async {
    String bannato = await HelperFunctions.isUserBanned(userid);

    setState(() {
      if (bannato == "si") {
        _isUserBanned = true;
      } else {
        _isUserBanned = false;
      }
    });

    if (_isUserBanned == true) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => BannedUserPage()))
          .then((value) => Navigator.pop(context));
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    print('userid $userId');
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('wpID', isEqualTo: userId)
        .get();

    if (userQuery.size > 0) {
      final userData = userQuery.docs[0].data();
      print(userData);
      return userData;
    } else {
      print('No user found with wpID: $userId');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: chatStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        print(chatStream);
        print(snapshot);
        final chatDocs = snapshot.data!.docs;
        print(chatDocs);
        if (chatDocs.isEmpty) {
          return Center(
              child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        "Non hai ancora nessuna chat attiva!",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Cerca qualche profilo per iniziare a parlare con le persone",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                      Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 30,
                      )
                    ],
                  )));
        }
        return ListView.separated(
          itemCount: chatDocs.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: Colors.grey,
              height: 1,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final chatDoc = chatDocs[index];
            final chatData = chatDoc.data();
            final chatId = chatDoc.id;
            final members = List<String>.from(chatData['members']);

            print("Members: $members");
            final otherMember =
                members.firstWhere((member) => member != userid);
            print("Other Member: $otherMember");
            return FutureBuilder(
              future: getUserData(otherMember),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center();
                }
                final userData = snapshot.data!;
                final nome = userData['nome'] ?? "";
                final cognome = userData['cognome'] ?? "";
                final wpID = userData['wpID'] ?? "";
                final fotoProfilo = userData['fotoProfilo'] ?? "";
                final lastText = chatData['lastText'] ?? [];
                String lastMessage = "";
                String lastUserId = "";
                String seen = "";
                if (lastText.isNotEmpty) {
                  lastMessage = lastText[0];
                  lastUserId = lastText[1];
                  seen = lastText[2].toString();
                }
                final lastTimestamp =
                    chatData['lastTimestamp'] ?? Timestamp.now();
                final dataString = HelperFunctions.getTimeString(lastTimestamp);
                if (nome != "") {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(fotoProfilo),
                      radius: 30,
                    ),
                    title: Text(nome + " " + cognome),
                    subtitle: lastUserId == userid
                        ? Text("Tu: $lastMessage")
                        : Text(lastMessage),
                    trailing: lastUserId != userid
                        ? seen == "0"
                            ? Icon(
                                Icons.fiber_manual_record,
                                color: Colors.orange[900],
                              )
                            : Text("")
                        : Text(""),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => singleChatPage(
                            chatID: chatId,
                            useridTO: wpID,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        );
      },
    );
  }
}
