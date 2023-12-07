import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripapp/views/profilo_utente.dart';
import 'package:http/http.dart' as http;
import 'package:tripapp/views/visualizza_viaggio.dart';

class CardViaggio extends StatefulWidget {
  const CardViaggio({
    Key? key,
    required this.viaggioId,
    required this.titolo,
    required this.descrizione,
    required this.sesso,
    required this.condivisione,
    required this.tipologia,
    required this.dataInizio,
    required this.dataFine,
    required this.prezzo,
    required this.utenteCreatore,
    required this.fotoUtente,
    required this.idUtenteCreatore,
    required this.paese,
    required this.destinazione,
    required this.fotoCopertina,
    required this.utenteCheVisualizza,
  }) : super(key: key);

  final String viaggioId;
  final String titolo;
  final String descrizione;
  final String sesso;
  final String condivisione;
  final String tipologia;
  final String dataInizio;
  final String dataFine;
  final String prezzo;
  final String utenteCreatore;
  final String fotoUtente;
  final String idUtenteCreatore;
  final String paese;
  final String destinazione;
  final String fotoCopertina;
  final String? utenteCheVisualizza;

  @override
  State<CardViaggio> createState() => _CardViaggioState();
}

class _CardViaggioState extends State<CardViaggio> {
  final iconInfo = SvgPicture.asset(
    "assets/icons/ico_info.svg",
    height: 40,
    width: 40,
    color: Colors.white,
    fit: BoxFit.scaleDown,
  );

  String cuoreState = "off";

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

    return response.body;
  }

  void atStart() async {
    checkIfInteractionExists(
            widget.utenteCheVisualizza, widget.viaggioId, 'viaggio')
        .then((value) {
      setState(() {
        cuoreState = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    final iconCuore = SvgPicture.asset(
      "assets/icons/ico_cuore.svg",
      height: 40,
      width: 40,
      color: cuoreState == "off" ? Colors.white : Colors.red,
      fit: BoxFit.scaleDown,
    );

    final dataInizio = DateTime.parse(widget.dataInizio);
    final dataFine = DateTime.parse(widget.dataFine);
    final titoloFormattato =
        widget.titolo.replaceAll("[", "").replaceAll("]", "");
    return Align(
      child: Container(
        width: 290,
        height: 350,
        margin: EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(
                widget.fotoCopertina.replaceAll('_trip_dir', 'assets')),
            fit: BoxFit.cover,
            opacity: 0.7,
          ),
          color: Colors.black,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                          'https://triptoshare.it/wp-content/themes/triptoshare/${widget.fotoUtente}'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.utenteCreatore,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.sesso == "donna")
                      SvgPicture.asset(
                        "assets/icons/ico_femmina.svg",
                        color: Colors.white,
                        width: 50,
                        height: 50,
                        fit: BoxFit.scaleDown,
                      )
                    else if (widget.sesso == "uomo")
                      SvgPicture.asset(
                        "assets/icons/ico_maschio.svg",
                        color: Colors.white,
                        width: 50,
                        height: 50,
                        fit: BoxFit.scaleDown,
                      )
                    else
                      SvgPicture.asset(
                        "assets/icons/ico_maschiofemmina.svg",
                        color: Colors.white,
                        width: 50,
                        height: 50,
                        fit: BoxFit.scaleDown,
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.condivisione == 'dividere')
                      SvgPicture.asset(
                        "assets/icons/ico_percentuale.svg",
                        color: Colors.white,
                        width: 28,
                        height: 28,
                        fit: BoxFit.scaleDown,
                      )
                    else if (widget.condivisione == "regalare")
                      SvgPicture.asset(
                        "assets/icons/ico_incudineregalo.svg",
                        color: Colors.white,
                        width: 30,
                        height: 30,
                        fit: BoxFit.scaleDown,
                      )
                    else
                      SvgPicture.asset(
                        "assets/icons/ico_stella1.svg",
                        color: Colors.white,
                        width: 30,
                        height: 30,
                        fit: BoxFit.scaleDown,
                      ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.tipologia == "campagna")
                      SvgPicture.asset(
                        "assets/icons/ico_alberi.svg",
                        color: Colors.white,
                        width: 45,
                        height: 45,
                        fit: BoxFit.scaleDown,
                      )
                    else if (widget.tipologia == "crociera")
                      SvgPicture.asset(
                        "assets/icons/ico_nave.svg",
                        color: Colors.white,
                        width: 45,
                        height: 45,
                        fit: BoxFit.scaleDown,
                      )
                    else if (widget.tipologia == "cultura")
                      SvgPicture.asset(
                        "assets/icons/ico_maschere.svg",
                        color: Colors.white,
                        width: 45,
                        height: 45,
                        fit: BoxFit.scaleDown,
                      )
                    else if (widget.tipologia == "mare")
                      SvgPicture.asset(
                        "assets/icons/ico_mare.svg",
                        color: Colors.white,
                        width: 45,
                        height: 45,
                        fit: BoxFit.scaleDown,
                      )
                    else if (widget.tipologia == "montagna")
                      SvgPicture.asset(
                        "assets/icons/ico_triangoli.svg",
                        color: Colors.white,
                        width: 45,
                        height: 45,
                        fit: BoxFit.scaleDown,
                      )
                    else if (widget.tipologia == "ontheroad")
                      SvgPicture.asset(
                        "assets/icons/ico_treno.svg",
                        color: Colors.white,
                        width: 45,
                        height: 45,
                        fit: BoxFit.fitWidth,
                      ),
                  ],
                ),
              ),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titoloFormattato.length <= 12
                                  ? "${titoloFormattato[0].toUpperCase()}${titoloFormattato.substring(1).toUpperCase()}"
                                  : "${titoloFormattato[0].toUpperCase()}${titoloFormattato.substring(1, 11).toUpperCase()}...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              titoloFormattato.length <= 12
                                  ? "${titoloFormattato[0].toUpperCase()}${titoloFormattato.substring(1).toUpperCase()}"
                                  : "${titoloFormattato[0].toUpperCase()}${titoloFormattato.substring(1, 11).toUpperCase()}...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${dataInizio.day}/${dataInizio.month}/${dataInizio.year}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "${dataFine.day}/${dataFine.month}/${dataFine.year}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                          "assets/icons/ico_calendario.svg",
                          color: Colors.white,
                          width: 45,
                          height: 45,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.prezzo == "0"
                        ? Text("GRATIS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ))
                        : Text(
                            "${widget.prezzo} €",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    Row(
                      children: [
                        GestureDetector(
                          child: iconInfo,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => VisualizzaViaggio(
                                      viaggioId: widget.viaggioId)),
                            );
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            child: iconCuore,
                            onTap: () async {
                              setState(() {
                                cuoreState = cuoreState == "on" ? "off" : "on";
                              });
                              var url = Uri.https('triptoshare.it',
                                  'wp-content/themes/triptoshare/methods-viaggio.php');
                              var response = await http.post(url, body: {
                                'action': 'like',
                                'id_utente': widget.utenteCheVisualizza,
                                'id_like': "${widget.viaggioId}",
                                'tipo': 'v',
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
