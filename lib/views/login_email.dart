import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tripapp/components/custom_button.dart';
import 'package:tripapp/views/main_app.dart';
import 'package:http/http.dart' as http;
import 'package:tripapp/views/recupera_password.dart';
import 'package:tripapp/views/completa_profilo.dart';
import 'package:tripapp/components/helper.dart';

class LoginEmail extends StatefulWidget {
  const LoginEmail({super.key});

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
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
  String? uidAccount = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TripAppBar(
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
                  child: const Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text(
                      "Accedi",
                      style: TextStyle(fontSize: 32),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Padding(
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
              const SizedBox(
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
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 10),
                    hintText: 'Inserisci la tua email',
                    labelText: '',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(
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
                  controller: passwordController,
                  name: 'password',
                  autovalidateMode: AutovalidateMode.disabled,
                  autocorrect: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 10),
                    hintText: "Inserisci la tua password",
                    labelText: '',
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                child: Text(finalResponse),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.center,
                width: 320,
                height: 45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomButton(
                  label: "Accedi",
                  height: 50,
                  width: 320,
                  onTap: () async {
                    setState(() {
                      finalResponse = "";
                    });
                    var email = emailController.text;
                    var password = passwordController.text;
                    if (email == null) {
                      setState(() =>
                          _emailError = "Il campo email non puo' essere vuoto");
                    }
                    if (password == null) {
                      setState(() => _passwordError =
                          "Il campo password non puo' essere vuoto");
                    }
                    print("Email ${_emailError}");
                    print("Password ${_passwordError})");
                    if (_emailError.isEmpty && _passwordError.isEmpty) {
                      var url = Uri.https('triptoshare.it',
                          'wp-content/themes/triptoshare/methods.php');
                      var response = await http.post(url, body: {
                        'action': 'accedi',
                        'email': email,
                        'password': password
                      });
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final number = num.tryParse(response.body);
                      if (number == null) {
                        setState(() {
                          finalResponse =
                              "Le credenziali potrebbero essere errate";
                        });
                      } else {
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          setState(() {
                            uidAccount = credential.user?.uid;
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              setState(() {
                                uidAccount = credential.user?.uid;
                              });
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                            }
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }
                        var updateUid = await HelperFunctions.updateUidAccount(
                            number.toString(), uidAccount);
                        prefs.setString('userId', number.toString());
                        prefs.setString('UUID', uidAccount.toString());
                        // ======= AGGIUNGERE CONTROLLO SE UID GIA PRESENTE SU WP ALLORA NON FARE SEGUENTE CHIAMATA

                        var _completaProfiloState =
                            await HelperFunctions.getProfilo(number.toString())
                                .then((value) async {
                          prefs.setString(
                              '_completa_profilo',
                              value["_completa_profilo"]
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", ""));
                          if (prefs.getString('_completa_profilo') == "1") {
                            String firstName = value["first_name"]
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "");
                            String lastName = value["last_name"]
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "");
                            String profilePicture = value["url_foto"]
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "");

                            await HelperFunctions.registerUser(
                                uidAccount,
                                firstName,
                                lastName,
                                profilePicture,
                                number.toString());

                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                  builder: (_) => const MainApplication(),
                                ))
                                .then((value) => Navigator.pop(context));
                          } else {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (_) => CompletaProfilo(
                                          userId: number.toString(),
                                          firstName: "",
                                          lastName: "",
                                        )));
                          }
                        });
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Password dimenticata?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: InkWell(
                      child: const Text(
                        "Recuperala",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const RecuperaPassword()));
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
