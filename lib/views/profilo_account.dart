//import 'package:age_calculator/age_calculator.dart';
import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripapp/components/card_viaggio.dart';
import 'package:tripapp/views/banned.dart';
import 'package:tripapp/views/chat_page.dart';
import 'package:tripapp/views/splash.dart';
import '../components/helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:accordion/accordion.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';
import 'dart:math';
import 'package:uuid/uuid.dart';

import 'login.dart';

class ProfiloAccount extends StatefulWidget {
  const ProfiloAccount({
    Key? key,
    required this.userid,
  }) : super(key: key);

  final String userid;

  @override
  State<ProfiloAccount> createState() => _ProfiloAccountState();
}

class _ProfiloAccountState extends State<ProfiloAccount>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  DateTime oggi = DateTime.now();

  String? myuserid = "";
  String? myuserUID = "";
  String firstName = "";
  String lastName = "";
  String description = "";
  String profilePictureURL = "";
  String profilePicture =
      "https://triptoshare.it/wp-content/uploads/2021/02/banner1.png";
  String sessoGenere = "";
  String dataNascitaRAW = "";
  String modalitaViaggio = "";
  String citta = "N.D.";
  String relazione = "N.D.";
  String sitsen = "N.D.";
  String letteraFin = '';
  String sessoComp = '';
  String etamin = '';
  String etamax = '';
  String iconaSesso = 'ico_maschiofemmina.svg';
  String viaggio = '';
  String toUID = '';
  String regaloState = "off";
  String dividereState = "off";
  String cuoreState = "off";
  String chatID = "";
  String instagram = "";
  String facebook = "";
  String iconaModalitaViaggio = "";
  String testoModalitaViaggio = "";
  int annoNascita = 0;
  int meseNascita = 0;
  int giornoNascita = 0;
  int anni = 0;

  var obj = {};
  List<String> sceltaViaggio = [];
  List<Map<String, dynamic>> viaggiConfermati = [];
  List<Map<String, dynamic>> annunciPersonali = [];
  final _reasonController = TextEditingController();
  bool _showError = false;
  bool _isUserBanned = false;
  atStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myuserid = prefs.getString('userId');
      myuserUID = prefs.getString('UUID');
    });
    checkIfInteractionExists(myuserid, widget.userid, 'persona-regalo')
        .then((value) {
      setState(() {
        regaloState = value;
      });
    });
    checkIfInteractionExists(myuserid, widget.userid, 'persona-dividere')
        .then((value) {
      setState(() {
        dividereState = value;
      });
    });
    checkIfInteractionExists(myuserid, widget.userid, 'persona-like')
        .then((value) {
      setState(() {
        cuoreState = value;
      });
    });
    var objTemp = await HelperFunctions.getProfilo(widget.userid);
    var objTemp1 =
        await HelperFunctions.getViaggiConfermati(widget.userid).then((value) {
      setState(() {
        viaggiConfermati = value;
      });
    });
    var objTemp2 =
        await HelperFunctions.getAnnunciCreati(widget.userid).then((value) {
      setState(() {
        annunciPersonali = value;
      });
    });
    print(objTemp);
    setState(() {
      description = objTemp["biografia"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      modalitaViaggio = objTemp["modalita_viaggio"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      switch (modalitaViaggio) {
        case "regalare":
          iconaModalitaViaggio = "ico_incudineregalo.svg";
          testoModalitaViaggio = 'Voglio regalare un viaggio';
          break;
        case "dividere":
          iconaModalitaViaggio = "ico_percentuale.svg";
          testoModalitaViaggio = "Voglio dividere un viaggio";
          break;
        case "gratis":
          iconaModalitaViaggio = "ico_stella1.svg";
          testoModalitaViaggio = "Voglio viaggiare gratis";
          break;
      }

      sessoGenere =
          objTemp["sesso"].toString().replaceAll("]", "").replaceAll("[", "");
      citta = objTemp["citta"].toString();
      sitsen =
          objTemp["sitsen"].toString().replaceAll("]", "").replaceAll("[", "");
      etamin =
          objTemp["etamin"].toString().replaceAll("]", "").replaceAll("[", "");
      etamax =
          objTemp["etamax"].toString().replaceAll("]", "").replaceAll("[", "");
      viaggio =
          objTemp["viaggio"].toString().replaceAll("]", "").replaceAll("[", "");
      sessoComp = objTemp["sessoComp"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      dataNascitaRAW = objTemp["data_nascita"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      profilePictureURL = objTemp["url_foto"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      firstName = objTemp["first_name"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      lastName = objTemp["last_name"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      instagram = objTemp["instagram"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      if (instagram == "null") {
        instagram = "";
      }
      facebook = objTemp["facebook"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      if (facebook == "null") {
        facebook = "";
      }
      toUID = objTemp["uid"].toString().replaceAll("]", "").replaceAll("[", "");

      /* Controlli su dati in modo da impostare valori predefiniti*/
      if (citta == 'null' || citta == "[]") {
        citta = "N.D.";
      } else {
        citta =
            objTemp["citta"].toString().replaceAll("]", "").replaceAll("[", "");
        citta = citta[0].toUpperCase() + citta.substring(1).toLowerCase();
      }
      if (etamin == 'null' || etamin == '[]') {
        etamin = '18';
      } else {
        etamin = etamin.replaceAll("]", "").replaceAll("[", "");
      }
      if (etamax == 'null' || etamax == '[]') {
        etamax = '99';
      } else {
        etamax = etamax.replaceAll("]", "").replaceAll("[", "");
      }
      sessoGenere =
          sessoGenere[0].toUpperCase() + sessoGenere.substring(1).toLowerCase();
      final dataNascitaSplit = dataNascitaRAW.split(RegExp(" "));
      final datanascitaSplit = dataNascitaSplit[0].split(RegExp("-"));
      if (sitsen == "no") {
        sitsen = "N.D.";
      } else if (sitsen == "sing") {
        sitsen = "Single";
      } else {
        if (sessoGenere == "Donna") {
          letteraFin = 'a';
        } else {
          letteraFin = 'o';
        }
        sitsen = "Impegnat$letteraFin";
      }
      String viaggiScelti = '';

      if (viaggio != 'null' && viaggio != '') {
        var viaggioArray = viaggio.split(',');
        if (viaggioArray[0] == 'si') {
          viaggiScelti = 'ico_alberi.svg';
          sceltaViaggio.add(viaggiScelti);
        }
        if (viaggioArray[1] == 'si') {
          viaggiScelti = 'ico_nave.svg';
          sceltaViaggio.add(viaggiScelti);
        }
        if (viaggioArray[2] == 'si') {
          viaggiScelti = 'ico_maschere.svg';
          sceltaViaggio.add(viaggiScelti);
        }
        if (viaggioArray[3] == 'si') {
          viaggiScelti = 'ico_mare.svg';
          sceltaViaggio.add(viaggiScelti);
        }
        if (viaggioArray[4] == 'si') {
          viaggiScelti = 'ico_triangoli.svg';
          sceltaViaggio.add(viaggiScelti);
        }
        if (viaggioArray[5] == 'si') {
          viaggiScelti = 'ico_treno.svg';
          sceltaViaggio.add(viaggiScelti);
        }
      } else {
        var viaggioND = 'N.D.';
      }
      annoNascita = int.tryParse(datanascitaSplit[0])!;
      meseNascita = int.tryParse(datanascitaSplit[1])!;
      giornoNascita = int.tryParse(datanascitaSplit[2])!;
      DateTime birthday = DateTime(annoNascita, meseNascita, giornoNascita);
      DateDuration duration;
      duration = AgeCalculator.age(birthday);
      anni = duration.years; // Your age is Years

      profilePicture =
          "https://triptoshare.it/wp-content/themes/triptoshare/$profilePictureURL";
      if (sessoComp != '' || sessoComp == 'null') {
        switch (sessoComp) {
          case "entrambi":
            iconaSesso = 'ico_maschiofemmina.svg';
            break;
          case "uomo":
            iconaSesso = 'ico_maschio.svg';
            break;
          case "donna":
            iconaSesso = 'ico_femmina.svg';
            break;
        }
      }
      if (myuserid == widget.userid) {
        firstName = "Il mio";
        lastName = "Profilo";
      }
      _isLoading = false;
    });
    evictImage(profilePicture);
    String bannato = await HelperFunctions.isUserBanned(myuserid);

    setState(() {
      if (bannato == "si") {
        _isUserBanned = true;
      } else {
        _isUserBanned = false;
      }
    });
    if (_isUserBanned == true) {
      Navigator.of(context)
          .pushReplacement(
              MaterialPageRoute(builder: (_) => const BannedUserPage()))
          .then((value) => Navigator.pop(context));
    }
  }

  void _launchInstagram() async {
    final url = 'https://www.instagram.com/$instagram/';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossibile aprire Instagram';
    }
  }

  void _launchFacebook() async {
    final url = 'https://www.facebook.com/$facebook/';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossibile aprire Instagram';
    }
  }

  void evictImage(url) {
    final NetworkImage provider = NetworkImage(url);
    provider.evict().then<void>((bool success) {
      if (success) debugPrint('removed image!');
    });
  }

  Future<String> checkIfInteractionExists(
      idUtente, idDaControllare, tipoLike) async {
    var url = Uri.https(
        "triptoshare.it", "wp-content/themes/triptoshare/methods-viaggio.php");
    var response = await http.post(url, body: {
      "action": "checkInteraction",
      "idUtente": idUtente,
      "idDaControllare": idDaControllare,
      "tipo": tipoLike,
    });

    //print(response.body);

    return response.body;
  }

  @override
  void initState() {
    super.initState();
    setState(() => _isLoading = true);
    atStart();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _reasonController.dispose(); // eliminazione del controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == false
        ? widget.userid == myuserid
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text('$firstName $lastName',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: <Color>[
                                          Color.fromRGBO(220, 20, 60, 1),
                                          Color.fromRGBO(255, 153, 0, 1)
                                          //add more color here.
                                        ],
                                      ).createShader(const Rect.fromLTWH(
                                          0.0, 0.0, 200.0, 100.0)))),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: () {
                                  /* Navigator.push(context,
                         MaterialPageRoute(builder: (_) {
                         return DetailScreen(String profilePictureURL);
                         }));*/
                                },
                                child: CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: NetworkImage(profilePicture),
                                  backgroundColor: Colors.transparent,
                                )),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child: InkWell(
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w900),
                          ),
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var userid = prefs.getString('userId');
                            var deviceToken =
                                await FirebaseMessaging.instance.getToken();

                            await HelperFunctions.removeDeviceToken(
                                userid, deviceToken);
                            await prefs.remove('userId').then(
                                  (value) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => const Login()),
                                  ),
                                );
                          },
                        ),
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          width: 800,
                          height: MediaQuery.of(context).size.height * 0.67,
                          child: Scaffold(
                            appBar: AppBar(
                              bottom: TabBar(
                                controller: _tabController,
                                tabs: const <Widget>[
                                  Tab(
                                    text: "Profilo",
                                  ),
                                  Tab(
                                    text: "Viaggi",
                                  ),
                                  Tab(
                                    text: "Annunci",
                                  ),
                                ],
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: Colors.black,
                              ),
                              toolbarHeight: 0,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                            body: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                SingleChildScrollView(
                                    child: Center(
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                "$sessoGenere | $anni Anni | $sitsen | $citta",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    foreground: Paint()
                                                      ..shader =
                                                          const LinearGradient(
                                                        colors: <Color>[
                                                          Color.fromRGBO(
                                                              220, 20, 60, 1),
                                                          Color.fromRGBO(
                                                              255, 153, 0, 1)
                                                          //add more color here.
                                                        ],
                                                      ).createShader(const Rect
                                                                  .fromLTWH(
                                                              0.0,
                                                              0.0,
                                                              200.0,
                                                              100.0)))),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 350.0,
                                        height: 450.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  profilePicture,
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 350,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Column(children: [
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Descrizione ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                description,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 110,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(children: [
                                            const Text(
                                              "Viaggiatore ideale",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/$iconaSesso',
                                                      height: 43,
                                                      width: 43,
                                                      fit: BoxFit.scaleDown,
                                                      color: Colors.orange),
                                                  Text(
                                                      "| $etamin - $etamax anni",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          foreground: Paint()
                                                            ..shader =
                                                                const LinearGradient(
                                                              colors: <Color>[
                                                                Color.fromRGBO(
                                                                    220,
                                                                    20,
                                                                    60,
                                                                    1),
                                                                Color.fromRGBO(
                                                                    255,
                                                                    153,
                                                                    0,
                                                                    1)
                                                                //add more color here.
                                                              ],
                                                            ).createShader(const Rect
                                                                        .fromLTWH(
                                                                    0.0,
                                                                    0.0,
                                                                    200.0,
                                                                    100.0)))),
                                                ]),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(children: [
                                            const Text(
                                              "Preferenza viaggio",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                height: 100,
                                                width: 300,
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(children: [
                                                    SvgPicture.asset(
                                                        'assets/icons/$iconaModalitaViaggio',
                                                        height: 43,
                                                        width: 43,
                                                        fit: BoxFit.scaleDown,
                                                        color: Colors.orange),
                                                    Text(
                                                      testoModalitaViaggio,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ]),
                                                ))
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(children: [
                                            const Text(
                                              "Vacanze Preferite",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 100,
                                              width: 300,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      sceltaViaggio.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return SvgPicture.asset(
                                                        'assets/icons/${sceltaViaggio[index]}',
                                                        height: 43,
                                                        width: 43,
                                                        color: Colors.orange);
                                                  }),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(children: [
                                            const Text(
                                              "Social",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                height: 100,
                                                width: 300,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: instagram != ""
                                                          ? _launchInstagram
                                                          : null,
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .instagram,
                                                        color: instagram != ""
                                                            ? Colors.orange[900]
                                                            : Colors.grey[400],
                                                        size: 35,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: facebook != ""
                                                          ? _launchFacebook
                                                          : null,
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .facebook,
                                                        color: facebook != ""
                                                            ? Colors.orange[900]
                                                            : Colors.grey[400],
                                                        size: 35,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ]),
                                )),
                                SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Accordion(
                                        openAndCloseAnimation: false,
                                        initialOpeningSequenceDelay: 0,
                                        headerBackgroundColor:
                                            Colors.orange[800],
                                        contentBorderColor: Colors.transparent,
                                        children: [
                                          AccordionSection(
                                            isOpen: false,
                                            leftIcon: const Icon(Icons.info,
                                                color: Colors.white),
                                            header: const Text(
                                              'Viaggi in attesa di conferma',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            content: SizedBox(
                                              height: 450,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    viaggiConfermati.length,
                                                itemBuilder: (context, index) {
                                                  return viaggiConfermati[index]
                                                              [
                                                              'statoConferma'] ==
                                                          'pendente'
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: CardViaggio(
                                                            viaggioId:
                                                                viaggiConfermati[
                                                                        index]
                                                                    ['id'],
                                                            titolo: viaggiConfermati[
                                                                    index][
                                                                'titolo_viaggio'],
                                                            descrizione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'descrizione_viaggio'],
                                                            sesso: viaggiConfermati[
                                                                    index][
                                                                'preferenza_sesso_partecipanti_viaggio'],
                                                            condivisione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'tipologia'],
                                                            tipologia:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'categoria_viaggio'],
                                                            dataInizio:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'data_partenza'],
                                                            dataFine:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'data_arrivo'],
                                                            prezzo: viaggiConfermati[
                                                                    index][
                                                                'costo_viaggio'],
                                                            utenteCreatore:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'first_name'],
                                                            fotoUtente:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'url_foto'],
                                                            idUtenteCreatore:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'proprietario'],
                                                            paese:
                                                                viaggiConfermati[
                                                                        index]
                                                                    ['paese'],
                                                            destinazione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'destinazione'],
                                                            fotoCopertina:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'foto_copertina'],
                                                            utenteCheVisualizza:
                                                                myuserid,
                                                          ),
                                                        )
                                                      : Container();
                                                },
                                              ),
                                            ),
                                          ),
                                          AccordionSection(
                                            isOpen: false,
                                            leftIcon: const Icon(Icons.info,
                                                color: Colors.white),
                                            header: const Text(
                                              'Viaggi confermati',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            content: SizedBox(
                                              height: 450,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    viaggiConfermati.length,
                                                itemBuilder: (context, index) {
                                                  return viaggiConfermati[index]
                                                                  [
                                                                  'statoConferma'] ==
                                                              'accettato' ||
                                                          viaggiConfermati[
                                                                      index][
                                                                  'statoConferma'] ==
                                                              'abilitato'
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: CardViaggio(
                                                            viaggioId:
                                                                viaggiConfermati[
                                                                        index]
                                                                    ['id'],
                                                            titolo: viaggiConfermati[
                                                                    index][
                                                                'titolo_viaggio'],
                                                            descrizione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'descrizione_viaggio'],
                                                            sesso: viaggiConfermati[
                                                                    index][
                                                                'preferenza_sesso_partecipanti_viaggio'],
                                                            condivisione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'tipologia'],
                                                            tipologia:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'categoria_viaggio'],
                                                            dataInizio:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'data_partenza'],
                                                            dataFine:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'data_arrivo'],
                                                            prezzo: viaggiConfermati[
                                                                    index][
                                                                'costo_viaggio'],
                                                            utenteCreatore:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'first_name'],
                                                            fotoUtente:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'url_foto'],
                                                            idUtenteCreatore:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'proprietario'],
                                                            paese:
                                                                viaggiConfermati[
                                                                        index]
                                                                    ['paese'],
                                                            destinazione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'destinazione'],
                                                            fotoCopertina:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'foto_copertina'],
                                                            utenteCheVisualizza:
                                                                myuserid,
                                                          ),
                                                        )
                                                      : Container();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                    child: Center(
                                  child: SizedBox(
                                    height: 400,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: annunciPersonali.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                            padding: EdgeInsets.all(10),
                                            child: CardViaggio(
                                                viaggioId: annunciPersonali[index]
                                                    ['id'],
                                                titolo: annunciPersonali[index]
                                                    ['titolo_viaggio'],
                                                descrizione: annunciPersonali[index]
                                                    ['descrizione_viaggio'],
                                                sesso: annunciPersonali[index][
                                                    'preferenza_sesso_partecipanti_viaggio'],
                                                condivisione: annunciPersonali[index]
                                                    ['tipologia'],
                                                tipologia: annunciPersonali[index]
                                                    ['categoria_viaggio'],
                                                dataInizio: annunciPersonali[index]
                                                    ['data_partenza'],
                                                dataFine: annunciPersonali[index]
                                                    ['data_arrivo'],
                                                prezzo: annunciPersonali[index]
                                                    ['costo_viaggio'],
                                                utenteCreatore:
                                                    annunciPersonali[index]
                                                        ['first_name'],
                                                fotoUtente: annunciPersonali[index]
                                                    ['url_foto'],
                                                idUtenteCreatore: annunciPersonali[index]['proprietario'],
                                                paese: annunciPersonali[index]['paese'],
                                                destinazione: annunciPersonali[index]['destinazione'],
                                                fotoCopertina: annunciPersonali[index]['foto_copertina'],
                                                utenteCheVisualizza: myuserid));
                                      },
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'blocca':
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text(
                                            'Blocca Utente',
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w800,
                                              foreground: Paint()
                                                ..shader = const LinearGradient(
                                                  colors: <Color>[
                                                    Color.fromRGBO(
                                                        220, 20, 60, 1),
                                                    Color.fromRGBO(
                                                        255, 153, 0, 1)
                                                  ],
                                                ).createShader(
                                                    const Rect.fromLTWH(0.0,
                                                        0.0, 200.0, 100.0)),
                                              // Colore del testo del titolo
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'Sei sicuro di voler bloccare questo utente?',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              const SizedBox(height: 20),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                          .orange[
                                                      900], // Colore di sfondo del pulsante
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  String risposta =
                                                      await HelperFunctions
                                                          .bloccaUtente(
                                                              widget.userid,
                                                              myuserid,
                                                              toUID,
                                                              myuserUID);
                                                  if (risposta == "ok") {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (_) =>
                                                          const SplashPage(
                                                        testo:
                                                            "Utente Bloccato",
                                                      ),
                                                    ));
                                                  }
                                                },
                                                child: const Text(
                                                  'Conferma',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  );
                                  break;

                                case 'segnala':
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            title: Text('Segnala utente',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w800,
                                                    foreground: Paint()
                                                      ..shader =
                                                          const LinearGradient(
                                                        colors: <Color>[
                                                          Color.fromRGBO(
                                                              220, 20, 60, 1),
                                                          Color.fromRGBO(
                                                              255, 153, 0, 1)
                                                          //add more color here.
                                                        ],
                                                      ).createShader(const Rect
                                                                  .fromLTWH(
                                                              0.0,
                                                              0.0,
                                                              200.0,
                                                              100.0)))),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TextField(
                                                  controller: _reasonController,
                                                  maxLines: 8,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Spiegaci perché stai segnalando questo utente...',
                                                  ),
                                                ),
                                                _showError == true
                                                    ? const Text(
                                                        'Devi inserire una motivazione per poter segnalare',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )
                                                    : const Text("")
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text(
                                                  'Annulla',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                          .orange[
                                                      900], // imposta il colore di sfondo
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    if (_reasonController
                                                            .text ==
                                                        "") {
                                                      _showError = true;
                                                    } else {
                                                      _showError = false;
                                                    }
                                                  });

                                                  if (_showError == false) {
                                                    String risposta =
                                                        await HelperFunctions
                                                            .inviaSegnalazione(
                                                                widget.userid,
                                                                myuserid,
                                                                _reasonController
                                                                    .text,
                                                                'persona');
                                                    if (risposta == "ok") {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (_) =>
                                                            const SplashPage(
                                                          testo:
                                                              "Segnalazione inoltrata",
                                                        ),
                                                      ));
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                    'Invia segnalazione'),
                                              ),
                                            ],
                                          );
                                        });
                                      });
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'blocca',
                                child: Text('Blocca utente'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'segnala',
                                child: Text('Segnala utente'),
                              ),
                            ],
                            child: const Icon(
                              Icons.more_vert,
                              size: 20,
                            ),
                          ),
                          Flexible(
                            child: Text('$firstName $lastName',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: <Color>[
                                          Color.fromRGBO(220, 20, 60, 1),
                                          Color.fromRGBO(255, 153, 0, 1)
                                          //add more color here.
                                        ],
                                      ).createShader(const Rect.fromLTWH(
                                          0.0, 0.0, 200.0, 100.0)))),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50)),
                          GestureDetector(
                              onTap: () {
                                /* Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                  return DetailScreen(String profilePictureURL);
                                  }));*/
                              },
                              child: CircleAvatar(
                                radius: 35.0,
                                backgroundImage: NetworkImage(profilePicture),
                                backgroundColor: Colors.transparent,
                              )),
                        ],
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          width: 800,
                          height: MediaQuery.of(context).size.height * 0.72,
                          child: Scaffold(
                            appBar: AppBar(
                              bottom: TabBar(
                                controller: _tabController,
                                tabs: const <Widget>[
                                  Tab(
                                    text: "Profilo",
                                  ),
                                  Tab(
                                    text: "Viaggi",
                                  ),
                                  Tab(
                                    text: "Annunci",
                                  ),
                                ],
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: Colors.black,
                              ),
                              toolbarHeight: 0,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                            body: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                SingleChildScrollView(
                                    child: Center(
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                "$sessoGenere | $anni Anni | $sitsen | $citta",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    foreground: Paint()
                                                      ..shader =
                                                          const LinearGradient(
                                                        colors: <Color>[
                                                          Color.fromRGBO(
                                                              220, 20, 60, 1),
                                                          Color.fromRGBO(
                                                              255, 153, 0, 1)
                                                          //add more color here.
                                                        ],
                                                      ).createShader(const Rect
                                                                  .fromLTWH(
                                                              0.0,
                                                              0.0,
                                                              200.0,
                                                              100.0)))),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 350.0,
                                        height: 450.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  profilePicture,
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 350,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Column(children: [
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Descrizione ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                description,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 110,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(children: [
                                            const Text(
                                              "Viaggiatore ideale",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/$iconaSesso',
                                                      height: 43,
                                                      width: 43,
                                                      fit: BoxFit.scaleDown,
                                                      color: Colors.orange),
                                                  Text(
                                                      "| $etamin - $etamax anni",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          foreground: Paint()
                                                            ..shader =
                                                                const LinearGradient(
                                                              colors: <Color>[
                                                                Color.fromRGBO(
                                                                    220,
                                                                    20,
                                                                    60,
                                                                    1),
                                                                Color.fromRGBO(
                                                                    255,
                                                                    153,
                                                                    0,
                                                                    1)
                                                                //add more color here.
                                                              ],
                                                            ).createShader(const Rect
                                                                        .fromLTWH(
                                                                    0.0,
                                                                    0.0,
                                                                    200.0,
                                                                    100.0)))),
                                                ]),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(children: [
                                            const Text(
                                              "Preferenza viaggio",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                height: 100,
                                                width: 300,
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(children: [
                                                    SvgPicture.asset(
                                                        'assets/icons/$iconaModalitaViaggio',
                                                        height: 43,
                                                        width: 43,
                                                        fit: BoxFit.scaleDown,
                                                        color: Colors.orange),
                                                    Text(
                                                      testoModalitaViaggio,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ]),
                                                ))
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(children: [
                                            const Text(
                                              "Vacanze Preferite",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 100,
                                              width: 300,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      sceltaViaggio.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return SvgPicture.asset(
                                                        'assets/icons/${sceltaViaggio[index]}',
                                                        height: 43,
                                                        width: 43,
                                                        color: Colors.orange);
                                                  }),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: 350,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(children: [
                                            const Text(
                                              "Social",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                height: 100,
                                                width: 300,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: instagram != ""
                                                          ? _launchInstagram
                                                          : null,
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .instagram,
                                                        color: instagram != ""
                                                            ? Colors.orange[900]
                                                            : Colors.grey[400],
                                                        size: 35,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: facebook != ""
                                                          ? _launchFacebook
                                                          : null,
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .facebook,
                                                        color: facebook != ""
                                                            ? Colors.orange[900]
                                                            : Colors.grey[400],
                                                        size: 35,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                            width: 350,
                                            height: 110,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    child: SvgPicture.asset(
                                                        'assets/icons/ico_likeregalo.svg',
                                                        height: 43,
                                                        width: 43,
                                                        color: regaloState ==
                                                                "off"
                                                            ? Colors.white
                                                            : Colors.orange),
                                                    onTap: () async {
                                                      setState(() {
                                                        regaloState =
                                                            regaloState == "on"
                                                                ? "off"
                                                                : "on";
                                                      });
                                                      var url = Uri.https(
                                                          'triptoshare.it',
                                                          'wp-content/themes/triptoshare/methods-viaggio.php');
                                                      var response = await http
                                                          .post(url, body: {
                                                        'action': 'like',
                                                        'id_utente': myuserid,
                                                        'id_like':
                                                            "r${widget.userid}",
                                                        'tipo': 'p',
                                                      });
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: SvgPicture.asset(
                                                        'assets/icons/ico_likeperc.svg',
                                                        height: 43,
                                                        width: 43,
                                                        color: dividereState ==
                                                                "off"
                                                            ? Colors.white
                                                            : Colors.orange),
                                                    onTap: () async {
                                                      setState(() {
                                                        dividereState =
                                                            dividereState ==
                                                                    "on"
                                                                ? "off"
                                                                : "on";
                                                      });
                                                      var url = Uri.https(
                                                          'triptoshare.it',
                                                          'wp-content/themes/triptoshare/methods-viaggio.php');
                                                      var response = await http
                                                          .post(url, body: {
                                                        'action': 'like',
                                                        'id_utente': myuserid,
                                                        'id_like':
                                                            "d${widget.userid}",
                                                        'tipo': 'p',
                                                      });
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: SvgPicture.asset(
                                                        'assets/icons/ico_cuore.svg',
                                                        height: 43,
                                                        width: 43,
                                                        color: cuoreState ==
                                                                "off"
                                                            ? Colors.white
                                                            : Colors.orange),
                                                    onTap: () async {
                                                      setState(() {
                                                        cuoreState =
                                                            cuoreState == "on"
                                                                ? "off"
                                                                : "on";
                                                      });
                                                      var url = Uri.https(
                                                          'triptoshare.it',
                                                          'wp-content/themes/triptoshare/methods-viaggio.php');
                                                      var response = await http
                                                          .post(url, body: {
                                                        'action': 'like',
                                                        'id_utente': myuserid,
                                                        'id_like':
                                                            "${widget.userid}",
                                                        'tipo': 'p',
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ))),
                                  ]),
                                )),
                                SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Accordion(
                                        openAndCloseAnimation: false,
                                        initialOpeningSequenceDelay: 0,
                                        headerBackgroundColor:
                                            Colors.orange[800],
                                        contentBorderColor: Colors.transparent,
                                        children: [
                                          AccordionSection(
                                            isOpen: false,
                                            leftIcon: const Icon(Icons.info,
                                                color: Colors.white),
                                            header: const Text(
                                              'Viaggi in attesa di conferma',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            content: SizedBox(
                                              height: 450,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    viaggiConfermati.length,
                                                itemBuilder: (context, index) {
                                                  return viaggiConfermati[index]
                                                              [
                                                              'statoConferma'] ==
                                                          'pendente'
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: CardViaggio(
                                                            viaggioId:
                                                                viaggiConfermati[
                                                                        index]
                                                                    ['id'],
                                                            titolo: viaggiConfermati[
                                                                    index][
                                                                'titolo_viaggio'],
                                                            descrizione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'descrizione_viaggio'],
                                                            sesso: viaggiConfermati[
                                                                    index][
                                                                'preferenza_sesso_partecipanti_viaggio'],
                                                            condivisione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'tipologia'],
                                                            tipologia:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'categoria_viaggio'],
                                                            dataInizio:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'data_partenza'],
                                                            dataFine:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'data_arrivo'],
                                                            prezzo: viaggiConfermati[
                                                                    index][
                                                                'costo_viaggio'],
                                                            utenteCreatore:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'first_name'],
                                                            fotoUtente:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'url_foto'],
                                                            idUtenteCreatore:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'proprietario'],
                                                            paese:
                                                                viaggiConfermati[
                                                                        index]
                                                                    ['paese'],
                                                            destinazione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'destinazione'],
                                                            fotoCopertina:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'foto_copertina'],
                                                            utenteCheVisualizza:
                                                                myuserid,
                                                          ),
                                                        )
                                                      : Container();
                                                },
                                              ),
                                            ),
                                          ),
                                          AccordionSection(
                                            isOpen: false,
                                            leftIcon: const Icon(Icons.info,
                                                color: Colors.white),
                                            header: const Text(
                                              'Viaggi confermati',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            content: SizedBox(
                                              height: 450,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    viaggiConfermati.length,
                                                itemBuilder: (context, index) {
                                                  return viaggiConfermati[index]
                                                                  [
                                                                  'statoConferma'] ==
                                                              'accettato' ||
                                                          viaggiConfermati[
                                                                      index][
                                                                  'statoConferma'] ==
                                                              'abilitato'
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: CardViaggio(
                                                            viaggioId:
                                                                viaggiConfermati[
                                                                        index]
                                                                    ['id'],
                                                            titolo: viaggiConfermati[
                                                                    index][
                                                                'titolo_viaggio'],
                                                            descrizione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'descrizione_viaggio'],
                                                            sesso: viaggiConfermati[
                                                                    index][
                                                                'preferenza_sesso_partecipanti_viaggio'],
                                                            condivisione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'tipologia'],
                                                            tipologia:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'categoria_viaggio'],
                                                            dataInizio:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'data_partenza'],
                                                            dataFine:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'data_arrivo'],
                                                            prezzo: viaggiConfermati[
                                                                    index][
                                                                'costo_viaggio'],
                                                            utenteCreatore:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'first_name'],
                                                            fotoUtente:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'url_foto'],
                                                            idUtenteCreatore:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'proprietario'],
                                                            paese:
                                                                viaggiConfermati[
                                                                        index]
                                                                    ['paese'],
                                                            destinazione:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'destinazione'],
                                                            fotoCopertina:
                                                                viaggiConfermati[
                                                                        index][
                                                                    'foto_copertina'],
                                                            utenteCheVisualizza:
                                                                myuserid,
                                                          ),
                                                        )
                                                      : Container();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Center(
                                    child: SizedBox(
                                      height: 450,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: annunciPersonali.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding: EdgeInsets.all(5),
                                              child: CardViaggio(
                                                  viaggioId: annunciPersonali[index]
                                                      ['id'],
                                                  titolo: annunciPersonali[index]
                                                      ['titolo_viaggio'],
                                                  descrizione: annunciPersonali[index]
                                                      ['descrizione_viaggio'],
                                                  sesso: annunciPersonali[index][
                                                      'preferenza_sesso_partecipanti_viaggio'],
                                                  condivisione: annunciPersonali[index]
                                                      ['tipologia'],
                                                  tipologia: annunciPersonali[index]
                                                      ['categoria_viaggio'],
                                                  dataInizio: annunciPersonali[index]
                                                      ['data_partenza'],
                                                  dataFine: annunciPersonali[index]
                                                      ['data_arrivo'],
                                                  prezzo: annunciPersonali[index]
                                                      ['costo_viaggio'],
                                                  utenteCreatore: annunciPersonali[index]
                                                      ['first_name'],
                                                  fotoUtente: annunciPersonali[index]
                                                      ['url_foto'],
                                                  idUtenteCreatore: annunciPersonali[index]
                                                      ['proprietario'],
                                                  paese: annunciPersonali[index]['paese'],
                                                  destinazione: annunciPersonali[index]['destinazione'],
                                                  fotoCopertina: annunciPersonali[index]['foto_copertina'],
                                                  utenteCheVisualizza: myuserid));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                minimumSize: const Size.fromHeight(150),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.zero)),
                              ),
                              onPressed: () async {
                                // print("MYUID $myuserUID");
                                //print("TUUID $toUID");
                                if (toUID != null &&
                                    toUID.isNotEmpty &&
                                    toUID != "null") {
                                  chatID = await HelperFunctions.existingGroup(
                                      myuserid, widget.userid);
                                  // print(chatID);
                                  //print("STOCAZZO");
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => singleChatPage(
                                        useridTO: widget.userid,
                                        chatID: chatID),
                                  ));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: const Text(
                                          "L'utente non ha ancora scaricato l'applicazione e non può chattare. Invitalo a chattare con te"),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.orange[900]),
                                          onPressed: () async {
                                            var url = Uri.https(
                                                'triptoshare.it',
                                                'wp-content/themes/triptoshare/methods-viaggio.php');
                                            var response =
                                                await http.post(url, body: {
                                              'action': 'like',
                                              'id_utente': myuserid,
                                              'id_like': "a${widget.userid}",
                                              'tipo': 'p',
                                            });
                                            // print(myuserid);
                                            //print(response);

                                            Navigator.of(context).pop();
                                          },
                                          child: const Center(
                                              child: Text("Invia la notifica")),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'INVIA MESSAGGIO',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: <Color>[
                                        Color.fromRGBO(220, 20, 60, 1),
                                        Color.fromRGBO(255, 153, 0, 1)
                                      ],
                                    ).createShader(const Rect.fromLTWH(
                                        0.0, 0.0, 200.0, 100.0)),
                                ),
                              ),
                            )))
                  ],
                ),
              )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ],
            ),
          );
  }
}
