import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:tripapp/views/splash.dart';
import '../components/app_bar.dart';

class ConfermaViaggio extends StatefulWidget {
  ConfermaViaggio({
    super.key,
    required this.titoloViaggio,
    required this.descrizioneViaggio,
    required this.inclusoViaggio,
    required this.esclusoViaggio,
    required this.categoriaViaggio,
    required this.tipologiaViaggio,
    required this.paeseViaggio,
    required this.destinazioneViaggio,
    required this.linkEsterniViaggio,
    required this.prezzoViaggio,
    required this.partecipantiViaggio,
    required this.checkinData,
    required this.checkoutData,
    required this.sessoComp,
    required this.etamin,
    required this.etamax,
    required this.userid,
  });
  final titoloViaggio;
  final descrizioneViaggio;
  final inclusoViaggio;
  final esclusoViaggio;
  final categoriaViaggio;
  final tipologiaViaggio;
  final paeseViaggio;
  final destinazioneViaggio;
  final linkEsterniViaggio;

  final prezzoViaggio;
  final partecipantiViaggio;
  final checkinData;
  final checkoutData;
  final sessoComp;
  final etamin;
  final etamax;
  final userid;

  @override
  State<ConfermaViaggio> createState() => _ConfermaViaggioState();
}

class _ConfermaViaggioState extends State<ConfermaViaggio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TripAppBar(hasBackButton: true),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              Text(
                "Titolo Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.titoloViaggio),
              Text(
                "Descrizione Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.descrizioneViaggio),
              Text(
                "Incluso nell'Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.inclusoViaggio),
              Text(
                "Escluso dall'Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.esclusoViaggio),
              Text(
                "Tipologia Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.tipologiaViaggio),
              Text(
                "Paese Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.paeseViaggio),
              Text(
                "Destinazione Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.destinazioneViaggio),
              Text(
                "Link Esterni Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.linkEsterniViaggio),
              Text(
                "Check-In Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.checkinData),
              Text(
                "Check-Out Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.checkoutData),
              Text(
                "Preferenza Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.categoriaViaggio),
              Text(
                "Prezzo Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.prezzoViaggio),
              Text(
                "Numero Partecipanti Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.partecipantiViaggio),
              Text(
                "Preferenza Compagno Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.sessoComp),
              Text(
                "Preferenza Età Minima Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.etamin),
              Text(
                "Preferenza Età Massima Annuncio",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(widget.etamax),
              SizedBox(
                height: 40,
              ),
              CustomButton(
                  label: 'Pubblica Viaggio',
                  onTap: () async {
                    print(widget.userid);
                    var url = Uri.https('triptoshare.it',
                        'wp-content/themes/triptoshare/methods-viaggio.php');
                    var response = await http.post(url, body: {
                      'action': 'inserisci-app',
                      'id_utente': widget.userid,
                      'tipo_annuncio': 'classico',
                      'titolo': widget.titoloViaggio,
                      'descrizione': widget.descrizioneViaggio,
                      'incluso_nel_viaggio': widget.inclusoViaggio,
                      'escluso_dal_viaggio': widget.esclusoViaggio,
                      'tipologia_viaggio': widget.categoriaViaggio,
                      'paese': widget.paeseViaggio,
                      'destinazione': widget.destinazioneViaggio,
                      'check_in': widget.checkinData,
                      'check_out': widget.checkoutData,
                      'link_esterni': widget.linkEsterniViaggio,
                      'prezzo': widget.prezzoViaggio,
                      'partecipanti': widget.partecipantiViaggio,
                      'modalita_costo': widget.tipologiaViaggio,
                      'sesso': widget.sessoComp,
                      'eta_min': widget.etamin,
                      'eta_max': widget.etamax,
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SplashPage(testo: 'VIAGGIO INSERITO')));
                  },
                  width: 300,
                  height: 50)
            ],
          ),
        )));
  }
}
