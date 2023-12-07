import 'package:flutter/material.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:tripapp/views/profilo_account.dart';

class ProfiloUtente extends StatefulWidget {
  const ProfiloUtente({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  State<ProfiloUtente> createState() => _ProfiloUtenteState();
}

class _ProfiloUtenteState extends State<ProfiloUtente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TripAppBar(hasBackButton: true),
      body: ProfiloAccount(userid: widget.userId),
    );
  }
}
