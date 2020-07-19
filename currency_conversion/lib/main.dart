import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const requestApi = "https://api.hgbrasil.com/finance?key=5e2c67b0";

void main() async {

  runApp(MaterialApp(

    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
      )),
  ));
}

Future<Map> getData() async {
  http.Response responseApi = await http.get(requestApi);
  return json.decode(responseApi.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);

  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

  }

  void _clearAll(){
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor de moeda \$",
          style: TextStyle(fontFamily: 'Ubunto_Regular'),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber
      ),
      
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
        color: Colors.amber,
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _clearAll,
        tooltip: 'Limpar Campos',
        child: 
          Icon(Icons.clear_all),
          backgroundColor: Colors.amber[700],
     ),

     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
      
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    "Error :(",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20.0),
                    textAlign: TextAlign.center,
                  )
                );
              }else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 100,
                        color: Colors.amber),
                      
                      buildTextField("Reais", "R\$ ", realController, _realChanged),

                      Divider(),

                      buildTextField("Dolares", "US ", dolarController, _dolarChanged),

                      Divider(),

                      buildTextField("Euros", "€ ", euroController, _euroChanged),

                  ])
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controll, Function funcChanged){
  return TextField (
    controller: controll,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: 
        Colors.amber,
        fontSize: 20,
    ),
    onChanged: funcChanged,
  );
}