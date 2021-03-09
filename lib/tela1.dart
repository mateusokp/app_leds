import 'package:app_leds/presentation/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'presentation/my_flutter_app_icons.dart';
import 'globals.dart' as globals;
import 'conectar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void _showAlertDialog1(context)
{
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Atenção"),
        content: Container(
          height: MediaQuery.of(context).size.height/17,
          child: Text("Por favor digite uma senha de pelo menos oito dígitos"),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

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
            if (Senhacontroller.text.runes.length < 8){
              _showAlertDialog1(context);
            }else{
              globals.Ssid = Ssidcontroller.text;
              globals.Senha = Senhacontroller.text;
              globals.EnviarDados = true;
              Navigator.pop(context);
            }
            },
          child: Text(
            "ENVIAR",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}


class Tela1 extends StatefulWidget{
  const Tela1({ Key key }) : super(key: key);
  @override
  _Tela1Demo createState() => _Tela1Demo();
}

class _Tela1Demo extends State<Tela1>{
  bool get wantKeepAlive => true;

  int Temp = globals.TempCor.toInt(), Luz = globals.IntLuz.toInt();
  String ssid = globals.ssidAtual;
  Color CorProx = Color.fromRGBO(255, 241, 224, 1);
  double _Opacidade = 0.0;
  @override


  Widget build(BuildContext context) {
   // if(globals.Conectado == true) {
      return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blue,
            backgroundColor: Colors.black
        ),
          home:Scaffold(
            body: Center(
              child: Stack(
              children: [
                Container(color: Colors.black,),
                AnimatedOpacity(
                duration: Duration(milliseconds: 400),
                opacity: _Opacidade,
              child: AnimatedContainer(
                color:CorProx,
                duration: Duration(milliseconds: 400),
              ),),
                Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: Color(0xff303030).withOpacity(0.54),
                                    border: Border.all(
                                      color: Color(0xff303030).withOpacity(0.54),
                                    ),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                height: MediaQuery.of(context).size.height-180-20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("CCT"),
                                    SizedBox(height: 5),
                                    Icon(Icons.ac_unit),
                                    Expanded(
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                          child: Slider(
                                          value: globals.TempCor,
                                          min: 4100,
                                          max: 6500,
                                          divisions: 240,
                                          onChanged: (value) {
                                            if (value < 5200 ){
                                              CorProx = Color.fromRGBO(255, 241, 224, 1);
                                            }else if (value < 5400){
                                              CorProx = Color.fromRGBO(255, 250, 244, 1);
                                            }else if (value < 6000){
                                              CorProx = Color.fromRGBO(255, 255, 251, 1);
                                            }else{
                                              CorProx = Color.fromRGBO(255, 255, 255, 1);
                                            }
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
                              ),),
                     Container(
                       padding: EdgeInsets.all(5.0),
                       decoration: BoxDecoration(
                           color: Color(0xff303030).withOpacity(0.54),
                           border: Border.all(
                             color: Color(0xff303030).withOpacity(0.54),
                           ),
                           borderRadius: BorderRadius.all(Radius.circular(20))
                       ),
                      height: MediaQuery.of(context).size.height-180-20,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Fluxo"),
                          SizedBox(height: 5),
                          Icon(Icons.brightness_high),
                          Expanded(
                            child: RotatedBox(
                            quarterTurns: 3,
                              child: Slider(
                                value: globals.IntLuz,
                                min: 250,
                                max: 1000,
                                divisions: 75,
                                onChanged: (value) {
                                  _Opacidade = (value-250) / (1000-250) ;
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
                    ),),]),),

                    Expanded(
                      child: Align(
                        alignment: Alignment(0,1),
                        child:  Container(
                        child: RaisedButton(
                            onPressed:(){ _openPopup(context);  },
                            child:Text('Enviar credenciais Wi-Fi'),
                          ),
                        ),),),
                  ]),
                )
              ]),
            ),
          ),
      );
  //   }
  // else{
  //  return TelaConexao();
  //  }
  }
}
