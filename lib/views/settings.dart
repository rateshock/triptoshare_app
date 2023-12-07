import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:typed_data';
import 'package:accordion/controllers.dart';
import 'package:accordion/accordion.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:tripapp/components/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripapp/components/custom_dropdown.dart';
import 'package:tripapp/views/banned.dart';
import 'package:tripapp/views/login.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tripapp/views/splash.dart';
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../components/custom_button.dart';
import '../components/helper.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  final NumberFormat giornoFormat = new NumberFormat("00");
  final NumberFormat meseFormat = new NumberFormat("00");
  final NumberFormat annoFormat = new NumberFormat("0000");
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _formattedDate = TextEditingController();
  final TextEditingController _descrizione = TextEditingController();
  final TextEditingController _giorno = TextEditingController();
  final TextEditingController _mese = TextEditingController();
  final TextEditingController _anno = TextEditingController();
  final TextEditingController _citta = TextEditingController();
  final TextEditingController _facebook = TextEditingController();
  final TextEditingController _instagram = TextEditingController();
  final TextEditingController _etaMin = TextEditingController();
  final TextEditingController _etaMax = TextEditingController();
  final _sitSentFormKey = GlobalKey<FormBuilderFieldState>();
  final _genere = GlobalKey<FormBuilderFieldState>();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage = null;
  bool _isLoading = false;

  late TabController _tabController;
  String? userid = "";
  String firstName = "";
  String lastName = "";
  String descrizione = "";
  String dataNascitaRAW = "";
  String regalo = "";
  String stella = "";
  String percentuale = "";
  String modalitaViaggio = "";
  String citta = "";
  String facebook = "";
  String instagram = "";
  String sitSentSelected = "";
  String sitSentSelectedDB = "";
  String sitSentDB = "";
  String sessoComp = "";
  String maschio = "";
  String femmina = "";
  String entrambi = "";
  String etaMin = "";
  String etaMax = "";
  String viaggioDB = "";
  String profilePicture = "";
  String _campagna = "";
  String _mare = "";
  String _montagna = "";
  String _ontheroad = "";
  String _crociera = "";
  String _cultura = "";
  String genereScelto = "";
  String giorno = "";
  String mese = "";
  String anno = "";
  var x = "";

  int annoNascita = 0;
  int meseNascita = 0;
  int giornoNascita = 0;
  int _regalare = 0;
  int _stella = 0;
  int _dividere = 0;
  int _maschio = 0;
  int _femmina = 0;
  int _entrambi = 0;
  int campagna = 0;
  int crociera = 0;
  int cultura = 0;
  int mare = 0;
  int montagna = 0;
  int ontheroad = 0;

  XFile? image;

  DateTime dataState = DateTime.now();
  bool _isUserBanned = false;

  var sitsent = [
    'Single',
    'Impegnato/a',
    'Non dico',
  ];
  var genereSesso = ['Uomo', 'Donna', 'Preferisco non dire'];
  Future<String>? _stoCazzo;
  Future<String>? _genereScelto;
  atStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('userId');
    });
    var objTemp = await HelperFunctions.getProfilo(userid);
    _stoCazzo = getSent(objTemp);
    _genereScelto = getGenere(objTemp);

    setState(() {
      print(objTemp);
      firstName = objTemp['first_name']
          .toString()
          .replaceAll("[", '')
          .replaceAll("]", '');
      lastName = objTemp['last_name']
          .toString()
          .replaceAll("[", '')
          .replaceAll("]", '');
      dataNascitaRAW = objTemp["data_nascita"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      modalitaViaggio = objTemp["modalita_viaggio"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");

      descrizione = objTemp["biografia"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      citta =
          objTemp["citta"].toString().replaceAll("]", "").replaceAll("[", "");
      facebook = objTemp["facebook"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      instagram = objTemp["instagram"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      sessoComp = objTemp["sessocomp"]
          .toString()
          .replaceAll("]", "")
          .replaceAll("[", "");
      profilePicture =
          'https://triptoshare.it/wp-content/themes/triptoshare/${objTemp["url_foto"].toString().replaceAll("]", "").replaceAll("[", "")}';
      viaggioDB =
          objTemp["viaggio"].toString().replaceAll("]", "").replaceAll("[", "");
      etaMin =
          objTemp["etamin"].toString().replaceAll("]", "").replaceAll("[", "");
      etaMax =
          objTemp["etamax"].toString().replaceAll("]", "").replaceAll("[", "");
    });

    if (facebook == "null") {
      facebook = "";
    }
    if (instagram == "null") {
      instagram = "";
    }
    if (citta == "null") {
      citta = "";
    }
    if (etaMax == "null") {
      etaMax = "99";
    }
    if (etaMin == "null") {
      etaMin = "18";
    }
    if (viaggioDB == "null") {
      viaggioDB = "no,no,no,no,no,no";
    }
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _descrizione.text = descrizione;
    _citta.text = citta;
    _facebook.text = facebook;
    _instagram.text = instagram;
    _etaMin.text = etaMin;
    _etaMax.text = etaMax;
    var data1 = DateTime.parse(dataNascitaRAW);
    dataState = DateFormat('yyyy-MM-dd').parse(data1.toString());

    var datNascita = "$giornoNascita-$meseNascita-$annoNascita";

    _formattedDate.text = datNascita;

    DateTime dateTime1 = DateFormat('yyyy-MM-dd').parse(dataNascitaRAW);
    print("data: $dateTime1");
    giornoNascita = dateTime1.day;
    _giorno.text = giornoNascita.toString();
    giorno = giornoNascita.toString();
    meseNascita = dateTime1.month;
    _mese.text = meseNascita.toString();
    mese = meseNascita.toString();
    annoNascita = dateTime1.year;
    _anno.text = annoNascita.toString();
    anno = annoNascita.toString();
    final DateTime dataFormattata = dateTime1;

    final viaggiosplit = viaggioDB.split(',');
    if (viaggiosplit[0] == 'si') {
      campagna = 1;
      _campagna = "si";
    } else {
      campagna = 0;
      _campagna = "no";
    }
    if (viaggiosplit[1] == 'si') {
      crociera = 1;
      _crociera = "si";
    } else {
      crociera = 0;
      _crociera = "no";
    }
    if (viaggiosplit[2] == 'si') {
      cultura = 1;
      _cultura = "si";
    } else {
      cultura = 0;
      _cultura = "no";
    }
    if (viaggiosplit[3] == 'si') {
      mare = 1;
      _mare = "si";
    } else {
      mare = 0;
      _mare = "no";
    }
    if (viaggiosplit[4] == 'si') {
      montagna = 1;
      _montagna = "si";
    } else {
      montagna = 0;
      _montagna = "no";
    }
    if (viaggiosplit[5] == 'si') {
      ontheroad = 1;
      _ontheroad = "si";
    } else {
      ontheroad = 0;
      _ontheroad = "no";
    }

    switch (modalitaViaggio) {
      case "regalare":
        regalo = 'si';
        percentuale = "no";
        stella = "no";
        setState(() {
          _regalare = 1;
          _stella = 0;
          _dividere = 0;
        });
        break;
      case "gratis":
        stella = 'si';
        percentuale = "no";
        regalo = "no";
        setState(() {
          _regalare = 0;
          _stella = 1;
          _dividere = 0;
        });
        break;
      case "dividere":
        percentuale = 'si';
        stella = "no";
        regalo = "no";
        setState(() {
          _regalare = 0;
          _stella = 0;
          _dividere = 1;
        });
        break;
    }
    switch (sessoComp) {
      case "entrambi":
        entrambi = "si";
        setState(() {
          _maschio = 0;
          _femmina = 0;
          _entrambi = 1;
        });
        break;
      case "uomo":
        maschio = "si";
        setState(() {
          _maschio = 1;
          _femmina = 0;
          _entrambi = 0;
        });

        break;
      case "donna":
        femmina = "si";
        setState(() {
          _maschio = 0;
          _femmina = 1;
          _entrambi = 0;
        });

        break;
    }
    setState(() => _isLoading = false);
    print(sessoComp);
    evictImage(profilePicture);
    String bannato = await HelperFunctions.isUserBanned(userid);

    setState(() {
      if (bannato == "si") {
        _isUserBanned = true;
      } else {
        _isUserBanned = false;
      }
      print(_isUserBanned);
    });
    if (_isUserBanned == true) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => BannedUserPage()))
          .then((value) => Navigator.pop(context));
    }
  }

  Future<String> getGenere(objTemp) async {
    String genereDB =
        objTemp["sesso"].toString().replaceAll("]", "").replaceAll("[", "");
    switch (genereDB) {
      case "uomo":
        genereScelto = "Uomo";
        break;
      case "donna":
        genereScelto = "Donna";
        break;
      case "Uomo":
        genereScelto = "Uomo";
        break;
      case "Donna":
        genereScelto = "Donna";
        break;
      case "Preferisco non dire":
        genereScelto = "Preferisco non dire";
        break;
    }
    return genereScelto;
  }

  Future<String> getSent(objTemp) async {
    String sitSentDBFuture =
        objTemp["sitsen"].toString().replaceAll("]", "").replaceAll("[", "");

    switch (sitSentDBFuture) {
      case "no":
        sitSentSelectedDB = 'Non dico';

        break;
      case "sing":
        sitSentSelectedDB = 'Single';
        break;
      case "impe":
        sitSentSelectedDB = 'Impegnato/a';
        break;

      default:
        sitSentSelectedDB = 'Non dico';
        break;
    }
    sitSentSelected = sitSentSelectedDB;
    return sitSentSelectedDB;
  }

  @override
  void initState() {
    super.initState();
    setState(() => _isLoading = true);
    atStart();
    _tabController = TabController(length: 2, vsync: this);
  }

  void evictImage(url) {
    final NetworkImage provider = NetworkImage(url);
    provider.evict().then<void>((bool success) {
      if (success) debugPrint('removed image!');
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system
              // navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ],
            ),
          )
        : Container(
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SizedBox(
                    child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Wrap(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Impostazioni Generali',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800,
                                            foreground: Paint()
                                              ..shader = const LinearGradient(
                                                colors: <Color>[
                                                  Color.fromRGBO(
                                                      220, 20, 60, 1),
                                                  Color.fromRGBO(255, 153, 0, 1)
                                                  //add more color here.
                                                ],
                                              ).createShader(
                                                  const Rect.fromLTWH(0.0, 0.0,
                                                      200.0, 100.0)))),
                                    Stack(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 800,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.90,
                                          child: Scaffold(
                                            appBar: AppBar(
                                              bottom: TabBar(
                                                controller: _tabController,
                                                tabs: const <Widget>[
                                                  Tab(
                                                    text: "Generali",
                                                  ),
                                                  /*Tab(
                                                    text: "Abbonamento",
                                                  ),*/
                                                  Tab(
                                                    text: "Info",
                                                  ),
                                                ],
                                                labelColor: Colors.black,
                                                unselectedLabelColor:
                                                    Colors.grey,
                                                indicatorColor: Colors.black,
                                              ),
                                              toolbarHeight: 0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                            ),
                                            body: TabBarView(
                                              controller: _tabController,
                                              children: <Widget>[
                                                SingleChildScrollView(
                                                    child: SizedBox(
                                                        height: 2000,
                                                        child: Form(
                                                          key: _formKey,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Wrap(
                                                                    runSpacing:
                                                                        10,
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    children: [
                                                                      Center(
                                                                        child:
                                                                            Stack(
                                                                          fit: StackFit
                                                                              .loose, // Just Changed this line
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                          children: [
                                                                            CircleAvatar(
                                                                              radius: 55.0,
                                                                              backgroundImage: pickedImage == null ? NetworkImage(profilePicture) : FileImage(File(pickedImage!.path)) as ImageProvider,
                                                                            ),
                                                                            InkWell(
                                                                              // this is the one you are looking for..........
                                                                              onTap: () async {
                                                                                image = await _picker.pickImage(source: ImageSource.gallery);
                                                                                setState(() {
                                                                                  pickedImage = image;
                                                                                });
                                                                                print("Picked: ${pickedImage.toString()}");
                                                                                File imageFile = File(pickedImage!.path);
                                                                                if (imageFile != null) {
                                                                                  Uint8List file = await imageFile.readAsBytes();
                                                                                  setState(() {
                                                                                    x = base64Encode(file);
                                                                                  });

                                                                                  print("X: $x");
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                //width: 50.0,
                                                                                //height: 50.0,
                                                                                padding: const EdgeInsets.all(2.0), //I used some padding without fixed width and height
                                                                                decoration: const BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  //borderRadius: new BorderRadius.circular(30.0),
                                                                                  color: Colors.white,
                                                                                ),
                                                                                // You can add a Icon instead of text also, like below.
                                                                                child: const Icon(Icons.add, size: 25.0, color: Colors.orange),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Nome",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            TextFormField(
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty ||
                                                                                value == "") {
                                                                              return "Inserisci il nome";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Inserisci il tuo Nome ",
                                                                            border:
                                                                                const OutlineInputBorder(),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                          autocorrect:
                                                                              false,
                                                                          controller:
                                                                              _firstNameController,
                                                                          onChanged:
                                                                              (String value) {
                                                                            firstName =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Cognome",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            TextFormField(
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty ||
                                                                                value == "") {
                                                                              return "Inserisci il cognome";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Inserisci il tuo cognome ",
                                                                            border:
                                                                                const OutlineInputBorder(),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                          autocorrect:
                                                                              false,
                                                                          controller:
                                                                              _lastNameController,
                                                                          onChanged:
                                                                              (String value) {
                                                                            lastName =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Data di Nascita",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              60,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              GestureDetector(
                                                                                  child: Text("${dataState.day}-${dataState.month}-${dataState.year}", style: TextStyle(fontSize: 18)),
                                                                                  onTap: () => _showDialog(
                                                                                        CupertinoDatePicker(
                                                                                          initialDateTime: dataState,
                                                                                          mode: CupertinoDatePickerMode.date,
                                                                                          maximumYear: DateTime.now().year,
                                                                                          minimumYear: DateTime.parse("1900-01-01").year,
                                                                                          use24hFormat: true,
                                                                                          dateOrder: DatePickerDateOrder.dmy,
                                                                                          // This is called when the user changes the date.
                                                                                          onDateTimeChanged: (DateTime newDate) {
                                                                                            setState(() => dataState = newDate);
                                                                                          },
                                                                                        ),
                                                                                      )),
                                                                            ],
                                                                          )),
                                                                      const Text(
                                                                        "Sesso",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      FutureBuilder(
                                                                        future:
                                                                            _genereScelto,
                                                                        builder: (BuildContext
                                                                                context,
                                                                            AsyncSnapshot<String>
                                                                                snapshot) {
                                                                          if (snapshot.connectionState ==
                                                                              ConnectionState.done) {
                                                                            return FormBuilderDropdown<String>(
                                                                              elevation: 1,
                                                                              isExpanded: false,
                                                                              key: _genere,
                                                                              name: 'generescelto',
                                                                              initialValue: snapshot.data,
                                                                              iconDisabledColor: Colors.white,
                                                                              iconEnabledColor: const Color.fromARGB(255, 0, 0, 0),
                                                                              decoration: const InputDecoration(
                                                                                contentPadding: EdgeInsets.all(10),
                                                                                //labelText: "Ricerca per tipologia",
                                                                                hintText: "Seleziona sesso",
                                                                                hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                              ),
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                              ),
                                                                              onChanged: (selectedValue) => {
                                                                                setState(() {
                                                                                  genereScelto = selectedValue!;
                                                                                })
                                                                              },
                                                                              items: genereSesso
                                                                                  .map((attribute) => DropdownMenuItem(
                                                                                        value: attribute,
                                                                                        alignment: AlignmentDirectional.centerStart,
                                                                                        child: Text(attribute),
                                                                                      ))
                                                                                  .toList(),
                                                                              valueTransformer: (val) => val?.toString(),
                                                                            );
                                                                          } else {
                                                                            return const Text("ciao");
                                                                          }
                                                                        },
                                                                      ),
                                                                      const Text(
                                                                        "Modalità di viaggio preferita",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Expanded(
                                                                              child: SizedBox(
                                                                                width: 120,
                                                                                child: GestureDetector(
                                                                                    onTap: () => setState(() {
                                                                                          _regalare = 1;
                                                                                          _stella = 0;
                                                                                          _dividere = 0;
                                                                                          regalo = "si";
                                                                                          stella = "no";
                                                                                          percentuale = "no";
                                                                                        }),
                                                                                    child: Column(children: [
                                                                                      SvgPicture.asset('assets/icons/ico_incudineregalo.svg', height: 43, width: 43, fit: BoxFit.scaleDown, color: _regalare == 1 ? Colors.orange : Colors.grey),
                                                                                      Text("Voglio regalare un viaggio")
                                                                                    ])),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: SizedBox(
                                                                                width: 120,
                                                                                child: GestureDetector(
                                                                                  onTap: () => setState(() {
                                                                                    _regalare = 0;
                                                                                    _stella = 1;
                                                                                    _dividere = 0;
                                                                                    regalo = "no";
                                                                                    stella = "si";
                                                                                    percentuale = "no";
                                                                                  }),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      SvgPicture.asset('assets/icons/ico_stella1.svg', height: 43, width: 43, fit: BoxFit.scaleDown, color: _stella == 1 ? Colors.orange : Colors.grey),
                                                                                      Text('Voglio viaggiare gratis'),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: SizedBox(
                                                                                width: 120,
                                                                                child: GestureDetector(
                                                                                    onTap: () => setState(() {
                                                                                          _regalare = 0;
                                                                                          _stella = 0;
                                                                                          _dividere = 1;
                                                                                          regalo = "no";
                                                                                          stella = "no";
                                                                                          percentuale = "si";
                                                                                        }),
                                                                                    child: Center(
                                                                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                                      SvgPicture.asset('assets/icons/ico_dividere.svg', height: 43, width: 43, fit: BoxFit.scaleDown, color: _dividere == 1 ? Colors.orange : Colors.grey),
                                                                                      Center(child: Text('Voglio dividere le spese')),
                                                                                    ]))),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Descrizione",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            TextFormField(
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty ||
                                                                                value == "") {
                                                                              return "Inserisci una tua descrizione";
                                                                            }

                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Inserisci una tua descrizione ",
                                                                            border:
                                                                                const OutlineInputBorder(),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                          minLines:
                                                                              1,
                                                                          maxLines:
                                                                              9,
                                                                          autocorrect:
                                                                              false,
                                                                          controller:
                                                                              _descrizione,
                                                                          onChanged:
                                                                              (String value) {
                                                                            descrizione =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Città Attuale",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            TextFormField(
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty ||
                                                                                value == "") {
                                                                              return "Inserisci il nome";
                                                                            }

                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Inserisci la tua città ",
                                                                            border:
                                                                                const OutlineInputBorder(),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                          autocorrect:
                                                                              false,
                                                                          controller:
                                                                              _citta,
                                                                          onChanged:
                                                                              (String value) {
                                                                            citta =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Facebook",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            TextFormField(
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Inserisci il tuo URL Facebook ",
                                                                            border:
                                                                                const OutlineInputBorder(),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                          autocorrect:
                                                                              false,
                                                                          controller:
                                                                              _facebook,
                                                                          onChanged:
                                                                              (String value) {
                                                                            facebook =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Instagram",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            TextFormField(
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Inserisci il handle Instagram ",
                                                                            border:
                                                                                const OutlineInputBorder(),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                          autocorrect:
                                                                              false,
                                                                          controller:
                                                                              _instagram,
                                                                          onChanged:
                                                                              (String value) {
                                                                            instagram =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Situazione Sentimentale",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      FutureBuilder(
                                                                        future:
                                                                            _stoCazzo,
                                                                        builder: (BuildContext
                                                                                context,
                                                                            AsyncSnapshot<String>
                                                                                snapshot) {
                                                                          if (snapshot.connectionState ==
                                                                              ConnectionState.done) {
                                                                            return FormBuilderDropdown<String>(
                                                                              elevation: 1,
                                                                              isExpanded: false,
                                                                              key: _sitSentFormKey,
                                                                              name: 'sitsentimentale',
                                                                              initialValue: snapshot.data,
                                                                              iconDisabledColor: Colors.white,
                                                                              iconEnabledColor: const Color.fromARGB(255, 0, 0, 0),
                                                                              decoration: const InputDecoration(
                                                                                contentPadding: EdgeInsets.all(10),
                                                                                //labelText: "Ricerca per tipologia",
                                                                                hintText: "Seleziona situazione sentimentale",
                                                                                hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                              ),
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                              ),
                                                                              onChanged: (selectedValue) => {
                                                                                setState(() {
                                                                                  sitSentSelected = selectedValue!;
                                                                                })
                                                                              },
                                                                              items: sitsent
                                                                                  .map((attribute) => DropdownMenuItem(
                                                                                        value: attribute,
                                                                                        alignment: AlignmentDirectional.centerStart,
                                                                                        child: Text(attribute),
                                                                                      ))
                                                                                  .toList(),
                                                                              valueTransformer: (val) => val?.toString(),
                                                                            );
                                                                          } else {
                                                                            return const Text("ciao");
                                                                          }
                                                                        },
                                                                      ),
                                                                      const Text(
                                                                        "Viaggiatore Ideale",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 120,
                                                                              child: GestureDetector(
                                                                                onTap: () => setState(() {
                                                                                  _maschio = 1;
                                                                                  _femmina = 0;
                                                                                  _entrambi = 0;
                                                                                  sessoComp = 'uomo';
                                                                                }),
                                                                                child: SvgPicture.asset('assets/icons/ico_maschio.svg', height: 50, width: 50, fit: BoxFit.scaleDown, color: _maschio == 1 ? Colors.orange : Colors.grey),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 120,
                                                                              child: GestureDetector(
                                                                                onTap: () => setState(() {
                                                                                  _maschio = 0;
                                                                                  _femmina = 1;
                                                                                  _entrambi = 0;
                                                                                  sessoComp = 'donna';
                                                                                }),
                                                                                child: SvgPicture.asset('assets/icons/ico_femmina.svg', height: 50, width: 50, fit: BoxFit.scaleDown, color: _femmina == 1 ? Colors.orange : Colors.grey),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 120,
                                                                              child: GestureDetector(
                                                                                onTap: () => setState(() {
                                                                                  _maschio = 0;
                                                                                  _femmina = 0;
                                                                                  _entrambi = 1;
                                                                                  sessoComp = 'entrambi';
                                                                                }),
                                                                                child: SvgPicture.asset('assets/icons/ico_maschiofemmina.svg', height: 50, width: 50, fit: BoxFit.scaleDown, color: _entrambi == 1 ? Colors.orange : Colors.grey),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const Text(
                                                                        "Età Viaggiatore Ideale",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            TextFormField(
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty ||
                                                                                value == "null") {
                                                                              return "Inserisci una età minima";
                                                                            }
                                                                            if (int.parse(value) <=
                                                                                17) {
                                                                              return "L'età non può essere inferiore di 18 anni";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Inserisci una età minima",
                                                                            border:
                                                                                const OutlineInputBorder(),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                          autocorrect:
                                                                              false,
                                                                          controller:
                                                                              _etaMin,
                                                                          onChanged:
                                                                              (String value) {
                                                                            etaMin =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            TextFormField(
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty ||
                                                                                value == "null") {
                                                                              return "Inserisci una età minima";
                                                                            }
                                                                            if (int.parse(value) <=
                                                                                17) {
                                                                              return "L'età non può essere inferiore di 18 anni";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Inserisci una età massima",
                                                                            border:
                                                                                const OutlineInputBorder(),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                          autocorrect:
                                                                              false,
                                                                          controller:
                                                                              _etaMax,
                                                                          onChanged:
                                                                              (String value) {
                                                                            etaMax =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Vacanza Ideale",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: SizedBox(
                                                                                  width: 120,
                                                                                  child: Column(children: [
                                                                                    GestureDetector(
                                                                                      onTap: () => setState(() {
                                                                                        if (campagna == 0) {
                                                                                          campagna = 1;
                                                                                          _campagna = "si";
                                                                                        } else {
                                                                                          campagna = 0;
                                                                                          _campagna = "no";
                                                                                        }
                                                                                      }),
                                                                                      child: SvgPicture.asset('assets/icons/ico_alberi.svg', height: 50, width: 50, fit: BoxFit.scaleDown, color: campagna == 1 ? Colors.orange : Colors.grey),
                                                                                    ),
                                                                                    const Text(
                                                                                      "Campagna",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                  ]))),
                                                                          Expanded(
                                                                              child: SizedBox(
                                                                                  width: 120,
                                                                                  child: Column(children: [
                                                                                    GestureDetector(
                                                                                      onTap: () => setState(() {
                                                                                        if (crociera == 0) {
                                                                                          crociera = 1;
                                                                                          _crociera = "si";
                                                                                        } else {
                                                                                          crociera = 0;
                                                                                          _crociera = "no";
                                                                                        }
                                                                                      }),
                                                                                      child: SvgPicture.asset('assets/icons/ico_nave.svg', height: 50, width: 50, fit: BoxFit.scaleDown, color: crociera == 1 ? Colors.orange : Colors.grey),
                                                                                    ),
                                                                                    const Text(
                                                                                      "Crociera",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                  ]))),
                                                                          Expanded(
                                                                              child: SizedBox(
                                                                                  width: 120,
                                                                                  child: Column(children: [
                                                                                    GestureDetector(
                                                                                      onTap: () => setState(() {
                                                                                        if (cultura == 0) {
                                                                                          cultura = 1;
                                                                                          _cultura = "si";
                                                                                        } else {
                                                                                          cultura = 0;
                                                                                          _cultura = "no";
                                                                                        }
                                                                                      }),
                                                                                      child: SvgPicture.asset('assets/icons/ico_maschere.svg', height: 50, width: 50, fit: BoxFit.scaleDown, color: cultura == 1 ? Colors.orange : Colors.grey),
                                                                                    ),
                                                                                    const Text(
                                                                                      "Cultura",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                  ]))),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: SizedBox(
                                                                                  width: 120,
                                                                                  child: Column(children: [
                                                                                    GestureDetector(
                                                                                      onTap: () => setState(() {
                                                                                        if (mare == 0) {
                                                                                          mare = 1;
                                                                                          _mare = "si";
                                                                                        } else {
                                                                                          mare = 0;
                                                                                          _mare = "no";
                                                                                        }
                                                                                      }),
                                                                                      child: SvgPicture.asset('assets/icons/ico_mare.svg', height: 50, width: 50, fit: BoxFit.scaleDown, color: mare == 1 ? Colors.orange : Colors.grey),
                                                                                    ),
                                                                                    const Text(
                                                                                      "Mare",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                  ]))),
                                                                          Expanded(
                                                                              child: SizedBox(
                                                                                  width: 120,
                                                                                  child: Column(children: [
                                                                                    GestureDetector(
                                                                                      onTap: () => setState(() {
                                                                                        if (montagna == 0) {
                                                                                          montagna = 1;
                                                                                          _montagna = "si";
                                                                                        } else {
                                                                                          montagna = 0;
                                                                                          _montagna = "no";
                                                                                        }
                                                                                      }),
                                                                                      child: SvgPicture.asset('assets/icons/ico_triangoli.svg', height: 50, width: 50, fit: BoxFit.scaleDown, color: montagna == 1 ? Colors.orange : Colors.grey),
                                                                                    ),
                                                                                    const Text(
                                                                                      "Montagna",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                  ]))),
                                                                          Expanded(
                                                                              child: SizedBox(
                                                                                  width: 120,
                                                                                  child: Column(children: [
                                                                                    GestureDetector(
                                                                                      onTap: () => setState(() {
                                                                                        if (ontheroad == 0) {
                                                                                          ontheroad = 1;
                                                                                          _ontheroad = "si";
                                                                                        } else {
                                                                                          ontheroad = 0;
                                                                                          _ontheroad = "no";
                                                                                        }
                                                                                      }),
                                                                                      child: SvgPicture.asset('assets/icons/ico_treno.svg', height: 50, width: 50, fit: BoxFit.scaleDown, color: ontheroad == 1 ? Colors.orange : Colors.grey),
                                                                                    ),
                                                                                    const Text(
                                                                                      "On the Road",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                  ]))),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            60,
                                                                      ),
                                                                      CustomButton(
                                                                        height:
                                                                            45,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        label:
                                                                            "Conferma",
                                                                        onTap:
                                                                            () async {
                                                                          if (_formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            // If the form is valid, display a snackbar. In the real world,
                                                                            // you'd often call a server or save the information in a database.

                                                                            viaggioDB =
                                                                                "$_campagna,$_crociera,$_cultura,$_mare,$_montagna,$_ontheroad";
                                                                            switch (sitSentSelected) {
                                                                              case "Single":
                                                                                sitSentSelected = "sing";
                                                                                break;
                                                                              case "Impegnato/a":
                                                                                sitSentSelected = "impe";
                                                                                break;
                                                                              case "Non dico":
                                                                                sitSentSelected = "no";

                                                                                break;
                                                                            }

                                                                            // log(x);
                                                                            var url =
                                                                                Uri.https('triptoshare.it', 'wp-content/themes/triptoshare/methods.php');
                                                                            var response =
                                                                                await http.post(url, body: {
                                                                              'action': 'aggiorna-profilo-app',
                                                                              'userid': userid,
                                                                              'nome': firstName,
                                                                              'cognome': lastName,
                                                                              'data_nascita': dataState.toString(),
                                                                              'gratis': stella,
                                                                              'regalare': regalo,
                                                                              'dividere': percentuale,
                                                                              'descrizione': descrizione,
                                                                              'citta': citta,
                                                                              'sitsen': sitSentSelected,
                                                                              'sessocomp': sessoComp,
                                                                              'etamin': etaMin,
                                                                              'etamax': etaMax,
                                                                              'sesso': genereScelto,
                                                                              'viaggio': viaggioDB,
                                                                              'facebook': facebook,
                                                                              'instagram': instagram,
                                                                              'foto_profilo': x,
                                                                            });
                                                                            if (response.body ==
                                                                                "ok") {
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SplashPage(testo: 'Profilo Aggiornato')));
                                                                            }
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                duration: const Duration(seconds: 2),
                                                                                behavior: SnackBarBehavior.floating,
                                                                                backgroundColor: Colors.transparent,
                                                                                elevation: 0,
                                                                                content: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    height: 90,
                                                                                    decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                                    child: Row(children: [
                                                                                      const SizedBox(
                                                                                        width: 48,
                                                                                        child: Icon(
                                                                                          Icons.error,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: const [
                                                                                            Text("Errore!", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                                            Text(
                                                                                              "Ci sono uno o più errori nella pagina, controlla i campi e riprova",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                                                                              maxLines: 2,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ]))));
                                                                          }
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ),
                                                        ))),
                                                /*SingleChildScrollView(
                                                  child:
                                                      Column(children: const [
                                                    Text("Abbonamento"),
                                                  ]),
                                                ),*/
                                                ListView(children: [
                                                  Accordion(
                                                    openAndCloseAnimation:
                                                        false,
                                                    initialOpeningSequenceDelay:
                                                        0,
                                                    headerBackgroundColor:
                                                        Colors.orange[800],
                                                    contentBorderColor:
                                                        Colors.orange,
                                                    contentBackgroundColor:
                                                        Colors.transparent,
                                                    children: [
                                                      AccordionSection(
                                                        isOpen: false,
                                                        leftIcon: const Icon(
                                                            Icons.info,
                                                            color:
                                                                Colors.white),
                                                        header: const Text(
                                                          'Privacy Policy',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        content: Column(
                                                          children: [
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.orange[
                                                                        800],
                                                              ),
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Dialog(
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Container(
                                                                            color:
                                                                                Colors.white,
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              child: Padding(
                                                                                padding: EdgeInsets.all(20),
                                                                                child: Html(
                                                                                  data: '<p>PRIVACY E COOKIES La presente Informativa sulla Privacy ha lo scopo di descrivere le modalit&agrave; di gestione di questo sito, in riferimento al trattamento dei dati personali degli utenti/visitatori che lo consultano. Si tratta di un&rsquo;informativa resa ai sensi del D. Lgs. 196/2003 (Codice in materia di protezione dei dati personali), cos&igrave; come integrato e modificato dal Regolamento UE 2016/679 (REGOLAMENTO GENERALE SULLA PROTEZIONE DEI DATI), a coloro che si collegano al presente sito web e usufruiscono dei relativi servizi web a partire dall&rsquo;indirizzo www.triptoshare.it. L&rsquo;informativa &egrave; resa soltanto per tale sito e non anche per altri siti web eventualmente consultati dall&rsquo;utente tramite appositi link. Il sito www.triptoshare.it &egrave; di propriet&agrave; di Triptoshare s.r.l.s. che garantisce il rispetto della normativa in materia di protezione dei dati personali. Gli utenti/visitatori dovranno leggere attentamente la presente Informativa prima di inoltrare qualsiasi tipo di informazione personale e/o compilare qualunque modulo elettronico presente sul sito stesso.</p><p>TIPOLOGIA DI DATI TRATTATI Dati di navigazione</p><p>I sistemi informatici e le procedure software preposte al funzionamento di questo sito acquisiscono, nel normale esercizio, alcuni dati personali che vengono poi trasmessi implicitamente nell&rsquo;uso dei protocolli di comunicazione Internet. Si tratta di informazioni che non sono raccolte per essere associate a interessati identificati, ma che per loro stessa natura potrebbero, attraverso elaborazioni e associazioni con dati detenuti da terzi, permettere di identificare gli utenti. In questa categoria di dati rientrano gli indirizzi IP o i nomi a dominio dei computer utilizzati dagli utenti che si connettono al sito, gli indirizzi in notazione URI (Uniform Resource Identifier) delle risorse richieste, l&rsquo;orario della richiesta, il metodo utilizzato nel sottoporre la richiesta al server, la dimensione del file ottenuto in risposta, il codice numerico indicante lo stato della risposta data dal server (buon fine, errore, ecc.) ed altri parametri relativi al sistema operativo e all&rsquo;ambiente informatico dell&rsquo;utente. Questi dati vengono utilizzati al solo fine di ricavare informazioni statistiche anonime sull&rsquo;uso del sito e per controllarne il corretto funzionamento e vengono cancellati immediatamente dopo l&rsquo;elaborazione.</p><p>Dati forniti volontariamente dagli utenti/visitatori</p><p>Qualora gli utenti/visitatori, collegandosi a questo sito, inviino propri dati personali per accedere ai servizi proposti, ovvero per effettuare richieste, ci&ograve; comporta l&rsquo;acquisizione da parte di Triptoshare.it dell&rsquo;indirizzo del mittente e di altri eventuali dati personali (es. nome, recapiti di contatto, eventuali nomi di partecipanti al viaggio). A tale riguardo, avvisiamo gli utenti che dati, dichiarazioni e contenuti che ci sottopongono e che possono caricare sul nostro portale potrebbero risultare &ldquo;sensibili&rdquo; ai sensi del D.Lgs n. 196/2003 e rivelare informazioni sugli utenti stessi, quali, in via meramente esemplificativa e non esaustiva: sesso, et&agrave;, religione, nazionalit&agrave;, luogo di residenza, professione.</p><p>Gli utenti, nella compilazione delle caselle di profilazione personale, avranno la facolt&agrave; di inserire dati personali relativi all&rsquo;orientamento sessuale. In tal caso, in conformit&agrave; all&rsquo;art. 9 del Regolamento 679/2016, dovranno prestare il proprio consenso esplicito al trattamento di tali dati per le finalit&agrave; di cui al successivo articolo 2.</p><p>Informazioni personali ricevute da altre fonti</p><p>Oltre alle informazioni fornite direttamente, altre informazioni personali relative agli utenti potrebbero essere ricevute tramite altre fonti, per esempio partner commerciali e partner affiliati i cui servizi possono essere integrati nella piattaforma di Triptoshare.it, nonch&eacute; altre terze parti indipendenti. L&rsquo;utilizzo dei social media pu&ograve; essere integrato nei servizi di Triptoshare.it, implicando la raccolta di dati personali da parte di Triptoshare.it o la ricezione di alcuni dati personali da parte del social media specifico.</p><p>FINALIT&Agrave; DEL TRATTAMENTO I dati raccolti da Triptoshare sono finalizzati all&rsquo;espletamento dei servizi offerti da Triptoshare.it e allo svolgimento di ogni attivit&agrave; prevista nelle Condizioni Generali e Termini d&rsquo;Uso sottoscritte dall&rsquo;utente e da intendersi qui integralmente richiamate e trascritte. Nell&rsquo;ambito di tali servizi, segnaliamo che i dati personali potranno: (a) essere comunicati ad altri utenti e/o a terzi per le finalit&agrave; previste dal Sito, progettato espressamente per consentire agli utenti/visualizzatori di condividere viaggi e vacanze e pertanto di conoscersi inviando fotografie e informazioni; (b) essere utilizzati per contattare l&rsquo;utente al fine di informarlo sui servizi prestati, su offerte speciali e altre informazioni, incluse a carattere promozionale, relative ai prodotti trattati; (b) essere comunicati a terzi nel caso in cui la comunicazione sia necessaria per ottemperare alle richieste degli utenti/visitatori medesimi, comprese le richieste di invio di materiale informativo; (c) essere comunicati a terze parti coinvolte nella fornitura dei servizi resi da Triptoshare.it, quali, a titolo esemplificativo, compagnie di navigazione, compagnie aeree, strutture alberghiere, agenzie, societ&agrave; di car rental e qualsiasi azienda che fornisca servizi nel settore turistico e dei viaggi. Le informazioni personali potranno inoltre essere utilizzate per scopi amministrativi, legali o per rilevamento di frodi e pertanto comunicati alle autorit&agrave; competenti. I dati raccolti sono, altres&igrave;, finalizzati al trattamento per attivit&agrave; commerciali, pubblicitarie, promozionali e di marketing da parte di persone fisiche e giuridiche che collaborino con Triptoshare in attivit&agrave; commerciali o che abbiano in essere rapporti contrattuali di prestazioni di servizi (di seguito definiti semplicemente &ldquo;partner commerciali&rdquo;).</p><p>MODALIT&Agrave; DEL TRATTAMENTO I dati personali sono trattati con strumenti automatizzati per il tempo strettamente necessario a conseguire gli scopi per cui sono stati raccolti. In conformit&agrave; con le leggi europee in materia di protezione dei dati, specifiche procedure e misure di sicurezza sono osservate per prevenire la perdita dei dati, usi illeciti o non corretti ed accessi non autorizzati.</p><p>FACOLTATIVIT&Agrave; DEL CONFERIMENTO DEI DATI Salvo quanto specificato per i dati di navigazione, gli utenti/visitatori sono liberi di fornire i propri dati personali. Il loro mancato conferimento pu&ograve; comportare unicamente l&rsquo;impossibilit&agrave; di ottenere i servizi offerti da Triptoshare o quanto altro richiesto.</p><p>LUOGO DI TRATTAMENTO DEI DATI I trattamenti connessi ai servizi web del sito hanno luogo presso la sede secondaria di Triptoshare s.r.l.s, Titolare del Trattamento, in Roma, via dei Rutoli n. 35, e/o presso la sede della societ&agrave; di hosting e/o gestione del sito web e sono curati solo da personale tecnico dell&rsquo;Ufficio incaricato del trattamento, oppure da eventuali incaricati di occasionali operazioni di manutenzione.</p><p>DIRITTI DEGLI INTERESSATI I soggetti cui si riferiscono i dati personali hanno il diritto in qualunque momento di ottenere la conferma dell&rsquo;esistenza o meno dei medesimi dati e di conoscerne il contenuto e l&rsquo;origine, verificarne l&rsquo;esattezza o chiederne l&rsquo;integrazione l&rsquo;aggiornamento, oppure la rettificazione (art. 7 del D. Lgs. 196/03). Ai sensi del medesimo articolo si ha il diritto di chiedere la cancellazione, la trasformazione in forma anonima o il blocco dei dati trattati in violazione di legge, nonch&eacute; di opporsi in ogni caso, per motivi legittimi, al loro trattamento.</p><p>INFORMATIVA ESTESA SULL&rsquo;UTILIZZO DEI COOKIES Si rende noto agli utenti che il Sito fa ricorso all&rsquo;utilizzo della tecnologia c.d. cookies di tipo tecnico e di tipo analytics, consistenti in informazioni che possono venire memorizzate dal browser sul disco rigido con la finalit&agrave; di tracciare i percorsi all&rsquo;interno del Sito, rendendo l&rsquo;utente riconoscibile ad ogni successivo accesso, senza tuttavia involgere in alcun modo il trattamento di dati di carattere personale. Attraverso le funzioni messe a disposizione dal proprio browser, ovvero accedendo all&rsquo;apposita funzione messa a disposizione dal Sito, potr&agrave; disattivare i cookies specificamente individuati, ovvero negare il consenso tout court all&rsquo;installazione di qualsiasi cookies, con l&rsquo;avvertimento che tali azioni potranno implicare rallentamenti o limitazioni o perdite di efficienza nell&rsquo;utilizzo del Sito. Si ribadisce che qualsiasi operazione di navigazione sul sito, successivamente alla presa visione della c.d. informativa breve, deve considerarsi quale esplicito consenso dell&rsquo;utente all&rsquo;utilizzo dei cookies.</p><p>CONSENSO AL TRATTAMENTO DEI DATI PERSONALI PER LE FINALITA&rsquo; DI CUI ALL&rsquo;INFORMATIVA Ai sensi e per gli effetti del D.Lgs 196/2003 (normativa sulla privacy applicabile), presa visione dell&rsquo;Informativa sopra riportata, mediante click sul pulsante &ldquo;acconsento&rdquo;, esprimo il consenso al trattamento dei dati personali per le finalit&agrave; sopra indicate e dichiaro di aver ricevuto informativa in merito: (art. 1) alla tipologia dei dati, (art. 2) alle finalit&agrave; del trattamento dei dati personali e/o sensibili e all&rsquo;ambito di comunicazione e diffusione dei dati; (art. 3) alle modalit&agrave; del trattamento; (art. 4.) alla natura del conferimento dei dati e conseguenze del rifiuto a rispondere; (art. 5.) agli estremi identificativi dei titolari e del responsabile del trattamento dei dati personali; (art. 6.) ai diritti di cui all&rsquo;art. 7 del D.Lgs n. 196/2003; (art. 7.) Informativa estesa sull&rsquo;utilizzo dei cookies</p>',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            right:
                                                                                10,
                                                                            top:
                                                                                10,
                                                                            child:
                                                                                IconButton(
                                                                              icon: Icon(Icons.close),
                                                                              onPressed: () => Navigator.of(context).pop(),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Text(
                                                                  'Privacy Policy'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      AccordionSection(
                                                        isOpen: false,
                                                        leftIcon: const Icon(
                                                            Icons.contact_mail,
                                                            color:
                                                                Colors.white),
                                                        header: const Text(
                                                          'Contatti',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        content: Wrap(
                                                            children: [
                                                              Column(
                                                                children: const [
                                                                  Text(
                                                                      "Indirizzo Email TripToShare",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          fontSize:
                                                                              16)),
                                                                  Text(
                                                                      "info@triptoshare.it"),
                                                                  Text(
                                                                      "Ragione Sociale",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          fontSize:
                                                                              16)),
                                                                  Text(
                                                                      "SHARINGPLAT S.R.L."),
                                                                  Text(
                                                                      "P.IVA: 04937900753"),
                                                                ],
                                                              ),
                                                            ]),
                                                      ),
                                                      AccordionSection(
                                                        isOpen: true,
                                                        leftIcon: const Icon(
                                                            Icons.contact_mail,
                                                            color:
                                                                Colors.white),
                                                        header: const Text(
                                                          'Strumenti',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        content: Wrap(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  ElevatedButton(
                                                                    style: TextButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors.redAccent),
                                                                    onPressed:
                                                                        () async {
                                                                      bool confirm = await showDialog(
                                                                          context: context,
                                                                          builder: (context) {
                                                                            return AlertDialog(
                                                                              title: Text("Conferma cancellazione account"),
                                                                              content: Text("Sei sicuro di voler cancellare il tuo account? Questa azione non è reversibile."),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.of(context).pop(false),
                                                                                  child: Text("Annulla"),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.of(context).pop(true),
                                                                                  child: Text("Conferma"),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          });
                                                                      if (confirm ==
                                                                          true) {
                                                                        // eseguire l'azione di cancellazione dell'account
                                                                        var url = Uri.https(
                                                                            'triptoshare.it',
                                                                            'wp-content/themes/triptoshare/methods.php');
                                                                        var response = await http.post(
                                                                            url,
                                                                            body: {
                                                                              'action': 'cancella-utente',
                                                                              'userId': userid,
                                                                            });

                                                                        print(response
                                                                            .body);
                                                                        SharedPreferences
                                                                            prefs =
                                                                            await SharedPreferences.getInstance();
                                                                        String?
                                                                            uid =
                                                                            prefs.getString('UUID');
                                                                        try {
                                                                          // rimuovere l'utente da Firestore
                                                                          // await FirebaseFirestore.instance.collection('users').doc(uid).delete();

                                                                          // eliminare l'utente dall'autenticazione
                                                                          User user = FirebaseAuth
                                                                              .instance
                                                                              .currentUser!;
                                                                          await user
                                                                              .delete();
                                                                        } catch (e) {
                                                                          print(
                                                                              'Errore durante la cancellazione dell\'utente: $e');
                                                                          // gestire l'errore
                                                                        }
                                                                        HelperFunctions.cancellaUtenteFirebase(
                                                                            uid);
                                                                        if (response.body ==
                                                                            "ok") {
                                                                          var deviceToken = await FirebaseMessaging
                                                                              .instance
                                                                              .getToken();

                                                                          await HelperFunctions.removeDeviceToken(
                                                                              userid,
                                                                              deviceToken);
                                                                          await prefs
                                                                              .remove('userId')
                                                                              .then(
                                                                                (value) => Navigator.of(context).push(
                                                                                  MaterialPageRoute(builder: (_) => const Login()),
                                                                                ),
                                                                              );
                                                                        }
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        "Cancella Account",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            fontSize: 16)),
                                                                  )
                                                                ],
                                                              ),
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ])
                            ]))))));
  }
}
