import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tripapp/components/card_notifica.dart';
import 'package:tripapp/components/card_notifica_no_abb.dart';
import 'package:tripapp/components/helper.dart';
import 'dart:developer';

import 'package:tripapp/views/banned.dart';

class Notifiche extends StatefulWidget {
  const Notifiche({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String? userId;

  @override
  State<Notifiche> createState() => _NotificheState();
}

class _NotificheState extends State<Notifiche> with TickerProviderStateMixin {
  bool _isUserBanned = false;
  bool checkAbbonamento =
      false; // Variabile di stato per il controllo dell'abbonamento
  List<Map<String, dynamic>> jsonNotifiche = [];

  void atStart() async {
    var obj = await HelperFunctions.getNotifications(widget.userId);
    bool checkSub = await HelperFunctions.checkAbbonamento(widget.userId) ==
        'si'; // Confronta con 'si' per ottenere un valore booleano
    String bannato = await HelperFunctions.isUserBanned(widget.userId);
    if (mounted) {
      setState(() {
        jsonNotifiche = obj;
        checkAbbonamento = checkSub; // Aggiorna lo stato di checkAbbonamento
        _isUserBanned = bannato == "si";
      });
    }
    if (_isUserBanned) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => BannedUserPage()))
          .then((value) => Navigator.pop(context));
    }
  }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    atStart();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: "Ricevute",
                ),
                Tab(text: "Inviate"),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
            ),
            backgroundColor: Colors.transparent,
            toolbarHeight: 0,
            elevation: 0,
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                child: ListView.builder(
                  itemCount: jsonNotifiche.length,
                  itemBuilder: (context, index) {
                    if ((jsonNotifiche[index]['nome_da'] != "null" ||
                            jsonNotifiche[index]['url_foto'] != "null" ||
                            jsonNotifiche[index]["nome_a"] != "null") &&
                        jsonNotifiche[index]['id_da'] != widget.userId) {
                      if (checkAbbonamento) {
                        return CardNotificaNoAbb(
                          userId: widget.userId,
                          mittente: jsonNotifiche[index]['id_da'],
                          destinatario: jsonNotifiche[index]['id_a'],
                          tipo: jsonNotifiche[index]['tipo'],
                          contenuto: jsonNotifiche[index]['contenuto'],
                          idContenuto: jsonNotifiche[index]['id_contenuto'],
                          data: jsonNotifiche[index]['data'],
                          flag: jsonNotifiche[index]['flag'],
                          fotoDa: jsonNotifiche[index]['url_foto'] ?? "",
                          nomeDa: jsonNotifiche[index]['nome_da'] ?? "",
                          nomeA: jsonNotifiche[index]['nome_a'] ?? "",
                        );
                      } else {
                        return CardNotificaNoAbb(
                          userId: widget.userId,
                          mittente: jsonNotifiche[index]['id_da'],
                          destinatario: jsonNotifiche[index]['id_a'],
                          tipo: jsonNotifiche[index]['tipo'],
                          contenuto: jsonNotifiche[index]['contenuto'],
                          idContenuto: jsonNotifiche[index]['id_contenuto'],
                          data: jsonNotifiche[index]['data'],
                          flag: jsonNotifiche[index]['flag'],
                          fotoDa: jsonNotifiche[index]['url_foto'] ?? "",
                          nomeDa: jsonNotifiche[index]['nome_da'] ?? "",
                          nomeA: jsonNotifiche[index]['nome_a'] ?? "",
                        );
                      }
                    } else
                      return Container();
                  },
                ),
                onRefresh: () async {
                  return Future.delayed(Duration(seconds: 1), () {
                    atStart();
                  });
                },
              ),
              RefreshIndicator(
                  child: ListView.builder(
                    itemCount: jsonNotifiche.length,
                    itemBuilder: (context, index) {
                      if ((jsonNotifiche[index]['nome_da'] != "null" ||
                              jsonNotifiche[index]['foto_url'] != "null" ||
                              jsonNotifiche[index]["nome_a"] != "null") &&
                          jsonNotifiche[index]['id_da'] == widget.userId)
                        return CardNotifica(
                          userId: widget.userId,
                          mittente: jsonNotifiche[index]['id_da'],
                          destinatario: jsonNotifiche[index]['id_a'],
                          tipo: jsonNotifiche[index]['tipo'],
                          contenuto: jsonNotifiche[index]['contenuto'],
                          idContenuto: jsonNotifiche[index]['id_contenuto'],
                          data: jsonNotifiche[index]['data'],
                          flag: jsonNotifiche[index]['flag'],
                          fotoDa: jsonNotifiche[index]['url_foto'] ?? "",
                          nomeDa: jsonNotifiche[index]['nome_da'] ?? "",
                          nomeA: jsonNotifiche[index]['nome_a'] ?? "",
                        );
                      else
                        return Container();
                    },
                  ),
                  onRefresh: () async {
                    return Future.delayed(Duration(seconds: 1), () {
                      atStart();
                    });
                  }),
            ],
          ),
        ));
  }
}
