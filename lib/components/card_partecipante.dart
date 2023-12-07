import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripapp/components/helper.dart';
import 'package:tripapp/views/profilo_utente.dart';
import 'package:http/http.dart' as http;

class CardPartecipante extends StatefulWidget {
  const CardPartecipante({
    Key? key,
    required this.idPartecipante,
    required this.idViaggio,
    required this.fotoPartecipante,
    required this.nomePartecipante,
    required this.userId,
    required this.idCreatoreViaggio,
    required this.stato,
    required this.callback,
  }) : super(key: key);

  final String idPartecipante;
  final String fotoPartecipante;
  final String nomePartecipante;
  final String? userId;
  final String idCreatoreViaggio;
  final String idViaggio;
  final String stato;
  final void Function(String) callback;

  @override
  State<CardPartecipante> createState() => _CardPartecipanteState();
}

class _CardPartecipanteState extends State<CardPartecipante> {
  @override
  Widget build(BuildContext context) {
    var statoUtente = widget.stato;
    final iconInfo = SvgPicture.asset(
      "assets/icons/ico_info.svg",
      width: 35,
      height: 35,
    );

    final iconAccetta = SvgPicture.asset(
      "assets/icons/ico-V.svg",
      width: 35,
      height: 35,
    );

    final iconAccettato = SvgPicture.asset("assets/icons/ico-V.svg",
        width: 35,
        height: 35,
        colorFilter: ColorFilter.mode(Colors.orange.shade800, BlendMode.srcIn));

    final iconRifiuta = SvgPicture.asset(
      "assets/icons/ico_x2.svg",
      width: 35,
      height: 35,
    );
    print(widget.stato);

    return widget.userId == widget.idCreatoreViaggio
        ? widget.stato != 'rifiutato'
            ? Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProfiloUtente(
                                        userId: widget.idPartecipante),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://triptoshare.it/wp-content/themes/triptoshare/${widget.fotoPartecipante}"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProfiloUtente(
                                        userId: widget.idPartecipante),
                                  ),
                                );
                              },
                              child: Text(
                                widget.nomePartecipante,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ]),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var url = Uri.https("triptoshare.it",
                                      "wp-content/themes/triptoshare/methods-viaggio.php");
                                  var response = await http.post(url, body: {
                                    'action': 'accetta-partecipante',
                                    'id_utente': widget.idCreatoreViaggio,
                                    'id_partecipante': widget.idPartecipante,
                                    'id_viaggio': widget.idViaggio,
                                  });
                                  print(response.body);
                                  if (response.body == "ok") {
                                    widget.callback("accettato");
                                    setState(() {
                                      statoUtente = "accettato";
                                    });
                                    HelperFunctions.sendNotificaAccettazione(
                                        widget.idPartecipante,
                                        widget.idCreatoreViaggio,
                                        widget.idViaggio);
                                  }
                                },
                                child: statoUtente == "accettato" ||
                                        statoUtente == "abilitato"
                                    ? SvgPicture.asset("assets/icons/ico-V.svg",
                                        width: 35,
                                        height: 35,
                                        colorFilter: ColorFilter.mode(
                                            Colors.orange.shade800,
                                            BlendMode.srcIn))
                                    : SvgPicture.asset(
                                        "assets/icons/ico-V.svg",
                                        width: 35,
                                        height: 35,
                                      ),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    var url = Uri.https("triptoshare.it",
                                        "wp-content/themes/triptoshare/methods-viaggio.php");
                                    var response = await http.post(url, body: {
                                      'action': 'rifiuta-partecipante',
                                      'id_utente': widget.idCreatoreViaggio,
                                      'id_partecipante': widget.idPartecipante,
                                      'id_viaggio': widget.idViaggio,
                                    });

                                    var statoBottone =
                                        statoUtente == "accettato"
                                            ? "rifiutato"
                                            : "rifiutato";

                                    widget.callback(statoBottone);
                                    setState(() {
                                      statoUtente = statoBottone;
                                    });

                                    setState(() => statoUtente == "accettato"
                                        ? "rifiutato"
                                        : "rifiutato");
                                  },
                                  child: iconRifiuta),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProfiloUtente(
                                            userId: widget.idPartecipante),
                                      ),
                                    );
                                  },
                                  child: iconInfo),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                    )
                  ],
                ),
              )
            : Container()
        : widget.stato == "abilitato" || widget.stato == "accettato"
            ? Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProfiloUtente(
                                        userId: widget.idPartecipante),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://triptoshare.it/wp-content/themes/triptoshare/${widget.fotoPartecipante}"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProfiloUtente(
                                        userId: widget.idPartecipante),
                                  ),
                                );
                              },
                              child: Text(
                                widget.nomePartecipante,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                    )
                  ],
                ),
              )
            : Container();
  }
}
