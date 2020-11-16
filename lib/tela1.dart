import 'package:app_leds/presentation/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'presentation/my_flutter_app_icons.dart';
import 'globals.dart' as globals;
import 'conectar.dart';
import 'enviar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';
import 'dart:async';

_openPopup(context) {
  TextEditingController Ssidcontroller = TextEditingController();
  TextEditingController Senhacontroller = TextEditingController();

  Alert(
      context: context,
      title: "Forneça os dados de sua rede doméstica",
      content: Column(
        children: <Widget>[
          TextField(
            controller: Ssidcontroller,
            decoration: InputDecoration(
              icon: Icon(Icons.wifi),
              labelText: 'SSID',
            ),
          ),
          TextField(
            controller: Senhacontroller,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Senha',
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            globals.Ssid = Ssidcontroller.text;
            globals.Senha = Senhacontroller.text;
            globals.EnviarDados = true;
            Navigator.pop(context);
          },
          child: Text(
            "ENVIAR",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}


class OMaisPica extends StatefulWidget{
  const OMaisPica({ Key key }) : super(key: key);
  @override
  _Tela1Demo createState() => _Tela1Demo();
}

class _Tela1Demo extends State<OMaisPica>{
  bool get wantKeepAlive => true;
  int Temp = globals.TempCor.toInt(), Luz = globals.IntLuz.toInt();
  @override
  Widget build(BuildContext context) {
    if(globals.Conectado == true) {
      return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blueGrey
        ),
        home: Stack(
          children: [
          Scaffold(
            body: Center(
              child: Container(
                padding: new EdgeInsets.all(25.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.ac_unit),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Container(
                                width: 400,
                                child: Slider(
                                  value: globals.TempCor,
                                  min: 4100,
                                  max: 6500,
                                  divisions: 240,
                                  onChanged: (value) {
                                    setState(() {
                                      globals.TempCor = value;
                                      Temp = value.toInt();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Icon(MyFlutterApp.fire),
                            Text('$Temp'),
                          ]
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.brightness_high),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Container(
                                width: 400,
                                child: Slider(
                                  value: globals.IntLuz,
                                  min: 250,
                                  max: 1000,
                                  divisions: 75,
                                  onChanged: (value) {
                                    setState(() {
                                      globals.IntLuz = value;
                                      Luz = value.toInt();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Icon(Icons.brightness_low),
                            Text('$Luz'),
                          ]
                      ),
                    ]
                ),
              ),


            )
        ),
            Container(
              margin: EdgeInsets.only(top:510,left:122),
              child: RaisedButton(
                  onPressed:(){ _openPopup(context);  },
                  child:Text('ENVIAR DADOS WIFI'),
              ),
            ),
      ]),);
    }
  else{
    return TelaConexao();
    }
  }
}
