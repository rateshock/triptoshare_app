import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:tripapp/components/app_bar.dart';
import 'package:tripapp/components/helper.dart';

class TourOp extends StatefulWidget {
  const TourOp({Key? key}) : super(key: key);

  @override
  State<TourOp> createState() => _TourOpState();
}

class _TourOpState extends State<TourOp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _zoneController = TextEditingController();

  void _sendData() async {
    String result = await HelperFunctions.sendMail(
      email: _emailController.text,
      name: _nameController.text,
      description: _descriptionController.text,
      zone: _zoneController.text,
    );

    // Handle the response (e.g., show a success or error message based on the result)
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _zoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TripAppBar(hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Sei un Tour Operator?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Se sei un tour operator, lascia qui i tuoi contatti e ti ricontatteremo per darti il tuo account.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci email valida';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome di riferimento'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci un nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrizione'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci una descrizione';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _zoneController,
                decoration: InputDecoration(labelText: 'Zona'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci una zona';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Dati inviati con successo'),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 255, 68, 0)),
                ),
                child: Text('Invia i dati'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
