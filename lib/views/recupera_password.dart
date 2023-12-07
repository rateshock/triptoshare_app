import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tripapp/views/main_app.dart';
import 'package:http/http.dart' as http;

class RecuperaPassword extends StatefulWidget {
  const RecuperaPassword({super.key});

  @override
  State<RecuperaPassword> createState() => _RecuperaPasswordState();
}

class _RecuperaPasswordState extends State<RecuperaPassword> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _emailError = "";
  String _passwordError = "";
  String finalResponse = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TripAppBar(
        hasBackButton: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text(
                      "Recupera Password",
                      style: TextStyle(fontSize: 32),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Indirizzo email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 320,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FormBuilderTextField(
                  controller: emailController,
                  name: 'email',
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 10),
                    hintText: 'Inserisci la tua email',
                    labelText: '',
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text(finalResponse),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                width: 320,
                height: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      finalResponse = "";
                    });
                    var email = emailController.text;
                    if (email == null) {
                      setState(() =>
                          _emailError = "Il campo email non puo' essere vuoto");
                    }
                    print("Email ${_emailError}");
                    if (_emailError.isEmpty) {
                      var url = Uri.https('triptoshare.it',
                          'wp-content/themes/triptoshare/methods.php');
                      var response = await http.post(url, body: {
                        'action': 'recupero_password',
                        'email': email
                      });
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');
                      setState(() => finalResponse = response.body);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (response.body == "") {
                        setState(() {
                          finalResponse =
                              "Ti abbiamo inviato email per recuperare la password";
                        });
                      } else {
                        setState(() {
                          finalResponse = response.body;
                        });
                      }
                    }
                  },
                  child: Text(
                    "RECUPERA PASSWORD",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
