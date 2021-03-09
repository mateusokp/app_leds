import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'conectar.dart';
import 'globals.dart' as globals;
import 'package:timer_builder/timer_builder.dart';

class Tela2Demo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<Tela2Demo> {

  double seconds, _Opacidade = 1.0;
  Color CorProx = Color.fromRGBO(0, 0, 0, 1);
  int hour;
  bool carregado = false;

  _currentTime() {
    DateTime now = DateTime.now();
    hour = int.parse(DateFormat('kk').format(now));
    return "${DateFormat('kk:mm').format(now)}";
  }

  _triggerUpdate() {
    Timer.periodic(
        Duration(seconds: 1),
            (Timer timer) => setState(
              () {
            seconds = DateTime.now().second / 60;

          },
        ));
  }

  @override
  void initState() {
    super.initState();
    seconds = DateTime.now().second / 60;
  }

  @override
  Widget build(BuildContext context) {
    // if (globals.Conectado == true) {
      carregado = true;
      return Scaffold(
          body: Center(
            child: Stack(
              children: [


                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 400),
                          opacity: _Opacidade,
                          child: AnimatedContainer(
                            color: CorProx,
                            duration: Duration(milliseconds: 400),
                          ),
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle,
                            ),
                            child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                              return CircularPercentIndicator(
                                  radius: 220.0,
                                  lineWidth: 6.0,
                              animation: true,
                              animationDuration: 0,
                              percent: seconds,
                              circularStrokeCap: CircularStrokeCap.round,
                              backgroundColor: Colors.black54,
                              progressColor: Colors.lightBlue,
                            );}),
                          ),
                        ),
                        Center(
                          child: Container(
                              margin: const EdgeInsets.all(25.0),
                              width: 340,
                              height: 340,
                              child: Center(
                                child:TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                                  seconds = DateTime.now().second / 60;
                                  return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:[
                                        Text(
                                      "${_currentTime()}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 50.0,
                                        textStyle: TextStyle(color: Colors.white),
                                        fontWeight: FontWeight.normal),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text("${(seconds*60).toInt()}",
                                          style: GoogleFonts.roboto(
                                            fontSize: 20.0,
                                            textStyle: TextStyle(color: Colors.white),
                                            fontWeight: FontWeight.normal),)
                                    )
                                    ]);
                                }),
                              )),
                        ),
                        Column(
                          children:[ Expanded(
                            child: Align(
                              alignment: Alignment(0,1),
                                  child: Container(
                                    child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5.0),
                                            side: BorderSide(color: globals.Mode ? Colors.green : Colors.red)),
                                        color: globals.Mode ? Colors.green : Colors.red,
                                        textColor: Colors.white,
                                        child: globals.Mode ? Text("Modo automático ATIVADO") : Text("Modo automático DESATIVADO"),
                                        onPressed: () {
                                          if (globals.Mode == false){
                                            if(hour > 8 && hour < 14){
                                              CorProx = Color.fromRGBO(255, 250, 244, 1);
                                              _Opacidade = 0.7;
                                            }else if(hour < 17){
                                              CorProx = Color.fromRGBO(255, 241, 224, 1);
                                              _Opacidade = 0.6;
                                            }else{
                                              CorProx = Color.fromRGBO(255, 214, 170, 1);
                                              _Opacidade = 0.5;
                                            }
                                          }else{
                                            CorProx = Color.fromRGBO(0, 0, 0, 1);
                                            _Opacidade = 1.0;
                                          }
                                          setState(() {
                                            globals.Mode = !globals.Mode;
                                          });
                                        }
                                    ),
                                  ),
                              ),
                          ),
                          ])
                      ]
                    ),
                  ),
                ),
              ]),
          ),
      );
    // }
    //   else {
    //   return TelaConexao();
    // }
 }
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}