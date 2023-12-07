import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/helper.dart';
import 'package:tripapp/views/abbonamento.dart';
import 'package:tripapp/views/chat_main.dart';
import 'package:tripapp/views/chat_page.dart';
import 'package:tripapp/views/home.dart';
import 'package:tripapp/views/messaggistica.dart';
import 'package:tripapp/views/notifiche.dart';
import 'package:tripapp/views/profilo_account.dart';
import 'package:tripapp/views/profilo_utente.dart';
import 'package:tripapp/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:tripapp/components/bottom_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tripapp/views/visualizza_viaggio.dart';
import 'dart:io' show Platform;

Future<void> configurePurchases() async {
  // Configura Purchases SDK all'inizio dell'app
  await Purchases.setDebugLogsEnabled(true);

  PurchasesConfiguration?
      configuration; // Utilizziamo un tipo nullable per la variabile configuration
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration("YOUR_PUBLIC_GOOGLE_API_KEY");
  } else if (Platform.isIOS) {
    configuration = PurchasesConfiguration("appl_sdpfnDXWGutBkdzTcxumiudvWkE");
  }

  if (configuration != null) {
    // Verifica se la configurazione non è nulla
    await Purchases.configure(configuration);
  } else {
    print(
        "Errore: La configurazione di Purchases non è stata impostata correttamente.");
    // Puoi gestire l'errore qui o fare altro in base alle tue esigenze.
  }
}

class MainApplication extends StatefulWidget {
  const MainApplication({super.key});

  @override
  State<MainApplication> createState() => _MainApplicationState();
}

class _MainApplicationState extends State<MainApplication> {
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  int selectedIndex = 2;

  String userId = "";
  String myUID = "";
  String? deviceToken = "";
  bool checkAbbonamento = false; //
  void atStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firebaseToken = await FirebaseMessaging.instance.getToken();

    setState(() {
      userId = prefs.getString('userId') ?? "";
      myUID = prefs.getString('UUID') ?? "";
      print("chatpage" + myUID);
      deviceToken = prefs.getString('deviceToken') ?? firebaseToken ?? "";
      prefs.setString('deviceToken', deviceToken!);
    });

    // Il controllo sull'abbonamento dovrebbe essere asincrono e all'esterno di setState
    bool checkSub = await HelperFunctions.checkAbbonamento(userId) == 'si';
    print(checkSub);
    setState(() {
      checkAbbonamento = checkSub;
    });

    await HelperFunctions.setDeviceToken(userId, deviceToken);
    await configurePurchases();
  }

  @override
  void initState() {
    super.initState();
    atStart();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      switch (message.data['type']) {
        case "viaggio":
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  VisualizzaViaggio(viaggioId: message.data['id'])));
          break;
        case "persona":
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProfiloUtente(userId: message.data['id'])));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const Settings(),
      Notifiche(
        userId: userId,
      ),
      const Home(),
      checkAbbonamento ? Messaggistica(myUID: myUID) : AbbonamentoPage(),
      ProfiloAccount(userid: userId),
      //AbbonamentoPage(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      appBar: const TripAppBar(
        hasBackButton: false,
      ),
      body: SafeArea(
        left: false,
        right: false,
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: TripBottomBar(
        currentIndex: selectedIndex,
        onClicked: onClicked,
        userId: userId,
      ),
    );
  }
}
