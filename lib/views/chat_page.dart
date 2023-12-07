import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripapp/components/app_bar_message.dart';
import 'package:tripapp/components/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../components/app_bar.dart';
import '../components/bubble_text.dart';
import '../provider/chat_provider.dart';
import 'login.dart';

class singleChatPage extends StatefulWidget {
  const singleChatPage({
    super.key,
    required this.useridTO,
    required this.chatID,
  });
  final String useridTO;
  final String chatID;

  @override
  State<singleChatPage> createState() => _singleChatPageState();
}

class _singleChatPageState extends State<singleChatPage> {
  List<Message> messages = [];

  ScrollController _scrollController = ScrollController();
  int lastMessageIndex = 0;
  final FocusNode focusNode = FocusNode();

  String? myuserid = "";
  String myUID = "";
  String toUID = "";
  String firstName = "";
  String lastName = "";
  String profilePictureURL = "";
  String? mioNome = "";
  bool _isLoading = false;
  bool _isBlocked = false;
  final TextEditingController textEditingController = TextEditingController();
  atStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var objTemp = await HelperFunctions.getProfilo(widget.useridTO);
    myuserid = prefs.getString('userId');
    myUID = await HelperFunctions.getUidAccount(myuserid);
    toUID = await HelperFunctions.getUidAccount(widget.useridTO);
    await HelperFunctions.updateSeen(widget.chatID, myuserid);
    setState(() {
      myuserid = myuserid;
      myUID = myUID;
      toUID = toUID;
      firstName = objTemp["first_name"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      lastName = objTemp["last_name"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      profilePictureURL = objTemp["url_foto"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
    });
    HelperFunctions.updateFotoProfilo(
        "https://triptoshare.it/wp-content/themes/triptoshare/$profilePictureURL",
        toUID);
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    setState(() => _isLoading = true);
    accountBloccato(widget.chatID).then((value) {
      print(value);
      String blocked = value;
      if (blocked == "si") {
        setState(() {
          _isBlocked = true;
        });
      }
    });

    fetchMessages();
    atStart();
  }

  Future<void> fetchMessages() async {
    List<Message> fetchedMessages =
        await HelperFunctions.fetchMessagesByGroupId(widget.chatID, myuserid!);
    setState(() {
      messages = fetchedMessages;
    });
  }

  Future<String> accountBloccato(chatID) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("groups")
        .where("id", isEqualTo: chatID)
        .get();
    if (querySnapshot.docs[0]['bloccato'] == 0) {
      return "no";
    } else {
      return "si";
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == false
        ? _isBlocked == false
            ? Scaffold(
                appBar: TripAppBarMessage(
                  useridTo: widget.useridTO,
                  firstName: firstName,
                  lastName: lastName,
                  profilePictureURL: profilePictureURL,
                  hasBackButton: true,
                ),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("message")
                            .doc(widget.chatID.trim())
                            .collection("messages")
                            .orderBy("sentAt", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text(
                                'Si è verificato un errore durante il recupero dei messaggi');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          messages = snapshot.data!.docs
                              .map((doc) => Message(
                                    id: doc.id,
                                    sentBy: doc["sentBy"],
                                    messageText: doc["messageText"],
                                    sentAt: doc["sentAt"].toString(),
                                  ))
                              .toList();
                          if (!messages.isEmpty) {
                            if (messages.last.sentBy != myuserid) {
                              HelperFunctions.updateSeen(
                                  widget.chatID, myuserid);
                            }
                          }
                          accountBloccato(widget.chatID).then((value) {
                            String blocked = value;
                            if (blocked == "si") {
                              setState(() {
                                _isBlocked = true;
                              });
                            }
                          });
                          if (_isBlocked) {
                            return const Text(
                                'Sei stato bloccato in questa chat');
                          } else {
                            return ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: messages.length,
                              controller: _scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                final message = messages[index];
                                final bool isMe = message.sentBy == myuserid;

                                return Column(
                                  crossAxisAlignment: isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: isMe
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: isMe
                                                    ? const Color.fromARGB(
                                                        255, 255, 123, 0)
                                                    : Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    message.messageText,
                                                    style: TextStyle(
                                                      color: isMe
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.5)),
                              color: Colors.white),
                          child: Row(
                            children: <Widget>[
                              // Button send image

                              // Edit text
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextField(
                                    onSubmitted: (value) {
                                      setState(() {
                                        textEditingController.text = value;
                                      });
                                    },
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                    controller: textEditingController,
                                    decoration: const InputDecoration.collapsed(
                                      hintText: 'Scrivi messaggio...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    focusNode: focusNode,
                                    autofocus: false,
                                  ),
                                ),
                              ),

                              // Button send message
                              Material(
                                color: Colors.white,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () {
                                      HelperFunctions.registraMessaggio(
                                          myUID,
                                          textEditingController.text,
                                          widget.chatID,
                                          widget.useridTO,
                                          myuserid);
                                      messages.add(Message(
                                        id: '',
                                        sentBy: myuserid!,
                                        messageText: textEditingController.text,
                                        sentAt: DateTime.now().toString(),
                                      ));
                                      textEditingController.clear();
                                    },
                                    color:
                                        const Color.fromARGB(255, 255, 123, 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Scaffold(
                appBar: TripAppBar(hasBackButton: true),
                body: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.warning_amber_rounded, size: 72),
                        SizedBox(height: 16),
                        Text(
                          "Sei stato bloccato",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Non puoi più accedere a questa chat.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    )))
        : Container(
            color: Colors.white,
            child: const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 255, 123, 0),
            )));
  }
}
