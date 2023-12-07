import 'package:flutter/material.dart';
import 'package:tripapp/components/app_bar.dart';
import 'dart:core';

import 'package:tripapp/components/card_utente.dart';
import 'package:tripapp/components/card_viaggio.dart';
import 'package:tripapp/components/helper.dart';

class HomeRicerca extends StatefulWidget {
  const HomeRicerca({
    Key? key,
    required this.idsList,
    required this.toggle,
    required this.userId,
  }) : super(key: key);

  final List<Map<String, dynamic>> idsList;
  final String toggle;
  final String? userId;

  @override
  State<HomeRicerca> createState() => _HomeRicercaState();
}

class _HomeRicercaState extends State<HomeRicerca> {
  var obj;
  var contatore = 0;
  var _isLoading = false;
  Map<dynamic, Map<String, dynamic>> datiCards = {};
  List<dynamic> utenti = [];

  void getSingleDataUtente(userId) async {
    var objTemp = await HelperFunctions.getProfilo(userId);
    setState(() {
      obj = objTemp;
      String nomeUtente = objTemp["first_name"].toString();
      String fotoUtente = objTemp["url_foto"].toString();
      datiCards[int.parse(userId)] = {
        userId: {
          "userId": userId,
          "first_name": nomeUtente,
          "url_foto": fotoUtente,
        }
      };
    });
  }

  void getSingleDataViaggio(viaggioId) async {
    var objTemp = await HelperFunctions.getViaggio(viaggioId);
    setState(() {
      obj = objTemp;

      if (obj.isEmpty)
        return;
      else {
        String proprietario = objTemp[0]["proprietario"].toString();
        String titolo = objTemp[0]["titolo_viaggio"].toString();
        String descrizione = objTemp[0]["descrizione_viaggio"].toString();
        String dataPartenza = objTemp[0]["data_partenza"].toString();
        String dataArrivo = objTemp[0]["data_arrivo"].toString();
        String categoriaViaggio = objTemp[0]["categoria_viaggio"].toString();
        String preferenzaSesso =
            objTemp[0]["prefereneza_sesso_partecipanti_viaggio"].toString();
        String tipologia = objTemp[0]["tipologia"].toString();
        String costoViaggio = objTemp[0]["costo_viaggio"].toString();
        String fotoCopertina = objTemp[0]["foto_copertina"].toString();
        String paese = objTemp[0]["paese"].toString();
        String destinazione = objTemp[0]["destinazione"].toString();
        String fotoUtente = objTemp[0]["url_foto"].toString();
        String nomeUtente = objTemp[0]["first_name"].toString();

        datiCards[int.parse(viaggioId)] = {
          viaggioId: {
            "viaggioId": viaggioId,
            "proprietario": proprietario,
            "titolo": titolo,
            "descrizione": descrizione,
            "dataPartenza": dataPartenza,
            "dataArrivo": dataArrivo,
            "categoriaViaggio": categoriaViaggio,
            "preferenzaSesso": preferenzaSesso,
            "tipologia": tipologia,
            "costoViaggio": costoViaggio,
            "fotoCopertina": fotoCopertina,
            "paese": paese,
            "destinazione": destinazione,
            "fotoUtente": fotoUtente,
            "nomeUtente": nomeUtente,
          }
        };
      }
    });
  }

  void getData(idsList, toggle) async {
    for (var id in idsList) {
      if (toggle == "persone") {
        getSingleDataUtente(id["ID"]);
      } else if (toggle == 'viaggi') {
        getSingleDataViaggio(id['id']);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData(widget.idsList, widget.toggle);
    setState(() {
      _isLoading = false;
      utenti = datiCards.entries.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TripAppBar(hasBackButton: true),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: ListView(
              shrinkWrap: false,
              children: [
                if (widget.toggle == "viaggi" && datiCards.isEmpty)
                  Center(
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Text(
                                "Non ci sono viaggi che corrispondono alla tua ricerca!",
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Torna indietro e prova a cambiare i parametri della tua ricerca",
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic),
                              ),
                              Icon(
                                Icons.cancel_outlined,
                                size: 30,
                              )
                            ],
                          ))),
                for (var chiave in datiCards.keys)
                  for (var entries in datiCards[chiave]!.values)
                    //Text('key: $chiave, value: ${entries["last_name"]}'),
                    widget.toggle == "persone"
                        ? CardUtente(
                            utenteCheVisualizza: widget.userId,
                            userId: entries["userId"],
                            nomeUtente: entries["first_name"],
                            fotoUtente: entries["url_foto"])
                        : CardViaggio(
                            utenteCheVisualizza: widget.userId,
                            viaggioId: entries['viaggioId'],
                            titolo: entries["titolo"],
                            descrizione: entries['descrizione'],
                            sesso: entries["preferenzaSesso"],
                            dataInizio: entries["dataPartenza"],
                            dataFine: entries["dataArrivo"],
                            tipologia: entries["categoriaViaggio"],
                            condivisione: entries["tipologia"],
                            paese: entries["paese"],
                            destinazione: entries["destinazione"],
                            prezzo: entries["costoViaggio"],
                            fotoCopertina: entries["fotoCopertina"],
                            idUtenteCreatore: entries["proprietario"],
                            fotoUtente: entries["fotoUtente"],
                            utenteCreatore: entries["nomeUtente"],
                          )
              ],
            )),
          ],
        ));
  }
}
