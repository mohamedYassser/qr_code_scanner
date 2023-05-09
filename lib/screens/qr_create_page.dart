import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCreatePage extends StatefulWidget {
  const QrCreatePage({Key? key}) : super(key: key);

  @override
  State<QrCreatePage> createState() => _QrCreatePageState();
}

class _QrCreatePageState extends State<QrCreatePage> {
  final controllerQrText = TextEditingController();
  final _formKet = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromRGBO(39, 48, 56, 1),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImage(
                      size: 250,
                      backgroundColor: Colors.white,
                      data: controllerQrText.text),
                  const SizedBox(height: 40),
                  buildTextField(context, controllerQrText),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildTextField(BuildContext context, controllerQrText) =>
      TextFormField(
          key: _formKet,
          controller: controllerQrText,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            focusColor: Colors.cyanAccent,
            hintText: "Enter Data",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.cyanAccent,
              ),
            ),
            suffixIcon: IconButton(
              color: Colors.cyanAccent,
              focusColor: Colors.cyanAccent,
              onPressed: () => setState(
                () {},
              ),
              icon: const Icon(Icons.done),
              iconSize: 20,
            ),
          ));
}
