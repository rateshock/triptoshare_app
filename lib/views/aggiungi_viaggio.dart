import 'dart:convert';
import 'dart:typed_data';
import 'package:accordion/controllers.dart';
import 'package:accordion/accordion.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:tripapp/components/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/custom_dropdown.dart';
import 'package:tripapp/views/conferma_viaggio.dart';
import 'package:tripapp/views/login.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tripapp/views/pubblica_viaggio.dart';
import 'dart:developer';

import '../components/custom_button.dart';
import '../components/helper.dart';

class AggiungiViaggio extends StatefulWidget {
  const AggiungiViaggio({super.key});

  @override
  State<AggiungiViaggio> createState() => _AggiungiViaggioState();
}

class _AggiungiViaggioState extends State<AggiungiViaggio>
    with TickerProviderStateMixin {
  final TextEditingController _viaggioController = TextEditingController();
  final TextEditingController _descrizioneController = TextEditingController();
  final TextEditingController _inclusoController = TextEditingController();
  final TextEditingController _esclusoController = TextEditingController();
  final TextEditingController _paeseController = TextEditingController();
  final TextEditingController _destinazioneController = TextEditingController();
  final TextEditingController _linkEsterniController = TextEditingController();
  final TextEditingController _checkinDate = TextEditingController();
  final TextEditingController _checkoutDate = TextEditingController();
  final TextEditingController _prezzoController = TextEditingController();
  final TextEditingController _partecipantiController = TextEditingController();

  late TabController _tabController;

  String titoloViaggio = "";
  String descrizioneViaggio = "";
  String inclusoViaggio = "";
  String esclusoViaggio = "";
  String campagna = "no";
  String crociera = "no";
  String cultura = "no";
  String mare = "no";
  String montagna = "no";
  String ontheroad = "no";
  String paeseViaggio = "";
  String destinazioneViaggio = "";
  String linkEsterniViaggio = "";
  String regalo = "no";
  String stella = "no";
  String percentuale = "no";
  String prezzoViaggio = "";
  String partecipantiViaggio = "";
  String tipologiaViaggio = "";
  String categoriaViaggio = "";
  int _regalare = 0;
  int _stella = 0;
  int _dividere = 0;
  int _maschio = 0;
  int _femmina = 0;
  int _entrambi = 0;
  int _campagna = 0;
  int _crociera = 0;
  int _cultura = 0;
  int _mare = 0;
  int _montagna = 0;
  int _ontheroad = 0;
  String? userid = '';
  atStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('userId');
    });
  }

  @override
  void initState() {
    super.initState();
    atStart();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  static final _formKey = GlobalKey<FormState>();
  static final _luogoKey = GlobalKey<FormState>();
  static final _prezzoKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TripAppBar(hasBackButton: true),
        body: Center(
            child: Column(children: [
          GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                  child: Column(children: [
                SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Crea Annuncio',
                                  style: TextStyle(
                                      fontSize: 25,
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
                              SizedBox(
                                width: 800,
                                height:
                                    MediaQuery.of(context).size.height * 0.80,
                                child: Scaffold(
                                  appBar: AppBar(
                                    bottom: TabBar(
                                      controller: _tabController,
                                      onTap: ((value) {
                                        _tabController.animateTo(
                                            (_tabController.index = 0));
                                      }),
                                      tabs: const <Widget>[
                                        Tab(
                                          text: "Titolo",
                                        ),
                                        Tab(
                                          text: "Tipologia",
                                        ),
                                        Tab(
                                          text: "Luogo",
                                        ),
                                        Tab(
                                          text: "Prezzo",
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: _tabController,
                                    children: <Widget>[
                                      SingleChildScrollView(
                                          child: Wrap(children: [
                                        SizedBox(
                                            child: Form(
                                                key: _formKey,
                                                child: Column(children: [
                                                  Wrap(
                                                      alignment:
                                                          WrapAlignment.start,
                                                      spacing: 20,
                                                      runSpacing: 10,
                                                      children: [
                                                        const Text(
                                                          'Titolo',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return "Inserisci il titolo dell'annuncio";
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Inserisci il titolo dell'annuncio",
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .orange,
                                                                    width: 2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.0),
                                                              ),
                                                            ),
                                                            autocorrect: false,
                                                            controller:
                                                                _viaggioController,
                                                            onChanged:
                                                                (String value) {
                                                              titoloViaggio =
                                                                  value;
                                                            },
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Descrizione',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return "Inserisci la descrizione dell'annuncio";
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Inserisci la descrizione dell'annuncio",
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .orange,
                                                                    width: 2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.0),
                                                              ),
                                                            ),
                                                            autocorrect: false,
                                                            controller:
                                                                _descrizioneController,
                                                            onChanged:
                                                                (String value) {
                                                              descrizioneViaggio =
                                                                  value;
                                                            },
                                                            minLines: 3,
                                                            maxLines: 7,
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Incluso nel viaggio',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return "Indica qualcosa incluso nell'annuncio";
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Indica cosa è incluso nel viaggio (Trasporti, pasti, etc.)",
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .orange,
                                                                    width: 2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.0),
                                                              ),
                                                            ),
                                                            autocorrect: false,
                                                            controller:
                                                                _inclusoController,
                                                            onChanged:
                                                                (String value) {
                                                              inclusoViaggio =
                                                                  value;
                                                            },
                                                            minLines: 3,
                                                            maxLines: 7,
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Escluso dal viaggio',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Indica cosa è escluso dal viaggio (Trasferte, spettacoli, etc.)",
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .orange,
                                                                    width: 2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.0),
                                                              ),
                                                            ),
                                                            autocorrect: false,
                                                            controller:
                                                                _esclusoController,
                                                            onChanged:
                                                                (String value) {
                                                              esclusoViaggio =
                                                                  value;
                                                            },
                                                            minLines: 3,
                                                            maxLines: 7,
                                                          ),
                                                        ),
                                                        CustomButton(
                                                            label: "Continua",
                                                            onTap: () {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                _tabController
                                                                    .animateTo(
                                                                        (_tabController.index +
                                                                            1));
                                                              }
                                                              ;
                                                            },
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 50),
                                                      ]),
                                                ])))
                                      ])),
                                      SingleChildScrollView(
                                        child: Column(children: [
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                    width: 130,
                                                    child: Column(children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            setState(() {
                                                          if (_campagna == 0) {
                                                            _montagna = 0;
                                                            _crociera = 0;
                                                            _cultura = 0;
                                                            _mare = 0;
                                                            _campagna = 1;
                                                            _ontheroad = 0;
                                                            campagna = "si";
                                                            categoriaViaggio =
                                                                "campagna";
                                                          } else {
                                                            _campagna = 0;
                                                            campagna = "no";
                                                          }
                                                        }),
                                                        child: SvgPicture.asset(
                                                            'assets/icons/ico_alberi.svg',
                                                            height: 90,
                                                            width: 90,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            color: _campagna ==
                                                                    1
                                                                ? Colors.orange
                                                                : Colors.grey),
                                                      ),
                                                      const Text(
                                                        "Campagna",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ])),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                    width: 130,
                                                    child: Column(children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            setState(() {
                                                          if (_crociera == 0) {
                                                            _montagna = 0;
                                                            _crociera = 1;
                                                            _cultura = 0;
                                                            _mare = 0;
                                                            _campagna = 0;
                                                            _ontheroad = 0;
                                                            crociera = "si";
                                                            categoriaViaggio =
                                                                "crociera";
                                                          } else {
                                                            _crociera = 0;
                                                            crociera = "no";
                                                          }
                                                        }),
                                                        child: SvgPicture.asset(
                                                            'assets/icons/ico_nave.svg',
                                                            height: 90,
                                                            width: 90,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            color: _crociera ==
                                                                    1
                                                                ? Colors.orange
                                                                : Colors.grey),
                                                      ),
                                                      const Text(
                                                        "Crociera",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ])),
                                              ),
                                              Expanded(
                                                  child: SizedBox(
                                                width: 130,
                                                child: Column(children: [
                                                  GestureDetector(
                                                    onTap: () => setState(() {
                                                      if (_cultura == 0) {
                                                        _montagna = 0;
                                                        _crociera = 0;
                                                        _cultura = 1;
                                                        _mare = 0;
                                                        _campagna = 0;
                                                        _ontheroad = 0;
                                                        cultura = "si";
                                                        categoriaViaggio =
                                                            "cultura";
                                                      } else {
                                                        _cultura = 0;
                                                        cultura = "no";
                                                      }
                                                    }),
                                                    child: SvgPicture.asset(
                                                        'assets/icons/ico_maschere.svg',
                                                        height: 90,
                                                        width: 90,
                                                        fit: BoxFit.scaleDown,
                                                        color: _cultura == 1
                                                            ? Colors.orange
                                                            : Colors.grey),
                                                  ),
                                                  const Text(
                                                    "Cultura",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ]),
                                              )),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(children: [
                                            Expanded(
                                              child: SizedBox(
                                                  width: 130,
                                                  child: Column(children: [
                                                    GestureDetector(
                                                      onTap: () => setState(() {
                                                        if (_mare == 0) {
                                                          _montagna = 0;
                                                          _crociera = 0;
                                                          _cultura = 0;
                                                          _mare = 1;
                                                          _campagna = 0;
                                                          _ontheroad = 0;
                                                          mare = "si";
                                                          categoriaViaggio =
                                                              "mare";
                                                        } else {
                                                          _mare = 0;
                                                          mare = "no";
                                                        }
                                                      }),
                                                      child: SvgPicture.asset(
                                                          'assets/icons/ico_mare.svg',
                                                          height: 90,
                                                          width: 90,
                                                          fit: BoxFit.scaleDown,
                                                          color: _mare == 1
                                                              ? Colors.orange
                                                              : Colors.grey),
                                                    ),
                                                    const Text(
                                                      "Mare",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ])),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: 130,
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => setState(() {
                                                        if (_montagna == 0) {
                                                          _montagna = 1;
                                                          _crociera = 0;
                                                          _cultura = 0;
                                                          _mare = 0;
                                                          _campagna = 0;
                                                          _ontheroad = 0;
                                                          montagna = "si";
                                                          categoriaViaggio =
                                                              "montagna";
                                                        } else {
                                                          _montagna = 0;
                                                          montagna = "no";
                                                        }
                                                      }),
                                                      child: SvgPicture.asset(
                                                          'assets/icons/ico_triangoli.svg',
                                                          height: 90,
                                                          width: 90,
                                                          fit: BoxFit.scaleDown,
                                                          color: _montagna == 1
                                                              ? Colors.orange
                                                              : Colors.grey),
                                                    ),
                                                    const Text(
                                                      "Montagna",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: SizedBox(
                                              width: 130,
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => setState(() {
                                                      if (_ontheroad == 0) {
                                                        _montagna = 0;
                                                        _crociera = 0;
                                                        _cultura = 0;
                                                        _mare = 0;
                                                        _campagna = 0;
                                                        _ontheroad = 1;
                                                        ontheroad = "si";
                                                        categoriaViaggio =
                                                            "ontheroad";
                                                      } else {
                                                        _ontheroad = 0;
                                                        ontheroad = "no";
                                                      }
                                                    }),
                                                    child: SvgPicture.asset(
                                                        'assets/icons/ico_treno.svg',
                                                        height: 90,
                                                        width: 90,
                                                        fit: BoxFit.scaleDown,
                                                        color: _ontheroad == 1
                                                            ? Colors.orange
                                                            : Colors.grey),
                                                  ),
                                                  const Text(
                                                    "On the Road",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                          ]),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          CustomButton(
                                              label: "Continua",
                                              onTap: () {
                                                if (_mare == 0 &&
                                                    _montagna == 0 &&
                                                    _campagna == 0 &&
                                                    _cultura == 0 &&
                                                    _crociera == 0 &&
                                                    _ontheroad == 0) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          elevation: 0,
                                                          content: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(16),
                                                              height: 90,
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20))),
                                                              child: Row(
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: 48,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: const [
                                                                          Text(
                                                                              "Errore!",
                                                                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          Text(
                                                                            "Seleziona la tipologia del viaggio per poter continuare",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 12),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ]))));
                                                } else {
                                                  _tabController.animateTo(
                                                      (_tabController.index +
                                                          1));
                                                }
                                              },
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50),
                                        ]),
                                      ),
                                      SingleChildScrollView(
                                          child: Form(
                                              key: _luogoKey,
                                              child: Column(children: [
                                                Wrap(
                                                    alignment:
                                                        WrapAlignment.start,
                                                    spacing: 20,
                                                    runSpacing: 10,
                                                    children: [
                                                      const Text(
                                                        'Paese',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      SizedBox(
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Inserisci il paese di destinazione";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Inserisci il paese di destinazione",
                                                            border:
                                                                const OutlineInputBorder(),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .orange,
                                                                      width:
                                                                          2.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0),
                                                            ),
                                                          ),
                                                          autocorrect: false,
                                                          controller:
                                                              _paeseController,
                                                          onChanged:
                                                              (String value) {
                                                            paeseViaggio =
                                                                value;
                                                          },
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Destinazione',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Inserisci una destinazione";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Inserisci una destinazione",
                                                            border:
                                                                const OutlineInputBorder(),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .orange,
                                                                      width:
                                                                          2.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0),
                                                            ),
                                                          ),
                                                          autocorrect: false,
                                                          controller:
                                                              _destinazioneController,
                                                          onChanged:
                                                              (String value) {
                                                            destinazioneViaggio =
                                                                value;
                                                          },
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Link Esterni',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Inserisci link esterni",
                                                            border:
                                                                const OutlineInputBorder(),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .orange,
                                                                      width:
                                                                          2.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0),
                                                            ),
                                                          ),
                                                          autocorrect: false,
                                                          controller:
                                                              _linkEsterniController,
                                                          onChanged:
                                                              (String value) {
                                                            linkEsterniViaggio =
                                                                value;
                                                          },
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Data Check-in',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: TextFormField(
                                                            controller:
                                                                _checkinDate,
                                                            readOnly: true,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return "Inserisci una destinazione";
                                                              }
                                                              return null;
                                                            },
                                                            decoration: const InputDecoration(
                                                                icon: Icon(Icons
                                                                    .calendar_today)),
                                                            onTap: () async {
                                                              DateTime? pickedDate = await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate: DateTime
                                                                          .now()
                                                                      .add(const Duration(
                                                                          days:
                                                                              1)),
                                                                  firstDate: DateTime
                                                                          .now()
                                                                      .add(const Duration(
                                                                          days:
                                                                              1)),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2100));
                                                              if (pickedDate !=
                                                                  null) {
                                                                String
                                                                    checkinDate =
                                                                    DateFormat(
                                                                            'dd-MM-yyyy')
                                                                        .format(
                                                                            pickedDate);

                                                                setState(() {
                                                                  _checkinDate
                                                                          .text =
                                                                      checkinDate; //set output date to TextField value.
                                                                });
                                                              } else {}
                                                            }),
                                                      ),
                                                      const Text(
                                                        'Data Check-out',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: TextFormField(
                                                          controller:
                                                              _checkoutDate,
                                                          readOnly: true,
                                                          decoration:
                                                              const InputDecoration(
                                                                  icon: Icon(Icons
                                                                      .calendar_today)),
                                                          onTap: () async {
                                                            DateTime? pickedDateOut = await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate: DateTime
                                                                        .now()
                                                                    .add(const Duration(
                                                                        days:
                                                                            1)),
                                                                firstDate: DateTime
                                                                        .now()
                                                                    .add(const Duration(
                                                                        days:
                                                                            1)),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100));
                                                            if (pickedDateOut !=
                                                                null) {
                                                              String
                                                                  checkoutData =
                                                                  DateFormat(
                                                                          'dd-MM-yyyy')
                                                                      .format(
                                                                          pickedDateOut);

                                                              setState(() {
                                                                _checkoutDate
                                                                        .text =
                                                                    checkoutData; //set output date to TextField value.
                                                              });
                                                            } else {}
                                                          },
                                                          validator:
                                                              (checkoutData) {
                                                            if (checkoutData ==
                                                                    null ||
                                                                checkoutData
                                                                    .isEmpty) {
                                                              return "Inserisci una destinazione";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      CustomButton(
                                                          label: "Continua",
                                                          onTap: () {
                                                            if (_luogoKey
                                                                .currentState!
                                                                .validate()) {
                                                              _tabController.animateTo(
                                                                  (_tabController
                                                                          .index +
                                                                      1));
                                                            }
                                                            ;
                                                          },
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 50),
                                                    ]),
                                              ]))),
                                      SingleChildScrollView(
                                        child: Form(
                                            key: _prezzoKey,
                                            child: Column(children: [
                                              Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  spacing: 20,
                                                  runSpacing: 10,
                                                  children: [
                                                    const Text(
                                                      'Preferenza Viaggio',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width: 130,
                                                            child: Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        _regalare =
                                                                            1;
                                                                        _stella =
                                                                            0;
                                                                        _dividere =
                                                                            0;
                                                                        tipologiaViaggio =
                                                                            "regalare";
                                                                        regalo =
                                                                            "si";
                                                                        stella =
                                                                            "no";
                                                                        percentuale =
                                                                            "no";
                                                                        prezzoViaggio =
                                                                            "0"; // imposta il prezzo a 0
                                                                      });
                                                                      _prezzoController
                                                                              .text =
                                                                          prezzoViaggio;
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                        'assets/icons/ico_incudineregalo.svg',
                                                                        height:
                                                                            70,
                                                                        width:
                                                                            70,
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        color: _regalare ==
                                                                                1
                                                                            ? Colors.orange
                                                                            : Colors.grey),
                                                                  ),
                                                                  const Text(
                                                                    "Voglio regalare il viaggio",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        fontSize:
                                                                            14),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                ]),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width: 130,
                                                            child: Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        _regalare =
                                                                            0;
                                                                        _stella =
                                                                            1;
                                                                        _dividere =
                                                                            0;
                                                                        tipologiaViaggio =
                                                                            "gratis";

                                                                        regalo =
                                                                            "no";
                                                                        stella =
                                                                            "si";
                                                                        percentuale =
                                                                            "no";
                                                                        prezzoViaggio =
                                                                            ""; // imposta il prezzo a 0
                                                                      });
                                                                      _prezzoController
                                                                              .text =
                                                                          prezzoViaggio;
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                        'assets/icons/ico_stella1.svg',
                                                                        height:
                                                                            70,
                                                                        width:
                                                                            70,
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        color: _stella ==
                                                                                1
                                                                            ? Colors.orange
                                                                            : Colors.grey),
                                                                  ),
                                                                  const Text(
                                                                    "Voglio viaggiare Gratis",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        fontSize:
                                                                            14),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                ]),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                              width: 130,
                                                              child: Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _regalare =
                                                                              0;
                                                                          _stella =
                                                                              0;
                                                                          _dividere =
                                                                              1;
                                                                          regalo =
                                                                              "no";
                                                                          stella =
                                                                              "no";
                                                                          percentuale =
                                                                              "si";
                                                                          tipologiaViaggio =
                                                                              "dividere";
                                                                          prezzoViaggio =
                                                                              ""; // imposta il prezzo a 0
                                                                        });
                                                                        _prezzoController.text =
                                                                            prezzoViaggio;
                                                                      },
                                                                      child: SvgPicture.asset(
                                                                          'assets/icons/ico_dividere.svg',
                                                                          height:
                                                                              70,
                                                                          width:
                                                                              70,
                                                                          fit: BoxFit
                                                                              .scaleDown,
                                                                          color: _dividere == 1
                                                                              ? Colors.orange
                                                                              : Colors.grey),
                                                                    ),
                                                                    const Center(
                                                                        child:
                                                                            Text(
                                                                      "Voglio dividere le spese",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w900,
                                                                          fontSize:
                                                                              14),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )),
                                                                  ])),
                                                        ),
                                                      ],
                                                    ),
                                                    const Text(
                                                      'Prezzo',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: TextFormField(
                                                        enabled: _prezzoController
                                                                .text !=
                                                            "0", // imposta enabled a false se il prezzo è 0, altrimenti a true

                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Inserisci un prezzo";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Inserisci un prezzo",
                                                          border:
                                                              const OutlineInputBorder(),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .orange,
                                                                    width: 2.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0),
                                                          ),
                                                        ),
                                                        autocorrect: false,
                                                        controller:
                                                            _prezzoController,
                                                        onChanged:
                                                            (String value) {
                                                          prezzoViaggio = value;
                                                        },
                                                      ),
                                                    ),
                                                    const Text(
                                                      'Partecipanti',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Inserisci numero partecipanti";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Inserisci numero partecipanti",
                                                          border:
                                                              const OutlineInputBorder(),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .orange,
                                                                    width: 2.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0),
                                                          ),
                                                        ),
                                                        autocorrect: false,
                                                        controller:
                                                            _partecipantiController,
                                                        onChanged:
                                                            (String value) {
                                                          partecipantiViaggio =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                    CustomButton(
                                                        label: 'Continua',
                                                        onTap: () async {
                                                          if (_prezzoKey
                                                              .currentState!
                                                              .validate()) {
                                                            if (_regalare == 0 &&
                                                                _dividere ==
                                                                    0 &&
                                                                _stella == 0) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(
                                                                      duration: const Duration(
                                                                          seconds:
                                                                              2),
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      elevation:
                                                                          0,
                                                                      content: Container(
                                                                          padding: const EdgeInsets.all(16),
                                                                          height: 90,
                                                                          decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                          child: Row(children: [
                                                                            const SizedBox(
                                                                              width: 48,
                                                                              child: Icon(
                                                                                Icons.error,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: const [
                                                                                  Text("Errore!", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                                  Text(
                                                                                    "Seleziona una preferenza per il viaggio",
                                                                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                                                                    maxLines: 2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ]))));
                                                            } else {
                                                              //print(userid);
                                                              Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          PubblicaViaggio(
                                                                            userid:
                                                                                userid,
                                                                            titoloViaggio:
                                                                                titoloViaggio,
                                                                            descrizioneViaggio:
                                                                                descrizioneViaggio,
                                                                            inclusoViaggio:
                                                                                inclusoViaggio,
                                                                            esclusoViaggio:
                                                                                esclusoViaggio,
                                                                            categoriaViaggio:
                                                                                categoriaViaggio,
                                                                            tipologiaViaggio:
                                                                                tipologiaViaggio,
                                                                            paeseViaggio:
                                                                                paeseViaggio,
                                                                            destinazioneViaggio:
                                                                                destinazioneViaggio,
                                                                            linkEsterniViaggio:
                                                                                linkEsterniViaggio,
                                                                            regalo:
                                                                                regalo,
                                                                            stella:
                                                                                stella,
                                                                            percentuale:
                                                                                percentuale,
                                                                            prezzoViaggio:
                                                                                prezzoViaggio,
                                                                            partecipantiViaggio:
                                                                                partecipantiViaggio,
                                                                            checkinData:
                                                                                _checkinDate.text,
                                                                            checkoutData:
                                                                                _checkoutDate.text,
                                                                          )));
                                                            }
                                                          }
                                                        },
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 50),
                                                  ]),
                                            ])),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ])))
              ])))
        ])));
  }
}
