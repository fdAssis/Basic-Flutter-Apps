import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp (
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formatKey = GlobalKey<FormState>();

  String _infoTest = "Informe seus dados";

  void _resetFields(){
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoTest = "Informe seus dados";
      _formatKey = GlobalKey<FormState>();
    });
    
  }

  void _calculate(){
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;

      double imc = weight / (height * height);

      if(imc < 18.6){
        _infoTest = "Abaixo do peso (${imc.toStringAsPrecision(3)})";
      }
      else if(imc >= 18.6 && imc < 24.4){
        _infoTest = "Peso ideal (${imc.toStringAsPrecision(3)})";
      }
      else if(imc >= 24.5 && imc < 34.8){
        _infoTest = "Levimente acima do peso (${imc.toStringAsPrecision(3)})";
      }
      else if(imc >= 34.8 && imc < 40){
        _infoTest = "Obesidade bem legal (${imc.toStringAsPrecision(3)})";
      }
      else if(imc > 40){
        _infoTest = "Gordo supremo (${imc.toStringAsPrecision(3)})";
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      
      backgroundColor: Colors.black,
      
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formatKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size:80,
                color: Colors.white,
              ),
              
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Peso (kg)",
                  labelStyle: TextStyle(color: Colors.white), 
                  
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[500]),
                  ),
                  
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[500]),
                  ),

                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 20,
                ),
                controller: weightController,
                validator: (value) {
                  if(value.isEmpty){
                    return "Insira seu Peso";
                  }
                }
              
              ),

              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Atura (cm)",
                  labelStyle: TextStyle(color: Colors.white),

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[500]),
                  ),
                  
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[500]),
                  ),

                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 20,
                ),
                controller: heightController,
                validator: (value) {
                  if(value.isEmpty){
                    return "Insira sua Atura";
                  }
                },
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom:10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: (){
                      if(_formatKey.currentState.validate()){
                        _calculate();
                      }
                    },
                    child: 
                      Text(
                        "Calcular",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 20.0
                        ),
                      ),
                      color: Colors.blue[900],
                      elevation: 10.0,
                  ),
                ),
              ),
              
              Text(_infoTest,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color : Colors.white, 
                  fontSize: 20.0
                ),
              )
            ]
          )
        ),
      )
    );
  }
}