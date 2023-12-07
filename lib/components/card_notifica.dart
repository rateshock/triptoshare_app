import 'package:flutter/material.dart';
import 'package:tripapp/components/helper.dart';
import 'package:tripapp/views/profilo_utente.dart';
import 'package:tripapp/views/visualizza_viaggio.dart';

class CardNotifica extends StatefulWidget {
  const CardNotifica({
    Key? key,
    required this.userId,
    required this.mittente,
    required this.destinatario,
    required this.tipo,
    required this.contenuto,
    required this.idContenuto,
    required this.data,
    required this.flag,
    required this.nomeDa,
    required this.nomeA,
    required this.fotoDa,
  }) : super(key: key);

  final String? userId;
  final String mittente;
  final String destinatario;
  final String tipo;
  final String contenuto;
  final String idContenuto;
  final String data;
  final String flag;
  final String nomeDa;
  final String nomeA;
  final String fotoDa;

  @override
  State<CardNotifica> createState() => _CardNotificaState();
}

class _CardNotificaState extends State<CardNotifica> {
  String testoNotifica(tipo, contenuto, whoAmI, mittente, destinatario) {
    String testo = "";
    switch (contenuto) {
      case 'persona':
        switch (tipo) {
          case 'like-r':
            if (whoAmI == "mittente") {
              testo = "vuoi regalare un viaggio a $destinatario";
            } else {
              testo = "vorrebbe regalarti un viaggio";
            }
            break;
          case 'like-d':
            if (whoAmI == "mittente") {
              testo = "vuoi dividere un viaggio con $destinatario";
            } else {
              testo = "vorrebbe dividere un viaggio con te";
            }
            break;
          case 'like':
            if (whoAmI == "mittente") {
              testo = "hai messo mi piace a $destinatario";
            } else {
              testo = "ti ha messo mi piace";
            }
            break;
        }
        break;
      case 'viaggio':
        switch (tipo) {
          case 'like':
            if (whoAmI == "mittente") {
              testo = "hai messo mi piace al viaggio di $destinatario";
            } else {
              testo = "ha messo mi piace al tuo viaggio";
            }
            break;
          case "richiesta":
            if (whoAmI == "mittente") {
              testo =
                  "hai richiesto di partecipare al viaggio di $destinatario";
            } else {
              testo = "ha richiesto di partecipare al tuo viaggio";
            }
            break;
          case 'richiesta-accettata':
            if (whoAmI == "mittente") {
              testo = "";
            } else {
              testo = "ha accettato la tua richiesta di partecipazione";
            }
            break;
          case "richiesta-rifiutata":
            if (whoAmI == "mittente") {
              testo = "";
            } else {
              testo = "ha rifiutato la tua richiesta di partecipazione";
            }
        }
        break;
    }

    return testo;
  }

  bool _isLoading = false;

  void atStart() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() => _isLoading = true);

    super.initState();
    atStart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final containerMittenteNew = LinearGradient(colors: [
    Color.fromRGBO(3, 169, 244, 0.8),
    Color.fromRGBO(13, 71, 161, 0.8)
  ]);
  final containerMittenteOld = LinearGradient(colors: [
    Color.fromRGBO(3, 169, 244, 0.8),
    Color.fromRGBO(13, 71, 161, 0.8)
  ]);
  final containerDestinatarioNew = LinearGradient(colors: [
    Color.fromRGBO(220, 20, 60, 0.8),
    Color.fromRGBO(255, 153, 0, 0.8)
  ]);
  final containerDestinatarioOld = LinearGradient(colors: [
    Color.fromRGBO(220, 20, 60, 0.4),
    Color.fromRGBO(255, 153, 0, 0.4)
  ]);

  Gradient? whichColor(flag, userid, mittente) {
    if (userid == mittente) {
      if (flag == "")
        return containerMittenteNew;
      else
        return containerMittenteOld;
    } else {
      if (flag == "")
        return containerDestinatarioNew;
      else
        return containerDestinatarioOld;
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthCard = MediaQuery.of(context).size.width - 80;
    final widthCardWithPadding = widthCard - 20;
    final sizedBoxDividedByFive = widthCardWithPadding / 5;
    final now = DateTime.now().toLocal();
    var dateNotifica = DateTime.parse(widget.data);
    if (!dateNotifica.isUtc) {
      // Aggiungi 2 ore solo se la data di notifica non è nel formato UTC
      dateNotifica = dateNotifica.add(Duration(hours: 2));
    }
    final dateDiffence = now.difference(dateNotifica);

    print(dateNotifica);
    var data = "";
    if (dateDiffence.inDays != 0) {
      data = "${dateDiffence.inDays} gg fa";
    } else if (dateDiffence.inHours != 0) {
      data = "${dateDiffence.inHours} ore fa";
    } else if (dateDiffence.inMinutes != 0) {
      data = "${dateDiffence.inMinutes} min fa";
    } else {
      data = "${dateDiffence.inSeconds} sec fa";
    }
    return Align(
      alignment: Alignment.center,
      child: _isLoading == false
          ? Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  switch (widget.contenuto) {
                    case "persona":
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProfiloUtente(
                              userId: widget.mittente.toString())));
                      break;
                    case "viaggio":
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => VisualizzaViaggio(
                              viaggioId: widget.idContenuto.toString())));
                      break;
                  }
                },
                child: Container(
                  width: widthCard,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient:
                        whichColor(widget.flag, widget.userId, widget.mittente),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: sizedBoxDividedByFive,
                          child: GestureDetector(
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  "https://triptoshare.it/wp-content/themes/triptoshare/${widget.fotoDa}"),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ProfiloUtente(userId: widget.mittente)),
                              );
                            },
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            width: sizedBoxDividedByFive * 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.userId == widget.mittente
                                      ? "Tu"
                                      : widget.nomeDa.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  testoNotifica(
                                      widget.tipo,
                                      widget.contenuto,
                                      widget.userId == widget.mittente
                                          ? "mittente"
                                          : "destinatario",
                                      widget.nomeDa,
                                      widget.nomeA),
                                ),
                              ],
                            )),
                        Container(
                          alignment: Alignment.center,
                          width: sizedBoxDividedByFive,
                          child: Text(data),
                        )
                      ],
                    ),
                  ),
                ),
              ))
          : Container(),
    );
  }
}
