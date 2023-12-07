import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tripapp/views/completa_profilo.dart';
import 'package:tripapp/views/login_email.dart';
import 'package:tripapp/views/register_email.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/views/main_app.dart';
import 'package:tripapp/components/helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String facebookState = "";
  String? uidAccount = "";
  late AuthCredential cred;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late UserCredential _userCredential;
    late String _userId;
    return Scaffold(
      appBar: TripAppBar(
        hasBackButton: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                child: SizedBox.expand(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginEmail(),
                        ),
                      );
                    },
                    child: const Text(
                      "ACCEDI",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
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
                      final updateUid = await HelperFunctions.updateUidAccount(
                          userId.toString(), userCredential.user?.uid ?? '');
                      prefs.setString('UUID', userCredential.user?.uid ?? '');
                      // Navigate to the appropriate screen
                      if (completaProfilo == "0") {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => CompletaProfilo(
                              userId: userId.toString(),
                              firstName: appleCredential.givenName.toString(),
                              lastName: appleCredential.familyName.toString()),
                        ));
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const MainApplication(),
                        ));
                      }
                    } catch (e) {
                      print('Error during Apple sign in: $e');
                    }
                  },
                )),
            SizedBox(
              height: 20,
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
                child: SizedBox.expand(
                  child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          facebookState = "";
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
                              'action': 'facebook-login',
                              'userData': jsonEncode(toJson),
                            });
                            print('Response ${response.statusCode}');
                            print('Response ${response.body}');
                            if (response.body == 'not yet registered') {
                              setState(() {
                                facebookState =
                                    "Non sei registrato con Facebook";
                              });
                              return;
                            }
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var possibleUserId = response.body
                                .replaceAll('ok', '')
                                .replaceAll('aggiornato', '');
                            final number = num.tryParse(possibleUserId);
                            if (number == null) {
                              setState(() {
                                facebookState = "Si e' verificato un errore...";
                              });
                            } else {
                              prefs.setString('userId', possibleUserId);
                              var _completaProfiloState =
                                  await HelperFunctions.getProfilo(
                                          possibleUserId)
                                      .then((value) {
                                print(value['_completa_profilo']);
                                prefs.setString(
                                    '_completa_profilo',
                                    value["_completa_profilo"]
                                        .toString()
                                        .replaceAll("[", "")
                                        .replaceAll("]", ""));

                                if (prefs.getString('_completa_profilo') == "1")
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (_) => const MainApplication(),
                                  ));
                                else {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (_) => CompletaProfilo(
                                                userId: possibleUserId,
                                                firstName: "",
                                                lastName: "",
                                              )));
                                }
                              });
                            }

                            break;

                          case FacebookLoginStatus.cancel:
                            break;

                          case FacebookLoginStatus.error:
                            print('An error occurred ${res.error}');
                            break;
                        }
                      },
                      child: Text(
                        "ACCEDI CON FACEBOOK",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )),
                )),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Text(facebookState),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RegisterEmail(),
                  ),
                );
              },
              child: Text(
                "Crea nuovo account",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
