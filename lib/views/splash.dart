import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripapp/views/home.dart';
import 'package:tripapp/views/main_app.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key, required this.testo});
  final testo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(220, 20, 60, 1),
            Color.fromARGB(255, 255, 119, 0)
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            testo != "Abbonamento"
                ? Text(
                    testo,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  )
                : Text("data"),
            SvgPicture.asset(
              'assets/icons/ico-V.svg',
              height: 100,
              width: 100,
              color: Colors.white,
              // fit: BoxFit.scaleDown,
            ),
            Container(
              width: 300,
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const MainApplication()));
                  },
                  child: Text(
                    'Torna alla Home',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[
                            Color.fromRGBO(220, 20, 60, 1),
                            Color.fromARGB(255, 255, 119, 0)
                            //add more color here.
                          ],
                        ).createShader(
                          const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0),
                        ),
                    ),
                  )),
            )
          ],
        ),
      ),
    ));
  }
}
