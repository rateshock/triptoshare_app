import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tripapp/components/custom_button.dart';
import 'package:tripapp/views/completa_profilo.dart';
import 'package:tripapp/views/main_app.dart';
import 'package:tripapp/views/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:tripapp/views/tourop.dart';
import 'dart:convert';

import '../components/helper.dart';

class RegisterEmail extends StatefulWidget {
  const RegisterEmail({super.key});

  @override
  State<RegisterEmail> createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  final _emailKey = GlobalKey<FormBuilderFieldState>();
  final _passwordKey = GlobalKey<FormBuilderFieldState>();
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
      appBar: TripAppBar(
        hasBackButton: true,
      ),
      body: Center(
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text(
                      "Registrati",
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
              SizedBox(
                width: 320,
                height: 65,
                child: FormBuilderTextField(
                  name: 'email',
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Inserisci la tua email',
                    labelText: '',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Il campo email non puo' essere vuoto"),
                    FormBuilderValidators.email(
                        errorText: "La mail inserita non e' valida"),
                  ]),
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      if (val == null || val == "")
                        _emailError = "Il campo email non puo' essere vuoto";
                      else
                        _emailError = "";
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
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
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 320,
                height: 65,
                child: FormBuilderTextField(
                  name: 'password',
                  autovalidateMode: AutovalidateMode.disabled,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Inserisci una password',
                    labelText: '',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Il campo password non puo' essere vuoto"),
                    FormBuilderValidators.minLength(6,
                        errorText:
                            "La password deve essere lunga almeno 6 caratteri"),
                  ]),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(finalResponse),
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
                child: CustomButton(
                  label: "Registrati",
                  height: 50,
                  width: 320,
                  onTap: () async {
                    setState(() {
                      finalResponse = "";
                    });
                    var email = _formKey.currentState?.fields['email']?.value;
                    var password =
                        _formKey.currentState?.fields['password']?.value;
                    print("Email ${email}");
                    print("Password ${password}");
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      var url = Uri.https('triptoshare.it',
                          'wp-content/themes/triptoshare/methods.php');
                      var response = await http.post(url, body: {
                        'action': 'registrati',
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
                          finalResponse = response.body;
                        });
                      } else {
                        prefs.setString('userId', response.body);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => CompletaProfilo(
                                  userId: response.body,
                                  firstName: "",
                                  lastName: "",
                                )));
                      }
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        uidAccount = credential.user?.uid;
                        var updateUid = HelperFunctions.updateUidAccount(
                            number.toString(), uidAccount);
                        prefs.setString('UUID', uidAccount.toString());
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      debugPrint('errore');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                  width: 320,
                  child: SignInWithAppleButton(
                    style: SignInWithAppleButtonStyle.black,
                    onPressed: () async {
                      try {
                        final appleCredential =
                            await SignInWithApple.getAppleIDCredential(scopes: [
                          AppleIDAuthorizationScopes.email,
                          AppleIDAuthorizationScopes.fullName
                        ]);

                        // Register the user with Firebase Authentication
                        final auth = FirebaseAuth.instance;
                        final userCredential = await auth.signInWithCredential(
                          OAuthProvider('apple.com').credential(
                            idToken: appleCredential.identityToken,
                            accessToken: appleCredential.authorizationCode,
                          ),
                        );

                        // Send user data to external PHP script
                        final appleID = appleCredential.userIdentifier;
                        final appleEmail = appleCredential.email;
                        final userData = {
                          'appleID': appleID,
                          'appleEmail': appleEmail
                        };
                        final response = await http.post(
                          Uri.https('triptoshare.it',
                              'wp-content/themes/triptoshare/methods.php'),
                          body: {
                            'action': 'apple-login',
                            'userData': jsonEncode(userData)
                          },
                        );
                        final userId = response.body;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        // Store the new user ID
                        await prefs.setString('userId', userId);

                        // Get the "completa_profilo" value from the server
                        final completaProfiloResponse =
                            await HelperFunctions.getProfilo(userId.toString());
                        final completaProfilo =
                            completaProfiloResponse['_completa_profilo']
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", '');
                        print('completa');
                        String myUID = userCredential.user!.uid.toString();
                        print(myUID);
                        prefs.setString("UUID", myUID);
                        print(completaProfilo);
                        // Update the UID account and store the UID
                        final updateUid =
                            await HelperFunctions.updateUidAccount(
                                userId.toString(),
                                userCredential.user?.uid ?? '');
                        prefs.setString('UUID', userCredential.user?.uid ?? '');
                        // Navigate to the appropriate screen
                        if (completaProfilo == "0") {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (_) => CompletaProfilo(
                                userId: userId.toString(),
                                firstName: appleCredential.givenName.toString(),
                                lastName:
                                    appleCredential.familyName.toString()),
                          ));
                        } else {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (_) => const MainApplication(),
                          ));
                        }
                      } catch (e) {
                        print('Error during Apple sign in: $e');
                      }
                    },
                  )),
              SizedBox(
                height: 15,
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
                child: CustomButton(
                  label: "Registrati con Facebook",
                  height: 50,
                  width: 320,
                  onTap: () async {
                    setState(() {
                      finalResponse = "";
                    });
                    final fb = FacebookLogin();
                    final res = await fb.logIn(permissions: [
                      FacebookPermission.publicProfile,
                      FacebookPermission.email,
                      FacebookPermission.userGender,
                      FacebookPermission.userLink,
                      FacebookPermission.userLocation,
                    ]);
                    switch (res.status) {
                      case FacebookLoginStatus.success:
                        final FacebookAccessToken accessToken =
                            res.accessToken!;
                        final profile = await fb.getUserProfile();
                        final email = await fb.getUserEmail();
                        Map toJson = {
                          'id': profile?.userId,
                          'first_name': profile?.firstName,
                          'last_name': profile?.lastName,
                          'email': email,
                          'link': '',
                          'gender': '',
                        };
                        print('Json ${toJson}');
                        var url = Uri.https('triptoshare.it',
                            'wp-content/themes/triptoshare/methods.php');
                        var response = await http.post(url, body: {
                          'action': 'facebook-register',
                          'userData': jsonEncode(toJson),
                        });
                        print('Response ${response.statusCode}');
                        print('Response ${response.body}');
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var possibleUserId = response.body
                            .replaceAll('ok', '')
                            .replaceAll('aggiornato', '');
                        final number = num.tryParse(possibleUserId);
                        if (number == null) {
                          setState(() {
                            finalResponse = "Si e' verificato un errore...";
                          });
                        } else {
                          prefs.setString('userId', number.toString());
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (_) => CompletaProfilo(
                              userId: number.toString(),
                              firstName: "",
                              lastName: "",
                            ),
                          ));
                        }
                        setState(() {
                          finalResponse = possibleUserId;
                        });
                        break;

                      case FacebookLoginStatus.cancel:
                        break;

                      case FacebookLoginStatus.error:
                        print('An error occurred ${res.error}');
                        break;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Sei un Tour Operator?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: InkWell(
                      child: Text(
                        "Registrati come Tour Operator",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const TourOp(),
                        ));
                      }),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Hai già un account?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: InkWell(
                      child: Text(
                        "Accedi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const Login(),
                        ));
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
