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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Desconectado',
                    style: TextStyle(
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
                  SizedBox(height: 20),
                  Text('Por favor clique no botão de ajuda e siga as instruções',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 25)) ],),
            ),
            ),
          ),
        ),
      );
  }
}