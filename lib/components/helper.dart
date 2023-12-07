import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tripapp/components/bubble_text.dart';
import 'package:tripapp/components/message.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer';

class HelperFunctions {
  static Future<Map<String, dynamic>> getProfilo(String? userid) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'get-profilo',
      'userid': userid,
    });

    const JsonDecoder decoder = JsonDecoder();
    final Map<String, dynamic> object = decoder.convert(response.body);

    return object;
  }

  static Future<List<Map<String, dynamic>>> getViaggio(
      String? viaggioId) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'get-viaggio',
      'viaggioId': viaggioId,
    });

    //print(response.body);

    final List<Map<String, dynamic>> object =
        (json.decode(response.body) as List).cast();

    return object;
  }

  static Future<List<Map<String, dynamic>>> getNotifications(
      String? userId) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/method-notifiche.php');
    var response = await http.post(url, body: {
      'action': 'notificationsApp',
      'userId': userId,
    });

    final List<Map<String, dynamic>> object =
        (json.decode(response.body) as List).cast();

    return object;
  }

  static Future<String> isUserBanned(userid) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'is-banned',
      'userId': userid,
    });
    // print(response.body);
    //print("^ bannato");
    return response.body;
  }

  static Future<List<Map<String, dynamic>>> getPartecipanti(
      idViaggio, check) async {
    var url = Uri.https(
        "triptoshare.it", "wp-content/themes/triptoshare/methods-viaggio.php");
    var response = await http.post(url, body: {
      'action': 'scopri_partecipanti_app',
      'id_viaggio': idViaggio,
      'check': check,
    });

    debugPrint(response.body);
    final List<Map<String, dynamic>> partecipanti =
        (json.decode(response.body) as List).cast();
    return partecipanti;
  }

  static Future<List<Map<String, dynamic>>> getViaggiConfermati(userId) async {
    var url = Uri.https(
        "triptoshare.it", "wp-content/themes/triptoshare/methods-viaggio.php");
    var response = await http.post(url, body: {
      'action': 'getViaggiConfermati',
      'userId': userId,
    });

    final List<Map<String, dynamic>> viaggi =
        (json.decode(response.body) as List).cast();
    return viaggi;
  }

  static Future<List<Map<String, dynamic>>> getAnnunciCreati(userId) async {
    var url = Uri.https(
        "triptoshare.it", "wp-content/themes/triptoshare/methods-viaggio.php");
    var response = await http.post(url, body: {
      'action': 'getAnnunciCreati',
      'userId': userId,
    });

    final List<Map<String, dynamic>> viaggi =
        (json.decode(response.body) as List).cast();
    return viaggi;
  }

  static Future<String?> setDeviceToken(userId, deviceToken) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'registerDevice',
      'userId': userId,
      'deviceToken': deviceToken,
    });

    return response.body;
  }

  static Future<String?> removeDeviceToken(userId, deviceToken) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'unregisterDevice',
      'userId': userId,
      'deviceToken': deviceToken,
    });

    return response.body;
  }

  static Future<String?> updateUidAccount(userId, uidAccount) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'updateUidAccount',
      'userId': userId,
      'uid': uidAccount,
    });

    return response.body;
  }

  static Future<String?> sendNotificaMessaggio(userIDTo, myID) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'sendNotificaMessaggio',
      'id_da': myID,
      'id_a': userIDTo,
    });
    debugPrint(response.body);
    return response.body;
  }

  static Future<String?> sendNotificaAccettazione(
      userIDTo, myID, idViaggio) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'sendNotificaAccettazione',
      'id_da': myID,
      'id_a': userIDTo,
      'id_viaggio': idViaggio,
    });
    debugPrint(response.body);
    return response.body;
  }

  static Future<String> getUidAccount(userId) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'getUidAccount',
      'userId': userId,
    });
    //print("UIDDDDD${response.body}");
    return response.body;
  }

  static String randomStringGenerator() {
    var randomString = const Uuid().v4();
    return randomString;
  }

  static Future<void> registerUser(myUID, nome, cognome, foto, wpID) async {
    final userRef = FirebaseFirestore.instance.collection("users").doc(myUID);
    final existingUser = await userRef.get();
    String profilePicture =
        "https://triptoshare.it/wp-content/themes/triptoshare/$foto";
    if (existingUser.exists) {
      print("User already exists");
      return;
    }
    final data = <String, dynamic>{
      "UID": myUID,
      "nome": nome,
      "cognome": cognome,
      "wpID": wpID,
      "fotoProfilo": profilePicture,
      "groups": []
    };

    await userRef.set(data);
  }

  static Future<void> updateFotoProfilo(profilePicture, UID) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(UID);
      final userData = await userRef.get();

      if (userData.exists) {
        await userRef.update({'fotoProfilo': profilePicture});
      }
    } catch (e) {
      print('Error updating profile picture: $e');
    }
  }

  static Future<String> existingGroup(myuserid, useridTo) async {
    List<String> users = [myuserid, useridTo];
    String chatID = "";
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('wpID', isEqualTo: myuserid)
        .get();

    for (var doc in querySnapshot.docs) {
      List<dynamic> groups = doc.get('groups');
      var conteggio = groups.length;
      if (conteggio > 0) {
        for (var element in groups) {
          final groupSnapshot = await FirebaseFirestore.instance
              .collection('groups')
              .doc(element)
              .get();
          if (groupSnapshot.exists) {
            List<dynamic> members = groupSnapshot.get('members');
            if (members.contains(useridTo)) {
              chatID = groupSnapshot.get('id').toString();
              break; // Stop iterating over groups if a match is found
            }
          }
        }
      }
      if (chatID.isEmpty) {
        chatID = await createGroup(myuserid, useridTo);
      }
    }

    return chatID;
  }

  static Future<String> createGroup(myuserid, useridTo) async {
    final Map<String, dynamic> data = {
      "members": [myuserid, useridTo],
      "createdOn": FieldValue.serverTimestamp(),
      "id": "",
      "bloccato": 0,
    };
    String chatID = "";
    await FirebaseFirestore.instance
        .collection("groups")
        .add(data)
        .then((docRef) {
      final id = <String, String>{"id": docRef.id};

      FirebaseFirestore.instance.collection("groups").doc(docRef.id).update(id);
      updateUserGroups(docRef.id, myuserid);
      updateUserGroups(docRef.id, useridTo);
      chatID = docRef.id;
    });
    return chatID;
  }

  static Future<void> registraMessaggio(
    myUID,
    messaggio,
    chatID,
    useridTO,
    myuserid,
  ) async {
    final data = <String, dynamic>{
      "sentBy": myuserid,
      "messageText": messaggio,
      "sentAt": FieldValue.serverTimestamp(),
    };
    final messageRef = FirebaseFirestore.instance
        .collection("message")
        .doc(chatID)
        .collection("messages")
        .doc();
    await messageRef.set(data);

    // Aggiungi il campo "lastText" alla tabella "groups"
    final groupRef =
        FirebaseFirestore.instance.collection("groups").doc(chatID);
    final lastText = [messaggio, myuserid, 0];
    await groupRef.update({"lastText": lastText});
    await groupRef.update({"updatedOn": FieldValue.serverTimestamp()});
    await sendNotificaMessaggio(useridTO, myuserid);
  }

  static Future<void> updateSeen(chatID, myuserid) async {
    final groupsRef = FirebaseFirestore.instance.collection('groups');

    // ottieni il documento con il chatId specificato
    final querySnapshot = await groupsRef.where('id', isEqualTo: chatID).get();
    final docSnapshot = querySnapshot.docs.first;

    if (docSnapshot.data().containsKey('lastText')) {
      // ottieni il valore corrente dell'array "lastText"
      final lastText = List.from(docSnapshot['lastText']);
      // aggiorna il terzo valore dell'array a 1
      if (lastText[1] == myuserid) {
        lastText[2] = lastText[2];
      } else {
        lastText[2] = 1;
      }
      // aggiorna il campo "lastText" nel documento
      await docSnapshot.reference.update({'lastText': lastText});
    } else {
      return;
    }
  }

  static Future<Map<String, List<String>>> getChats(String myUID) async {
    Map<String, List<String>> groupMembers = {};

    final querySnapshot = await FirebaseFirestore.instance
        .collection("groups")
        .where("members", arrayContains: myUID)
        .orderBy("updatedOn", descending: true)
        .get();

    await Future.forEach(querySnapshot.docs, (doc) async {
      List<dynamic> members = doc.get('members');
      String chatID = doc.get('id');

      // Check if the latest message in the chat was sent after the timestamp

      members.forEach((element) {
        if (element != "null" && element != myUID) {
          // Add the member to the groupMembers map and include the chat ID
          groupMembers.putIfAbsent(element, () => []).add(chatID);
        }
      });
    });

    return groupMembers;
  }

  static Future<void> updateUserGroups(chatID, userUID) async {
    await FirebaseFirestore.instance.collection('users').doc(userUID).update({
      'groups': FieldValue.arrayUnion([chatID])
    });
  }

  static Future<void> cancellaUtenteFirebase(userUID) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .update({
          'nome': 'Utente',
          'cognome': 'Cancellato',
          'fotoProfilo':
              'https://triptoshare.it/wp-content/themes/triptoshare/user-profile-pictures/utente-cancellato.png'
        })
        .then((_) => print('Dati utente aggiornati con successo'))
        .catchError((error) =>
            print('Errore durante l\'aggiornamento dei dati: $error'));
  }

  static String getTimeString(Timestamp timeStamp) {
    final dateTime = timeStamp.toDate();
    final now = DateTime.now();
    final diffInDays = now.difference(dateTime).inDays;

    if (diffInDays == 0) {
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else if (diffInDays == 1) {
      return "Yesterday";
    } else {
      return "$diffInDays days ago";
    }
  }

  static Future<List<Message>> fetchMessagesByGroupId(
      String groupId, String myUID) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("message")
        .doc(groupId.trim())
        .collection("messages")
        .orderBy("sentAt")
        .get();

    List<Message> messages = querySnapshot.docs.map((doc) {
      return Message(
        // qui si crea un oggetto Message per ogni documento
        id: doc.id,
        sentBy: doc["sentBy"],
        messageText: doc["messageText"],
        sentAt: doc["sentAt"].toString(),
      );
    }).toList();

    return messages;
  }

  static Future<String> inviaSegnalazione(String userSegnalato,
      String? userSegnala, String motivazione, String tipologia) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'invia-segnalazione',
      'utente_segnalato': userSegnalato,
      'utente_segnala': userSegnala,
      'motivazione': motivazione,
      'tipologia': tipologia,
    });
    if (response.body == "ok") {
      return "ok";
    } else {
      return "no";
    }
  }

  static Future<String> bloccaUtente(user1, user2, uid1, uid2) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'blocca-utente',
      'user1': user1,
      'user2': user2,
    });

    // Check if the HTTP POST request was successful
    if (response.statusCode != 200) {
      return "no";
    }

    // Get a reference to the 'groups' collection in Firestore
    final groupsRef = FirebaseFirestore.instance.collection('groups');

    // Get all the chats that involve the two users
    final chats = await getChats(uid1);
    final chatIDs = chats[uid2];

    // Loop through the chat IDs and update the 'bloccato' field to 1
    if (chatIDs != null) {
      for (var chatID in chatIDs) {
        print(chatID);
        final chatDoc = await groupsRef.doc(chatID).get();
        if (chatDoc.exists) {
          final members = chatDoc.get('members');
          if (members.contains(uid1) && members.contains(uid2)) {
            await groupsRef.doc(chatID).update({'bloccato': 1});
          }
        }
      }
    }

    // Return 'ok' if everything was successful
    return "ok";
  }

  static Future<String> sendMail({
    required String email,
    required String name,
    required String description,
    required String zone,
  }) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');

    var response = await http.post(url, body: {
      'action': 'sendMail',
      'email': email,
      'name': name,
      'description': description,
      'zone': zone,
    });

    return response.body;
  }

  static Future<String> checkAbbonamento(userId) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'checkAbbonamento',
      'userid': userId,
    });
    print(response.body);
    return response.body;
  }

  static Future<String> scegliAbbonamento(userId, sceltaAbbonamento) async {
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var response = await http.post(url, body: {
      'action': 'abbonamento',
      'id_utente': userId,
      'scelta_abbonamento': sceltaAbbonamento,
    });
    print(response.body);
    return response.body;
  }
}
