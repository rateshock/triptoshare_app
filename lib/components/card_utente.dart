import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/views/profilo_utente.dart';
import 'package:http/http.dart' as http;

class CardUtente extends StatefulWidget {
  const CardUtente({
    Key? key,
    required this.userId,
    required this.nomeUtente,
    required this.fotoUtente,
    required this.utenteCheVisualizza,
  }) : super(key: key);

  final String userId;
  final String nomeUtente;
  final String fotoUtente;
  final String? utenteCheVisualizza;

  @override
  State<CardUtente> createState() => _CardUtenteState();
}

class _CardUtenteState extends State<CardUtente> {
  String regaloState = "off";
  String dividereState = "off";
  String cuoreState = "off";

  Future<String> checkIfInteractionExists(
      idUtente, idDaControllare, tipoLike) async {
    var url = Uri.https("triptoshare.it",
        "wp-content/themes/triptoshare/methods-viaggio.php");
    var response = await http.post(url, body: {
      "action": "checkInteraction",
      "idUtente": idUtente,
      "idDaControllare": idDaControllare,
      "tipo": tipoLike,
    });

    print(response.body);

    return response.body;
  }

  void atStart() async {
    checkIfInteractionExists(
            widget.utenteCheVisualizza, widget.userId, 'persona-regalo')
        .then((value) {
      setState(() {
        regaloState = value;
      });
    });
    checkIfInteractionExists(
            widget.utenteCheVisualizza, widget.userId, 'persona-dividere')
        .then((value) {
      setState(() {
        dividereState = value;
      });
    });
    checkIfInteractionExists(
            widget.utenteCheVisualizza, widget.userId, 'persona-like')
        .then((value) {
      setState(() {
        cuoreState = value;
      });
    });
  }

  @override
  void initState() {
    atStart();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final iconRegalo = SvgPicture.asset(
      "assets/icons/ico_likeregalo.svg",
      height: 45,
      width: 45,
      color: regaloState == "on" ? Colors.red : Colors.white,
      fit: BoxFit.scaleDown,
    );
    final iconDividere = SvgPicture.asset(
      "assets/icons/ico_likeperc.svg",
      height: 45,
      width: 45,
      color: dividereState == "on" ? Colors.red : Colors.white,
      fit: BoxFit.scaleDown,
    );
    final iconInfo = SvgPicture.asset(
      "assets/icons/ico_info.svg",
      height: 40,
      width: 40,
      color: Colors.white,
      fit: BoxFit.scaleDown,
    );
    final iconCuore = SvgPicture.asset(
      "assets/icons/ico_cuore.svg",
      height: 40,
      width: 40,
      color: cuoreState == "on" ? Colors.red : Colors.white,
      fit: BoxFit.scaleDown,
    );
    final nomeUtenteFormattato =
        widget.nomeUtente.replaceAll("[", "").replaceAll("]", "");
    return Align(
      child: Container(
        width: 290,
        height: 350,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(
                'https://triptoshare.it/wp-content/themes/triptoshare/${widget.fotoUtente.replaceAll("[", "").replaceAll("]", "")}'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    GestureDetector(
                      child: iconRegalo,
                      onTap: () async {
                        setState(() {
                          regaloState = regaloState == "on" ? "off" : "on";
                        });
                        var url = Uri.https('triptoshare.it',
                            'wp-content/themes/triptoshare/methods-viaggio.php');
                        var response = await http.post(url, body: {
                          'action': 'like',
                          'id_utente': widget.utenteCheVisualizza,
                          'id_like': "r${widget.userId}",
                          'tipo': 'p',
                        });
                      },
                    ),
                    GestureDetector(
                      child: iconDividere,
                      onTap: () async {
                        setState(() {
                          dividereState = dividereState == "on" ? "off" : "on";
                        });
                        var url = Uri.https('triptoshare.it',
                            'wp-content/themes/triptoshare/methods-viaggio.php');
                        var response = await http.post(url, body: {
                          'action': 'like',
                          'id_utente': widget.utenteCheVisualizza,
                          'id_like': "d${widget.userId}",
                          'tipo': 'p',
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 230,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nomeUtenteFormattato.length <= 9
                          ? "${nomeUtenteFormattato[0].toUpperCase()}${nomeUtenteFormattato.substring(1).toLowerCase()}"
                          : "${nomeUtenteFormattato[0].toUpperCase()}${nomeUtenteFormattato.substring(1, 7).toLowerCase()}...",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          shadows: [
                            Shadow(
                              offset: Offset(-1.0, -1.0),
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(1.0, -1.0),
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(-1.0, 1.0),
                              color: Colors.black,
                            ),
                          ]),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          child: iconInfo,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ProfiloUtente(userId: widget.userId)),
                            );
                          },
                        ),
                        const SizedBox(
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
                              'id_like': "${widget.userId}",
                              'tipo': 'p',
                            });
                          },
                        ),
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
