import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/custom_dropdown.dart';
import 'package:tripapp/components/helper.dart';
import 'package:tripapp/views/aggiungi_viaggio.dart';
import 'package:tripapp/views/banned.dart';
import 'package:tripapp/views/home_ricerca.dart';
import 'package:tripapp/views/login.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tripapp/components/custom_button.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userid = "";
  final initialIndex = 1;
  List<String?> tabState = ['Viaggi', 'Community'];
  var selectedIndex = 1;

  String? _selectedViaggioTipologia = "";

  final _formViaggioKey = GlobalKey<FormBuilderState>();
  final _formCommunityKey = GlobalKey<FormBuilderState>();
  final _tipologiaViaggioFieldKey = GlobalKey<FormBuilderFieldState>();
  final _condivisioneViaggioFieldKey = GlobalKey<FormBuilderFieldState>();
  final _sessoViaggioFieldKey = GlobalKey<FormBuilderFieldState>();
  final _etaViaggioFieldKey = GlobalKey<FormBuilderFieldState>();
  final _etaCommunityFieldKey = GlobalKey<FormBuilderFieldState>();
  final _sessoCommunityFieldKey = GlobalKey<FormBuilderFieldState>();
  final _condivisioneCommunityFieldKey = GlobalKey<FormBuilderFieldState>();
  bool _isUserBanned = false;

  List<String> listViaggioTipologia = [
    'Seleziona un filtro',
    'Contest',
    'Campagna',
    'Crociera',
    'Cultura',
    'Mare',
    'Montagna',
    'On The Road',
    'Indifferente'
  ];
  List<String> listViaggioCondivisione = [
    'Seleziona un filtro',
    'Regala un viaggio',
    'Viaggia gratis',
    'Dividi le spese',
    'Indifferente'
  ];
  List<String> listViaggioEta = [
    'Seleziona un filtro',
    '18-24',
    '25-34',
    '35-44',
    '45-54',
    '55-64',
    '65+',
    'Indifferente'
  ];
  List<String> listViaggioSesso = [
    'Seleziona un filtro',
    'Uomo',
    'Donna',
    'Entrambi',
    'Indifferente'
  ];

  List<String> listCommunityEta = [
    'Seleziona un filtro',
    '18-24',
    '25-34',
    '35-44',
    '45-54',
    '55-64',
    '65+',
    'Indifferente'
  ];
  List<String> listCommunitySesso = [
    'Seleziona un filtro',
    'Uomo',
    'Donna',
    'Entrambi',
    'Indifferente'
  ];
  List<String> listCommunityCondivisione = [
    'Seleziona un filtro',
    'Viaggia gratis',
    'Regala un viaggio',
    'Dividi le spese',
    'Indifferente'
  ];

  String _viaggioTipologia = "";

  atStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userid = prefs.getString('userId');
      //  print(userid);
    });
    String bannato = await HelperFunctions.isUserBanned(userid);

    setState(() {
      if (bannato == "si") {
        _isUserBanned = true;
      } else {
        _isUserBanned = false;
      }
      // print(_isUserBanned);
    });

    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
    }

    print(bannato);

    if (_isUserBanned == true) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => BannedUserPage()))
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  void initState() {
    super.initState();
    atStart();
  }

  final keyForm = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/background_homepage.jpeg'),
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.9), BlendMode.modulate),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                      child: const Text(
                    "Benvenuto su TripToShare",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w900),
                  )),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    child: Column(
                      children: [
                        tabState[selectedIndex] == 'Viaggi'
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => AggiungiViaggio()));
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Pubblica viaggio',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.white,
                                      ),
                                    ]))
                            : Text(
                                'Ricerca  ${tabState[selectedIndex]}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                DefaultTabController(
                    initialIndex: initialIndex,
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0),
                              border: const Border(
                                  bottom: BorderSide(
                                      color: Color(0xD7D7D7FF), width: 1)),
                            ),
                            child: TabBar(
                                labelColor: Colors.white,
                                unselectedLabelColor: const Color(0xD7D7D7FF),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                indicatorColor: Colors.white,
                                isScrollable: true,
                                onTap: (tappedOne) =>
                                    {setState(() => selectedIndex = tappedOne)},
                                tabs: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    child: const Tab(
                                      text: "Viaggi",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 100,
                                    child: Tab(
                                      text: "Community",
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 600,
                          child: TabBarView(children: [
                            SizedBox(
                              height: 600,
                              child: FormBuilder(
                                key: _formViaggioKey,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    CustomDropdown(
                                      selectionList: listViaggioTipologia,
                                      label: "Ricerca per tipologia",
                                      hintText: "Seleziona un filtro",
                                      formKey: _tipologiaViaggioFieldKey,
                                      name: 'tipologia',
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomDropdown(
                                      selectionList: listViaggioCondivisione,
                                      label: 'Ricerca per condivisione',
                                      hintText: 'Seleziona un filtro',
                                      formKey: _condivisioneViaggioFieldKey,
                                      name: 'condivisione',
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomDropdown(
                                      selectionList: listViaggioEta,
                                      label: 'Ricerca per eta',
                                      hintText: 'Seleziona un filtro',
                                      formKey: _etaViaggioFieldKey,
                                      name: 'eta',
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomDropdown(
                                      selectionList: listViaggioSesso,
                                      label: 'Ricerca per sesso',
                                      hintText: 'Seleziona un filtro',
                                      formKey: _sessoViaggioFieldKey,
                                      name: 'sesso',
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomButton(
                                      height: 45,
                                      width: 320,
                                      label: "Cerca",
                                      onTap: () async {
                                        var sessoViaggio = _sessoViaggioFieldKey
                                                .currentState?.value ??
                                            "";
                                        var etaViaggio = _etaViaggioFieldKey
                                                .currentState?.value ??
                                            "";
                                        var condivisioneViaggio =
                                            _condivisioneViaggioFieldKey
                                                    .currentState?.value ??
                                                "";
                                        var tipologiaViaggio =
                                            _tipologiaViaggioFieldKey
                                                    .currentState?.value ??
                                                "";

                                        /*print(
                                                  "Sesso: $sessoViaggio, Eta: $etaViaggio, Condivisione: $condivisioneViaggio, Tipologia: $tipologiaViaggio");
*/
                                        if (sessoViaggio != "" ||
                                            etaViaggio != "" ||
                                            condivisioneViaggio != "" ||
                                            tipologiaViaggio != "") {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var userId =
                                              prefs.getString('userId');
                                          var url = Uri.https('triptoshare.it',
                                              'wp-content/themes/triptoshare/methods.php');
                                          var response =
                                              await http.post(url, body: {
                                            "action": "ricerca",
                                            "userid": userid,
                                            "toggle": "viaggi",
                                            "tipologia-viaggio":
                                                tipologiaViaggio,
                                            "spese-viaggio":
                                                condivisioneViaggio,
                                            "eta-viaggio": etaViaggio,
                                            "sesso-viaggio": sessoViaggio,
                                          });
                                          /*(
                                                    "Response status code: ${response.statusCode}");
                                                print(
                                                    ;*/

                                          List<Map<String, dynamic>> idsList =
                                              List<Map<String, dynamic>>.from(
                                                  jsonDecode(response.body));
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) => HomeRicerca(
                                                        userId: userId,
                                                        idsList: idsList,
                                                        toggle: 'viaggi',
                                                      )));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 600,
                              child: FormBuilder(
                                key: _formCommunityKey,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    CustomDropdown(
                                      selectionList: listCommunityEta,
                                      label: "Ricerca per eta",
                                      hintText: "Seleziona un filtro",
                                      formKey: _etaCommunityFieldKey,
                                      name: 'eta',
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomDropdown(
                                      selectionList: listCommunitySesso,
                                      label: 'Ricerca per sesso',
                                      hintText: 'Seleziona un filtro',
                                      formKey: _sessoCommunityFieldKey,
                                      name: 'sesso',
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomDropdown(
                                      selectionList: listCommunityCondivisione,
                                      label:
                                          'Ricerca per tipologia condivisione',
                                      hintText: 'Seleziona un filtro',
                                      formKey: _condivisioneCommunityFieldKey,
                                      name: 'condivisione',
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomButton(
                                      height: 45,
                                      width: 320,
                                      label: "Cerca",
                                      onTap: () async {
                                        var sessoCommunity =
                                            _sessoCommunityFieldKey
                                                    .currentState?.value ??
                                                "";
                                        var etaCommunity = _etaCommunityFieldKey
                                                .currentState?.value ??
                                            "";
                                        var condivisioneCommunity =
                                            _condivisioneCommunityFieldKey
                                                    .currentState?.value ??
                                                "";

                                        /*print(
                                                  "Sesso: $sessoCommunity, Eta: $etaCommunity, Condivisione: $condivisioneCommunity");
*/
                                        if (sessoCommunity != "" ||
                                            etaCommunity != "" ||
                                            condivisioneCommunity != "") {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var userId =
                                              prefs.getString('userId');
                                          var url = Uri.https('triptoshare.it',
                                              'wp-content/themes/triptoshare/methods.php');
                                          var response =
                                              await http.post(url, body: {
                                            "action": "ricerca",
                                            "userid": userId,
                                            "toggle": "persone",
                                            "spese": condivisioneCommunity,
                                            "eta": etaCommunity,
                                            "sso": sessoCommunity,
                                          });
                                          /* print(
                                                    "Response status code: ${response.statusCode}");
                                                print(
                                                    "Response body: ${response.body}");*/
                                          List<Map<String, dynamic>> idsList =
                                              List<Map<String, dynamic>>.from(
                                                  jsonDecode(response.body));
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) => HomeRicerca(
                                                        userId: userId,
                                                        idsList: idsList,
                                                        toggle: 'persone',
                                                      )));
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]),
                        )
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
