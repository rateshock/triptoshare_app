import 'dart:ffi';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:tripapp/components/custom_button.dart';
import 'package:tripapp/views/chat_page.dart';
import 'package:tripapp/views/profilo_utente.dart';
import 'package:tripapp/views/splash.dart';
import 'package:http/http.dart' as http;
import 'package:tripapp/components/card_partecipante.dart';
import 'package:tripapp/components/helper.dart';

import 'package:intl/intl.dart';

class VisualizzaViaggio extends StatefulWidget {
  const VisualizzaViaggio({
    Key? key,
    required this.viaggioId,
  });

  final String viaggioId;

  @override
  State<VisualizzaViaggio> createState() => _VisualizzaViaggioState();
}

class _VisualizzaViaggioState extends State<VisualizzaViaggio> {
  bool _isLoading = false;
  bool isLoading = false;
  bool _isModalLoading = false;

  final kInnerDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(15),
  );

  final kGradientBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(colors: [Colors.red, Colors.orange]),
    border: Border.all(
      color: Colors.white,
    ),
    borderRadius: BorderRadius.circular(15),
  );
  var obj;
  String cuoreState = "off";

  String idViaggio = '301';
  String? myuserid = "";
  String proprietario = "";
  String titolo = "";
  String descrizione = "";
  String dataPartenza = "";
  String dataArrivo = "";
  String categoriaViaggio = "";
  String preferenzaSesso = "";
  String tipologia = "";
  String costoViaggio = "";
  String fotoCopertina = "";
  String paese = "";
  String destinazione = "";
  String fotoUtente = "";
  String nomeUtente = "";
  String profilePicture = "";
  String iconaViaggio = "";
  String dataViaggio = "";
  String tipologiaViaggio = "";
  String iconaTipologia = "";
  String nrPartecipanti = "";
  String inclusoViaggio = "";
  String esclusoViaggio = "";
  String etaMinPartecipanti = "";
  String etaMaxPartecipanti = "";
  String paeseDestinazione = "";
  String prezzoViaggio = "";
  String frasePrezzo = "";
  String check = "no";
  String stato = "";
  String postiDisponibili = "0";
  String likeato = "no";
  String toUID = "";
  String responseRichiesta = "";
  String? myuserUID = "";
  int endTimer = 0;

  List<Map<String, dynamic>> partecipanti = [];
  final _reasonController = TextEditingController();
  bool _showError = false;
  void atStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var objTemp = await HelperFunctions.getViaggio(widget.viaggioId);

    setState(() {
      myuserid = prefs.getString('userId');
      myuserUID = prefs.getString('UUID');

      obj = objTemp;

      proprietario = objTemp[0]["proprietario"].toString();
      titolo = objTemp[0]["titolo_viaggio"].toString();
      descrizione = objTemp[0]["descrizione_viaggio"].toString();
      dataPartenza = objTemp[0]["data_partenza"].toString();
      dataArrivo = objTemp[0]["data_arrivo"].toString();
      categoriaViaggio = objTemp[0]["categoria_viaggio"].toString();
      preferenzaSesso =
          objTemp[0]["preferenza_sesso_partecipanti_viaggio"].toString();
      tipologia = objTemp[0]["tipologia"].toString();
      costoViaggio = objTemp[0]["costo_viaggio"].toString();
      fotoCopertina = objTemp[0]["foto_copertina"]
          .toString()
          .replaceAll('_trip_dir', 'assets');
      paese = objTemp[0]["paese"].toString();
      destinazione = objTemp[0]["destinazione"].toString();
      fotoUtente = objTemp[0]["url_foto"].toString();
      nomeUtente = objTemp[0]["first_name"].toString();
      nrPartecipanti = objTemp[0]["nrPartecipanti"].toString();
      inclusoViaggio = objTemp[0]["inclusoViaggio"].toString();
      esclusoViaggio = objTemp[0]["esclusoViaggio"].toString();
      etaMinPartecipanti = objTemp[0]["minPartecipanti"].toString();
      etaMaxPartecipanti = objTemp[0]["maxPartecipanti"].toString();
      profilePicture =
          'https://triptoshare.it/wp-content/themes/triptoshare/$fotoUtente';
      print(profilePicture);
      List<Map<String, dynamic>> partecipanti = [];

// Funzione per ottenere la lista dei partecipanti

      check = myuserid == proprietario ? "si" : "no";

      switch (categoriaViaggio) {
        case "crociera":
          iconaViaggio = "ico_nave.svg";
          break;
        case "mare":
          iconaViaggio = "ico_mare.svg";
          break;
        case "cultura":
          iconaViaggio = "ico_maschere.svg";
          break;
        case "montagna":
          iconaViaggio = "ico_triangoli.svg";
          break;
        case "ontheroad":
          iconaViaggio = "ico_treno.svg";
          break;
        case "campagna":
          iconaViaggio = "ico_alberi.svg";
          break;
        case "contest":
          iconaViaggio = "ico_aeroplanodicarta.svg";
          break;
      }
      var a_partenza = dataPartenza.split('-');
      String annoPartenza = a_partenza[0];
      String mesePartenza = a_partenza[1];
      String giornoPartenza = a_partenza[2];
      var a_arrivo = dataArrivo.split('-');
      String annoArrivo = a_arrivo[0];
      String meseArrivo = a_arrivo[1];
      String giornoArrivo = a_arrivo[2];

      dataViaggio =
          "$giornoPartenza/$mesePartenza/$annoPartenza - $giornoArrivo/$meseArrivo/$annoArrivo";
      switch (tipologia) {
        case "gratis":
          tipologiaViaggio = "Viaggio da Offrire";
          iconaTipologia = "ico_stella1.svg";
          prezzoViaggio = costoViaggio;
          frasePrezzo = "per offrire il viaggio*";
          break;
        case "regalare":
          tipologiaViaggio = "Viaggio Offerto";
          iconaTipologia = "ico_incudineregalo.svg";
          prezzoViaggio = "Viaggio Offerto";
          frasePrezzo = "";
          break;
        case "dividere":
          tipologiaViaggio = "Pagamento Condiviso";
          iconaTipologia = "ico_percentuale.svg";
          int costoaPersona =
              (int.parse(costoViaggio) / int.parse(nrPartecipanti)).ceil();
          prezzoViaggio = "$costoaPersona €";
          frasePrezzo = "ognuno paga per sè*";
          break;
      }
      preferenzaSesso = preferenzaSesso[0].toUpperCase() +
          preferenzaSesso.substring(1).toLowerCase();

      paeseDestinazione =
          "${destinazione[0].toUpperCase()}${destinazione.substring(1).toLowerCase()}, ${paese[0].toUpperCase()}${paese.substring(1).toLowerCase()}";
      int giornoPartMeno = int.parse(giornoPartenza) - 1;
      endTimer = DateTime(int.parse(annoPartenza), int.parse(mesePartenza),
                  giornoPartMeno)
              .millisecondsSinceEpoch +
          1000 * 30;
      //endTimer = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
      // myuserid = "2";
      _isLoading = false;
      print(endTimer);
    });
    var url = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods-viaggio.php');
    var response = await http.post(url, body: {
      'action': 'nrPartecipanti',
      'id_viaggio': widget.viaggioId,
    });

    String? nrPartecipantiAttuali = response.body;
    int postiDisponibilinr =
        int.parse(nrPartecipanti) - int.parse(nrPartecipantiAttuali);

    var urlLike = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
    var responseLike = await http.post(urlLike, body: {
      'action': 'like-a-viaggio',
      'id_soggetto': myuserid,
      'id_viaggio': widget.viaggioId,
    });
    if (check == "no") {
      String toUID = await HelperFunctions.getUidAccount(proprietario);
    }
    var urlRichiedi = Uri.https(
        'triptoshare.it', 'wp-content/themes/triptoshare/methods-viaggio.php');
    var responseRichiedi = await http.post(urlRichiedi, body: {
      'action': 'richiestaEffettuata',
      'id_viaggio': widget.viaggioId,
      'id_utente': myuserid,
    });
    setState(() {
      postiDisponibili = postiDisponibilinr.toString();
      likeato = responseLike.body;
      toUID = toUID;
      responseRichiesta = responseRichiedi.body;
    });
    print(nrPartecipantiAttuali);
  }

  @override
  void initState() {
    super.initState();

    setState(() => _isLoading = true);

    atStart();

    Future.delayed(const Duration(milliseconds: 500), () {
      getPartecipanti();
    });
  }

  Future<void> getPartecipanti() async {
    // Recupera i partecipanti dal tuo servizio o da qualsiasi altra fonte
    // e assegna i dati all'array partecipanti
    partecipanti =
        await HelperFunctions.getPartecipanti(widget.viaggioId, check);
  }

  Widget buildPartecipantiList() {
    if (partecipanti.isEmpty) {
      return Center(
        child: Text(
          'Nessuna richiesta presente.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: partecipanti.length,
      itemBuilder: (context, index) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void setStatoCard(stato) {
              setState(() {
                partecipanti[index]['stato'] = stato;
              });
            }

            return CardPartecipante(
              key: UniqueKey(),
              callback: setStatoCard,
              idPartecipante: partecipanti[index]['id_utente'],
              idViaggio: widget.viaggioId,
              fotoPartecipante: partecipanti[index]['url_foto'],
              nomePartecipante: partecipanti[index]['first_name'],
              userId: myuserid,
              idCreatoreViaggio: proprietario,
              stato: partecipanti[index]['stato'],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TripAppBar(hasBackButton: true),
        body: _isLoading == false
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  Stack(
                    children: [
                      Image.asset(fotoCopertina,
                          height: 180, width: 800, fit: BoxFit.fitWidth),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.65,
                        top: 140,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    ProfiloUtente(userId: proprietario)));
                          },
                          child: CircleAvatar(
                            radius: 45.0,
                            backgroundImage: NetworkImage(profilePicture),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 190,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 300,
                                          child: Text(
                                            titolo[0].toUpperCase() +
                                                titolo
                                                    .substring(1)
                                                    .toLowerCase(),
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w900,
                                              foreground: Paint()
                                                ..shader = const LinearGradient(
                                                  colors: <Color>[
                                                    Color.fromRGBO(
                                                        220, 20, 60, 1),
                                                    Color.fromRGBO(
                                                        255, 153, 0, 1)
                                                    //add more color here.
                                                  ],
                                                ).createShader(
                                                  const Rect.fromLTWH(
                                                      0.0, 0.0, 200.0, 100.0),
                                                ),
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            switch (value) {
                                              case 'segnala':
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Segnala utente',
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  foreground:
                                                                      Paint()
                                                                        ..shader =
                                                                            const LinearGradient(
                                                                          colors: <
                                                                              Color>[
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
                                                                        ).createShader(const Rect.fromLTWH(
                                                                                0.0,
                                                                                0.0,
                                                                                200.0,
                                                                                100.0)))),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              TextField(
                                                                controller:
                                                                    _reasonController,
                                                                maxLines: 8,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  hintText:
                                                                      'Spiegaci perché stai segnalando questo viaggio...',
                                                                ),
                                                              ),
                                                              _showError == true
                                                                  ? const Text(
                                                                      'Devi inserire una motivazione per poter segnalare',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    )
                                                                  : const Text(
                                                                      "")
                                                            ],
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                              child: const Text(
                                                                'Annulla',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.orange[
                                                                        900], // imposta il colore di sfondo
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                setState(() {
                                                                  if (_reasonController
                                                                          .text ==
                                                                      "") {
                                                                    _showError =
                                                                        true;
                                                                  } else {
                                                                    _showError =
                                                                        false;
                                                                  }
                                                                });

                                                                if (_showError ==
                                                                    false) {
                                                                  String risposta = await HelperFunctions.inviaSegnalazione(
                                                                      widget
                                                                          .viaggioId,
                                                                      myuserid,
                                                                      _reasonController
                                                                          .text,
                                                                      'viaggio');
                                                                  if (risposta ==
                                                                      "ok") {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                            MaterialPageRoute(
                                                                      builder:
                                                                          (_) =>
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
                                            /*const PopupMenuItem<String>(
                                              value: 'blocca',
                                              child: Text('Blocca utente'),
                                            ),*/
                                            const PopupMenuItem<String>(
                                              value: 'segnala',
                                              child: Text('Segnala viaggio'),
                                            ),
                                          ],
                                          child: const Icon(
                                            Icons.more_horiz,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            LinearGradientMask(
                                              child: SvgPicture.asset(
                                                  'assets/icons/$iconaViaggio',
                                                  height: 35,
                                                  width: 35,
                                                  color: Colors.orange),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              categoriaViaggio[0]
                                                      .toUpperCase() +
                                                  categoriaViaggio
                                                      .substring(1)
                                                      .toLowerCase(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            LinearGradientMask(
                                              child: SvgPicture.asset(
                                                  'assets/icons/ico_posizione.svg',
                                                  height: 35,
                                                  width: 35,
                                                  color: Colors.orange),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: Text(
                                                paeseDestinazione,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            LinearGradientMask(
                                              child: SvgPicture.asset(
                                                  'assets/icons/ico_calendario.svg',
                                                  height: 35,
                                                  width: 35,
                                                  color: Colors.orange),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              dataViaggio,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3, bottom: 3),
                                                child: LinearGradientMask(
                                                  child: SvgPicture.asset(
                                                      'assets/icons/$iconaTipologia',
                                                      height: 25,
                                                      width: 25,
                                                      fit: BoxFit.scaleDown,
                                                      color: Colors.orange),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              tipologiaViaggio,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            LinearGradientMask(
                                              child: SvgPicture.asset(
                                                  'assets/icons/ico_people.svg',
                                                  height: 35,
                                                  width: 35,
                                                  color: Colors.orange),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Viaggio di gruppo (x$nrPartecipanti)",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Posti disponibili: $postiDisponibili",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    foreground: Paint()
                                                      ..shader =
                                                          const LinearGradient(
                                                        colors: <Color>[
                                                          Color.fromRGBO(
                                                              220, 20, 60, 1),
                                                          Color.fromARGB(
                                                              255, 255, 119, 0)
                                                          //add more color here.
                                                        ],
                                                      ).createShader(
                                                        const Rect.fromLTWH(0.0,
                                                            0.0, 200.0, 100.0),
                                                      ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                CustomButton(
                                                  width: 300,
                                                  height: 50,
                                                  label:
                                                      "SCOPRI I PARTECIPANTI",
                                                  onTap: () async {
                                                    showModalBottomSheet(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: 350.0,
                                                          color: Colors
                                                              .transparent,
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        30.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        30.0),
                                                              ),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  height: 3,
                                                                  width: 100,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            20),
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        myuserid ==
                                                                                proprietario
                                                                            ? Text(
                                                                                'Richieste',
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.w900,
                                                                                  foreground: Paint()
                                                                                    ..shader = const LinearGradient(
                                                                                      colors: <Color>[
                                                                                        Color.fromRGBO(220, 20, 60, 1),
                                                                                        Color.fromARGB(255, 255, 119, 0),
                                                                                      ],
                                                                                    ).createShader(
                                                                                      const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0),
                                                                                    ),
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                'Partecipanti',
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.w900,
                                                                                  foreground: Paint()
                                                                                    ..shader = const LinearGradient(
                                                                                      colors: <Color>[
                                                                                        Color.fromRGBO(220, 20, 60, 1),
                                                                                        Color.fromARGB(255, 255, 119, 0),
                                                                                      ],
                                                                                    ).createShader(
                                                                                      const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0),
                                                                                    ),
                                                                                ),
                                                                              ),
                                                                        SizedBox(
                                                                          height:
                                                                              265,
                                                                          child:
                                                                              buildPartecipantiList(),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      border: Border.all(
                                                          color: Colors.orange,
                                                          width: 2)),
                                                  width: 300,
                                                  height: 120,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text(
                                                          "Viaggiatore Ideale",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          "$preferenzaSesso | $etaMinPartecipanti - $etaMaxPartecipanti anni",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            foreground: Paint()
                                                              ..shader =
                                                                  const LinearGradient(
                                                                colors: <Color>[
                                                                  Color
                                                                      .fromRGBO(
                                                                          220,
                                                                          20,
                                                                          60,
                                                                          1),
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          119,
                                                                          0)
                                                                  //add more color here.
                                                                ],
                                                              ).createShader(
                                                                const Rect
                                                                        .fromLTWH(
                                                                    0.0,
                                                                    0.0,
                                                                    200.0,
                                                                    100.0),
                                                              ),
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    descrizione,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      color: Colors.black),
                                                  width: 300,
                                                  height: 150,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            prezzoViaggio,
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              foreground:
                                                                  Paint()
                                                                    ..shader =
                                                                        const LinearGradient(
                                                                      colors: <
                                                                          Color>[
                                                                        Color.fromRGBO(
                                                                            220,
                                                                            20,
                                                                            60,
                                                                            1),
                                                                        Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            119,
                                                                            0)
                                                                        //add more color here.
                                                                      ],
                                                                    ).createShader(
                                                                      const Rect
                                                                              .fromLTWH(
                                                                          0.0,
                                                                          0.0,
                                                                          200.0,
                                                                          100.0),
                                                                    ),
                                                            ),
                                                          ),
                                                          Text(
                                                            tipologia !=
                                                                    'regalare'
                                                                ? 'a persona/tasse incl.'
                                                                : '',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            frasePrezzo,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              foreground:
                                                                  Paint()
                                                                    ..shader =
                                                                        const LinearGradient(
                                                                      colors: <
                                                                          Color>[
                                                                        Color.fromRGBO(
                                                                            220,
                                                                            20,
                                                                            60,
                                                                            1),
                                                                        Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            119,
                                                                            0)
                                                                        //add more color here.
                                                                      ],
                                                                    ).createShader(
                                                                      const Rect
                                                                              .fromLTWH(
                                                                          0.0,
                                                                          0.0,
                                                                          200.0,
                                                                          100.0),
                                                                    ),
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                myuserid != proprietario
                                                    ? likeato == 'no'
                                                        ? Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 300,
                                                            height: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  const LinearGradient(
                                                                colors: [
                                                                  Colors.red,
                                                                  Colors.orange
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                SizedBox.expand(
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  setState(() {
                                                                    cuoreState = cuoreState ==
                                                                            "on"
                                                                        ? "off"
                                                                        : "on";
                                                                  });
                                                                  var url = Uri.https(
                                                                      'triptoshare.it',
                                                                      'wp-content/themes/triptoshare/methods-viaggio.php');
                                                                  var response =
                                                                      await http.post(
                                                                          url,
                                                                          body: {
                                                                        'action':
                                                                            'like',
                                                                        'id_utente':
                                                                            myuserid,
                                                                        'id_like':
                                                                            widget.viaggioId,
                                                                        'tipo':
                                                                            'v',
                                                                      });
                                                                  setState(() {
                                                                    likeato =
                                                                        "si";
                                                                  });
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "MI PIACE",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  shadowColor:
                                                                      Colors
                                                                          .transparent,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 300,
                                                            height: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                SizedBox.expand(
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: null,
                                                                child:
                                                                    const Text(
                                                                  "HAI GIA MESSO MI PIACE",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  shadowColor:
                                                                      Colors
                                                                          .transparent,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                    : Container(),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                myuserid != proprietario
                                                    ? int.parse(postiDisponibili) >
                                                            0
                                                        ? CustomButton(
                                                            height: 60,
                                                            width: 300,
                                                            onTap: () async {
                                                              if (responseRichiesta ==
                                                                  "si") {
                                                                var url = Uri.https(
                                                                    "triptoshare.it",
                                                                    "wp-content/themes/triptoshare/methods-viaggio.php");
                                                                var response =
                                                                    await http
                                                                        .post(
                                                                            url,
                                                                            body: {
                                                                      'action':
                                                                          'partecipa',
                                                                      'id_utente':
                                                                          myuserid,
                                                                      'id_viaggio':
                                                                          widget
                                                                              .viaggioId,
                                                                    });

                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                        MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      const SplashPage(
                                                                    testo:
                                                                        "Hai richiesto di partecipare",
                                                                  ),
                                                                ));
                                                              }
                                                            },
                                                            label: responseRichiesta ==
                                                                    "si"
                                                                ? "RICHIEDI DI PARTECIPARE"
                                                                : "HAI GIÀ RICHIESTO DI PARTECIPARE")
                                                        : SizedBox(
                                                            width: 300,
                                                            height: 60,
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      shadowColor:
                                                                          Colors
                                                                              .transparent,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                    ),
                                                                    onPressed:
                                                                        null,
                                                                    child: const Text(
                                                                        "POSTI ESAURITI")))
                                                    : const SizedBox(
                                                        height: 2,
                                                      ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                myuserid != proprietario
                                                    ? Container(
                                                        width: 300,
                                                        height: 60,
                                                        decoration:
                                                            kGradientBoxDecoration,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Container(
                                                            decoration:
                                                                kInnerDecoration,
                                                            child: Center(
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        shadowColor:
                                                                            Colors.transparent,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        String
                                                                            toUID =
                                                                            await HelperFunctions.getUidAccount(proprietario);
                                                                        print(
                                                                            myuserUID);
                                                                        if (toUID !=
                                                                                null &&
                                                                            toUID
                                                                                .isNotEmpty &&
                                                                            toUID !=
                                                                                "null") {
                                                                          String
                                                                              chatID =
                                                                              await HelperFunctions.existingGroup(myuserUID, toUID);

                                                                          Navigator.of(context)
                                                                              .push(MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                singleChatPage(useridTO: proprietario, chatID: chatID),
                                                                          ));
                                                                        } else {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                AlertDialog(
                                                                              content: const Text("L'utente non ha ancora scaricato l'applicazione e non può chattare. Invitalo a chattare con te"),
                                                                              actions: [
                                                                                ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[900]),
                                                                                  onPressed: () async {
                                                                                    var url = Uri.https('triptoshare.it', 'wp-content/themes/triptoshare/methods-viaggio.php');
                                                                                    var response = await http.post(url, body: {
                                                                                      'action': 'like',
                                                                                      'id_utente': myuserid,
                                                                                      'id_like': "a$proprietario",
                                                                                      'tipo': 'p',
                                                                                    });

                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const Center(child: Text("Invia la notifica")),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "INVIA MESSAGGIO",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      )),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(
                                                        height: 2,
                                                      ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    'Cosa è incluso nel viaggio',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      foreground: Paint()
                                                        ..shader =
                                                            const LinearGradient(
                                                          colors: <Color>[
                                                            Color.fromRGBO(
                                                                220, 20, 60, 1),
                                                            Color.fromARGB(255,
                                                                255, 119, 0)
                                                            //add more color here.
                                                          ],
                                                        ).createShader(
                                                          const Rect.fromLTWH(
                                                              0.0,
                                                              0.0,
                                                              200.0,
                                                              100.0),
                                                        ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    inclusoViaggio,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    'Cosa non è incluso nel viaggio',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      foreground: Paint()
                                                        ..shader =
                                                            const LinearGradient(
                                                          colors: <Color>[
                                                            Color.fromRGBO(
                                                                220, 20, 60, 1),
                                                            Color.fromARGB(255,
                                                                255, 119, 0)
                                                            //add more color here.
                                                          ],
                                                        ).createShader(
                                                          const Rect.fromLTWH(
                                                              0.0,
                                                              0.0,
                                                              200.0,
                                                              100.0),
                                                        ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    esclusoViaggio,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            prezzoViaggio != "0 €"
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "*Concorderai le modalità di pagamento della tua quota con l'utente che ha proposto il viaggio",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black,
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "L'offerta scade tra",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CountdownTimer(
                                      widgetBuilder: (_, time) {
                                        // ignore: unnecessary_null_comparison
                                        if (time == null) {
                                          //print(time);
                                          return Text(
                                            "Offerta scaduta",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              foreground: Paint()
                                                ..shader = const LinearGradient(
                                                  colors: <Color>[
                                                    Color.fromRGBO(
                                                        220, 20, 60, 1),
                                                    Color.fromARGB(
                                                        255, 255, 119, 0)
                                                    //add more color here.
                                                  ],
                                                ).createShader(
                                                  const Rect.fromLTWH(
                                                      0.0, 0.0, 200.0, 100.0),
                                                ),
                                            ),
                                          );
                                        }
                                        return Text(
                                          '${time.days}d ${time.hours}h ${time.min}m ${time.sec} s',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900,
                                            foreground: Paint()
                                              ..shader = const LinearGradient(
                                                colors: <Color>[
                                                  Color.fromRGBO(
                                                      220, 20, 60, 1),
                                                  Color.fromARGB(
                                                      255, 255, 119, 0)
                                                  //add more color here.
                                                ],
                                              ).createShader(
                                                const Rect.fromLTWH(
                                                    0.0, 0.0, 200.0, 100.0),
                                              ),
                                          ),
                                        );
                                      },
                                      endTime: endTimer,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      myuserid != proprietario
                          ? const SizedBox(
                              height: 1500,
                            )
                          : const SizedBox(
                              height: 1350,
                            ),
                    ],
                  ),
                ]))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ],
                ),
              ));
  }
}

class LinearGradientMask extends StatelessWidget {
  LinearGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [Color.fromARGB(255, 247, 92, 25), Colors.yellow],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
