import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class TelaConexao extends StatefulWidget{
  const TelaConexao({ Key key }) : super(key: key);
@override
_Tela3Demo createState() => _Tela3Demo();
}
class _Tela3Demo extends State<TelaConexao>{
  bool get wantKeepAlive => true;
  int Temp = globals.TempCor.toInt(), Luz = globals.IntLuz.toInt();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey
      ),
      home: Container(

        child: Scaffold(
          body: Center(
            child: Container(
              padding: new EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SizedBox(height: 120),
                  Text('Desconectado',
                    style: TextStyle(
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 40)),
                  SizedBox(height: 20),
                  Text('Favor conecte-se a rede "NodeMCU" e reinicie o aplicativo',
                      textAlign: TextAlign.center,
                      style: TextStyle(

                        color: Colors.white70,
                        fontSize: 25)) ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}