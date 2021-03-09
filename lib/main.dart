import 'package:flutter/material.dart';
import 'tela1.dart';
import 'tela2.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:wifi/wifi.dart';
import 'package:gateway/gateway.dart';
import 'package:flutter/services.dart';


void main() async {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
  _tcp();
  globals.ssidAtual = await Wifi.ssid;
}



void _tcp() async{

  while(globals.Conectado == false){
    Gateway gt = await Gateway.info;
    String ip = await Wifi.ip;
    var listip = ip.split('.');
    print(gt);
    String ssidd = await Wifi.ssid;
    print(ssidd);
    String dados;
    // ${listip[2]}
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
      globals.Conectado = false;
      socket.close();
    }else if (globals.EnviarDados == true){
      globals.EnviarDados = false;
      String _ssid = globals.Ssid, _senha = globals.Senha;
      socket.add(utf8.encode('1,$_ssid,$_senha'));
      await Future.delayed(Duration(seconds: 2));
      globals.Conectado = false;
      socket.close();
    }


  }
}

var _scaffoldKey = new GlobalKey<ScaffoldState>();


void _showAlertDialog1()
{
  showDialog(
    context: _scaffoldKey.currentContext,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Instruções de Uso"),
        content: Container(
          child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
             children:<Widget>[ Image.asset('images/esp32.png'),
               Text("Para realizar a primeira conexão, siga os passos: \n\n"
                   "\u02D6 Ligue o controlador e espere o LED azul acender.\n\n"
                   "\u02D6 Conecte seu aparelho com a rede WiFi \"NodeMCU\"\n\n"
                   "\u02D6 Reinicie o aplicativo\n\n"
                   "\u02D6 Aperte o botão \"Enviar credenciais Wi-Fi\" e preencha com os dados de sua rede doméstica\n\n"
                   "\u02D6 Aguarde alguns segundos, caso o LED azul acender, tente novamente do início. Caso contrário, volte para sua rede doméstica e reinicie o aplicativo.\n\n"),
               Text("Usabilidade\n\n",
                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
               Row(
                   children: [
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Text("Modo Manual  ",
                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                     ),
                     Icon(Icons.settings_input_component)
                   ]
               ),
               Text("\nNeste modo de operação, o usuário deve estabelecer periodicamente a temperatura de cor (esquerda) e fluxo luminoso (direita) desejados por meio dos dois sliders na tela.\n\n"),
               Row(
                   children: [
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Text("Modo Automático  ",
                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                     ),
                     Icon(Icons.schedule)
                   ]
               ),
               Text("\nNeste modo de operação, os parâmetros serão modificados conforme o horário atual. Para ativá-lo, basta deixar o botão Modo Automático na cor verde."),

             ]
            ),
          ),
        ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Fechar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
      children: [
        DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child:TabBar(
              tabs: [
                Tab(icon: Icon(Icons.settings_input_component)),
                Tab(icon: Icon(Icons.schedule)),
              ],
            ),),
            title: Text('Controle LEDs'),
          ),),
          body: TabBarView(
            children: [
              Tela1(),
              Tela2Demo(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAlertDialog1();
              // Add your onPressed code here!
            },
            child: Icon(Icons.help_outline),
            backgroundColor: Colors.blue,
          ),
        ),
      ),

    ])
    );
  }
}
