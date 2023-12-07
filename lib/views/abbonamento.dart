import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/helper.dart';
import 'package:tripapp/views/splash.dart';

class AbbonamentoPage extends StatefulWidget {
  const AbbonamentoPage({Key? key}) : super(key: key);

  @override
  _AbbonamentoPageState createState() => _AbbonamentoPageState();
}

class _AbbonamentoPageState extends State<AbbonamentoPage> {
  List<Package>? availablePackages;
  String userId = "";

  @override
  void initState() {
    super.initState();
    atStart();
    fetchPackages(); // Chiamiamo la funzione per recuperare i pacchetti disponibili
  }

  void atStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "";
    });
  }

  Future<void> purchaseSubscription(Package package) async {
    String sceltaAbbonamento;

    switch (package.storeProduct.title) {
      case 'Abbonamento Mensile':
        sceltaAbbonamento = 'mensile';
        break;
      case 'Abbonamento Tre Mesi':
        sceltaAbbonamento = 'trimestrale';
        break;
      case 'Abbonamento annuale':
        sceltaAbbonamento = 'annuale';
        break;
      default:
        sceltaAbbonamento = 'non_specified'; // Gestisci il caso di default
    }

    try {
      CustomerInfo purchaserInfo = await Purchases.purchasePackage(package);
      if (purchaserInfo.entitlements.all["Pro"]!.isActive) {
        await HelperFunctions.scegliAbbonamento(userId, sceltaAbbonamento);
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => const SplashPage(testo: 'Abbonamento')),
        );
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print("Errore durante il recupero dei pacchetti: $e");
      }
    }
  }

  Future<void> fetchPackages() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      print(customerInfo.activeSubscriptions);
    } on PlatformException catch (e) {
      // Error fetching customer info
    }
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        setState(() {
          availablePackages = offerings.current!.availablePackages;
        });
      }
    } on PlatformException catch (e) {
      // Gestisci eventuali errori qui
      print("Errore durante il recupero dei pacchetti: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Scegli il tuo abbonamento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (availablePackages != null)
              Column(
                children: availablePackages!.map((package) {
                  return SubscriptionOption(
                    package: package,
                    userId: userId,
                    onPurchase: purchaseSubscription,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final Package package;
  final String userId;
  final Function(Package) onPurchase;

  SubscriptionOption({
    required this.package,
    required this.userId,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    bool isAnnual = package.storeProduct.title == 'Abbonamento annuale';

    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Aggiungi questa linea
          children: [
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: isAnnual,
              child: Container(
                color: Colors.orange[300],
                padding: EdgeInsets.all(5),
                child: Text(
                  "Consigliato",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(
              package.storeProduct.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              package.storeProduct.description,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              package.storeProduct.priceString,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () => onPurchase(package),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
              ),
              child: Text('Scegli'),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: isAnnual,
              child: Text("* Risparmi 240€"),
            ),
          ],
        ),
      ),
    );
  }
}
