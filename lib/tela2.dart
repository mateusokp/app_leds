import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'conectar.dart';
import 'globals.dart' as globals;

class Tela2Demo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<Tela2Demo> {

  double seconds;


  _currentTime() {
    DateTime now = DateTime.now();
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
    if (globals.Conectado == true) {
      _triggerUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (globals.Conectado == true) {
      return Scaffold(
        body: Container(
          color: Colors.black45,
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
                      color: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                      margin: const EdgeInsets.all(25.0),
                      width: 340,
                      height: 340,
                      child: Center(
                        child: Text(
                          _currentTime(),
                          style: GoogleFonts.roboto(
                              fontSize: 60.0,
                              textStyle: TextStyle(color: Colors.white),
                              fontWeight: FontWeight.normal),
                        ),
                      )),
                ),
                Center(
                  child: CircularPercentIndicator(
                    radius: 220.0,
                    lineWidth: 6.0,
                    animation: true,
                    animationDuration: 0,
                    percent: seconds,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: hexToColor('#2c3143'),
                    progressColor: hexToColor('#58CBF4'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }else {
      return TelaConexao();
    }
  }
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}