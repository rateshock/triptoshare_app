import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripapp/views/conferma_viaggio.dart';
import '../components/app_bar.dart';

import 'package:flutter/material.dart';

import '../components/custom_button.dart';

class PubblicaViaggio extends StatefulWidget {
  const PubblicaViaggio({
    super.key,
    required this.userid,
    required this.titoloViaggio,
    required this.descrizioneViaggio,
    required this.inclusoViaggio,
    required this.esclusoViaggio,
    required this.categoriaViaggio,
    required this.tipologiaViaggio,
    required this.paeseViaggio,
    required this.destinazioneViaggio,
    required this.linkEsterniViaggio,
    required this.regalo,
    required this.stella,
    required this.percentuale,
    required this.prezzoViaggio,
    required this.partecipantiViaggio,
    required this.checkinData,
    required this.checkoutData,
  });
  final userid;
  final titoloViaggio;
  final descrizioneViaggio;
  final inclusoViaggio;
  final esclusoViaggio;
  final categoriaViaggio;
  final tipologiaViaggio;
  final paeseViaggio;
  final destinazioneViaggio;
  final linkEsterniViaggio;
  final regalo;
  final stella;
  final percentuale;
  final prezzoViaggio;
  final partecipantiViaggio;
  final checkinData;
  final checkoutData;

  @override
  State<PubblicaViaggio> createState() => _PubblicaViaggioState();
}

class _PubblicaViaggioState extends State<PubblicaViaggio> {
  final TextEditingController _etaMin = TextEditingController();
  final TextEditingController _etaMax = TextEditingController();

  int _maschio = 0;
  int _femmina = 0;
  int _entrambi = 0;
  String etaMin = "";
  String etaMax = "";
  String sessoComp = "";
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TripAppBar(hasBackButton: true),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Form(
              key: _formKey,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('Pubblica Annuncio',
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
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Mi piacerebbe viaggiare con',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: 120,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          _maschio = 1;
                                          _femmina = 0;
                                          _entrambi = 0;
                                          sessoComp = 'uomo';
                                        }),
                                        child: SvgPicture.asset(
                                            'assets/icons/ico_maschio.svg',
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.scaleDown,
                                            color: _maschio == 1
                                                ? Colors.orange
                                                : Colors.grey),
                                      ),
                                      const Text(
                                        "Uomo",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                    width: 120,
                                    child: Column(children: [
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          _maschio = 0;
                                          _femmina = 1;
                                          _entrambi = 0;
                                          sessoComp = 'donna';
                                        }),
                                        child: SvgPicture.asset(
                                            'assets/icons/ico_femmina.svg',
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.scaleDown,
                                            color: _femmina == 1
                                                ? Colors.orange
                                                : Colors.grey),
                                      ),
                                      const Text(
                                        "Donna",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ])),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 120,
                                  child: Column(children: [
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _maschio = 0;
                                        _femmina = 0;
                                        _entrambi = 1;
                                        sessoComp = 'entrambi';
                                      }),
                                      child: SvgPicture.asset(
                                          'assets/icons/ico_maschiofemmina.svg',
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.scaleDown,
                                          color: _entrambi == 1
                                              ? Colors.orange
                                              : Colors.grey),
                                    ),
                                    const Text(
                                      "Entrambi",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Età Minima',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Inserisci una età minima";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Inserisci una età minima",
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              autocorrect: false,
                              controller: _etaMin,
                              onChanged: (String value) {
                                etaMin = value;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Età Massima',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Inserisci una età massima";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Inserisci una età massima",
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              autocorrect: false,
                              controller: _etaMax,
                              onChanged: (String value) {
                                etaMax = value;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                              label: 'Pubblica',
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_maschio == 0 &&
                                      _femmina == 0 &&
                                      _entrambi == 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                                const Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            content: Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                height: 90,
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: const [
                                                        Text("Errore!",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          "Seleziona una preferenza per il viaggio",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]))));
                                  } else if (int.parse(etaMin) < 18 ||
                                      int.parse(etaMax) < 18) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                                const Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            content: Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                height: 90,
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: const [
                                                        Text("Errore!",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          "L'età non può essere inferiore a 18 anni",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]))));
                                  } else {
                                    if (int.parse(etaMax) < int.parse(etaMin)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration: const Duration(
                                                  seconds: 2),
                                              behavior: SnackBarBehavior
                                                  .floating,
                                              backgroundColor: Colors
                                                  .transparent,
                                              elevation: 0,
                                              content: Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  height: 90,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20))),
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
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Text("Errore!",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                            "L'età massima non può essere inferiore all'età minima",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]))));
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => ConfermaViaggio(
                                                  userid: widget.userid,
                                                  titoloViaggio:
                                                      widget.titoloViaggio,
                                                  descrizioneViaggio:
                                                      widget.descrizioneViaggio,
                                                  inclusoViaggio:
                                                      widget.inclusoViaggio,
                                                  esclusoViaggio:
                                                      widget.esclusoViaggio,
                                                  categoriaViaggio:
                                                      widget.categoriaViaggio,
                                                  paeseViaggio:
                                                      widget.paeseViaggio,
                                                  destinazioneViaggio: widget
                                                      .destinazioneViaggio,
                                                  linkEsterniViaggio:
                                                      widget.linkEsterniViaggio,
                                                  tipologiaViaggio:
                                                      widget.tipologiaViaggio,
                                                  prezzoViaggio:
                                                      widget.prezzoViaggio,
                                                  partecipantiViaggio: widget
                                                      .partecipantiViaggio,
                                                  checkinData:
                                                      widget.checkinData,
                                                  checkoutData:
                                                      widget.checkoutData,
                                                  sessoComp: sessoComp,
                                                  etamin: etaMin,
                                                  etamax: etaMax)));
                                    }
                                  }
                                }
                              },
                              width: 300,
                              height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
        ]));
  }
}
