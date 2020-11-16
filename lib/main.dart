import 'package:flutter/material.dart';
import 'tela1.dart';
import 'tela2.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:wifi/wifi.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'dart:developer';



void main() async {
  runApp(MyApp());
  _tcp();
  //_ports();
}

void _ports() async{

  final String ip = await Wifi.ip;
  final String subnet = ip.substring(0, ip.lastIndexOf('.'));
  final int port = 555;

  final stream = NetworkAnalyzer.discover(subnet, port);
  stream.listen((NetworkAddress addr) async{

    if (addr.exists) {
      Socket socket = await Socket.connect(addr.ip, 555);
      socket.add(utf8.encode('\nACHEI SEU IP'));
      log('Found device: ${addr.ip}');
      socket.close();
    }
  });
}

void _tcp() async{


  while(globals.Conectado == false && globals.Esp_ip != ''){
    String dados;
    Socket socket = await Socket.connect('192.168.1.218', 555);
    globals.Conectado = true;
    socket.listen((bytes) {
      dados = utf8.decode(bytes);
    });


    if(globals.EnviarDados == false) {

      int _Temp = globals.TempCor.toInt(),
          _Luz = globals.IntLuz.toInt();
      bool _Modo = globals.Mode;

      int hora = DateTime.now().hour, minuto = DateTime.now().minute;
      socket.add(utf8.encode('0,$_Temp,$_Luz,$hora:$minuto,$_Modo'));
      await Future.delayed(Duration(seconds: 2));
      socket.close();
      globals.Conectado = false;
    }else if (globals.EnviarDados == true){
      Socket socket = await Socket.connect('192.168.4.1', 555);
      String _ssid = globals.Ssid, _senha = globals.Senha;
      socket.add(utf8.encode('1,$_ssid,$_senha'));
      globals.EnviarDados = false;
      await Future.delayed(Duration(seconds: 2));
      socket.close();
      globals.Conectado = false;
    }


  }
}




class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
      children: [DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.settings_input_component)),
                Tab(icon: Icon(Icons.schedule)),
              ],
            ),
            title: Text('Controle LEDs'),
          ),
          body: TabBarView(
            children: [
              OMaisPica(),
              Tela2Demo(),
            ],
          ),
        ),
      ),

    ])
    );
  }
}
