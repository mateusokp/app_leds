import 'package:flutter/material.dart';
import 'globals.dart' as globals;











class TelaEnviar extends StatefulWidget{
  const TelaEnviar({ Key key }) : super(key: key);
  @override
  _Tela4Demo createState() => _Tela4Demo();
}
class _Tela4Demo extends State<TelaEnviar>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController Ssidcontroller = TextEditingController();
  TextEditingController Senhacontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey
    ),
      home: Container(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Center(
              child: SingleChildScrollView(
              child: Container(
                padding: new EdgeInsets.all(25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Forneça os dados de sua rede doméstica',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 30)),
                      TextFormField(
                        controller: Ssidcontroller,
                        decoration: const InputDecoration(
                          hintText: 'Nome da rede',
                        ),
                        validator: (value1) {
                          if (value1.isEmpty) {
                            return 'Por favor digite algo';
                          }
                          return value1;
                        },
                      ),
                      TextFormField(
                        controller: Ssidcontroller,
                        decoration: const InputDecoration(
                          hintText: 'Senha',
                        ),
                        validator: (value2) {
                          if (value2.isEmpty) {
                            return 'Por favor digite algo';
                          }
                          return value2;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState.validate()) {
                              globals.Ssid = Ssidcontroller.text;
                              globals.Senha = Senhacontroller.text;
                            }
                          },
                          child: Text('Enviar'),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ),),
      ),
    ),
    );
  }
}