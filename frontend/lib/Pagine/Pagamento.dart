import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/Purchase.dart';
import 'package:nuovo_flutter/Oggetti/NavDrawer.dart';

import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class Pagamento extends StatefulWidget{

  cliente user;
  List<ProductInPurchase> carrello;
  bool logged;
  String refreshToken;

  Pagamento(List<ProductInPurchase> carrello,cliente user,bool logged,String refreshToken ){
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.carrello=carrello;
  }

  @override
  State<StatefulWidget> createState() {
    return PagamentoState(carrello,user,logged,refreshToken);
  }


}

class PagamentoState extends State<Pagamento>{
  String refreshToken;
  TextEditingController _numeroCartaController = TextEditingController();
  TextEditingController _tipoController = TextEditingController();
  TextEditingController _scadenzaController = TextEditingController();
  cliente user;
  List<ProductInPurchase> carrello;
  bool logged;
  String value;

  PagamentoState(List<ProductInPurchase> carrello,cliente user,bool logged,String refreshToken ){
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.carrello=carrello;
  }

  @override
  void initState() {
    super.initState();
    value="Contrassegno";
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,

        title: Text('MyEcommerce',),
        actions:<Widget> [
          IconButton(icon: Icon(Icons.search),tooltip: 'Search',
              onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaHomeState(carrello, logged, user,refreshToken).build(context)));}),
          IconButton(icon: Icon(Icons.account_box_outlined), onPressed:(){
            if (logged)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => loggedPage(carrello,logged,user,refreshToken),
                ),
              );
            else
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoLogin(carrello,logged,user,refreshToken),
                ),
              );
          },),
          IconButton(icon: Icon(Icons.shopping_cart_outlined), tooltip: 'Shopping Cart',
            onPressed:(){
              if(!logged)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotLoggedYet(carrello,logged,user,refreshToken),
                  ),
                );
              else if (carrello.isNotEmpty)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CarrelloFisico(carrello,logged,user,refreshToken),
                  ),
                );
              else
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CarrelloVuoto(carrello,logged,user,refreshToken),
                  ),
                );
            },)
        ],

      ),
      drawer: NavDrawer(carrello,logged,user,refreshToken),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(40),
              child: ElevatedButton(
                  onPressed: () async {
                    Purchase purchase= new Purchase(buyer: user,productsInPurchase: carrello);
                    Map<String, String> headers = Map();
                    headers[HttpHeaders.contentTypeHeader] = "application/json;charset=utf-8";
                    dynamic body = json.encode(purchase.toJson());
                    Uri uri = Uri.parse("http://localhost:80/purchases");
                    var response = await http.post(uri, headers: headers, body: body);
                    if(response.body.contains("quantity unavailable")){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Container(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Qualche prodotto nel carrello non è attualmente disponibile!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                  ),
                                ],
                              )
                          ),
                        );
                      });
                    }
                    else{
                      carrello.clear();
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Container(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Ordine effettuato con successo!Arriverà tra 3-5 giorni lavorativi.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                  ),
                                ],
                              )
                          ),
                        );
                      });
                    }

                  },
                  child: Text("Contrassegno")),
            ),
            Divider(color: Colors.deepOrangeAccent,),
            Padding(
              padding:EdgeInsets.all(40) ,
              child: ElevatedButton(
                  onPressed: () async {
                    if(_numeroCartaController.text==""||_scadenzaController.text==""||_tipoController.text==""){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Container(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Informazioni mancanti",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                  ),
                                ],
                              )
                          ),
                        );
                      });
                    }
                    else{
                      Purchase purchase= new Purchase(buyer: user,productsInPurchase: carrello,numero_carta: _numeroCartaController.text,scadenza: _scadenzaController.text,tipo: _tipoController.text);
                      Map<String, String> headers = Map();
                      headers[HttpHeaders.contentTypeHeader] = "application/json;charset=utf-8";
                      dynamic body = json.encode(purchase.toJson());
                      Uri uri = Uri.parse("http://localhost:80/purchases");
                      var response = await http.post(uri, headers: headers, body: body);
                      if(response.body.contains("quantity unavailable")){
                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            content: Container(
                                height: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Qualche prodotto nel carrello non è attualmente disponibile!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                    ),
                                  ],
                                )
                            ),
                          );
                        });
                      }
                      else{
                        carrello.clear();
                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            content: Container(
                                height: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Ordine effettuato con successo!Arriverà tra 3-5 giorni lavorativi.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                    ),
                                  ],
                                )
                            ),
                          );
                        });
                      }
                    }

                  },
                  child: Text("Carta Di Credito")),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right:400,left: 400,top: 20),
                  child: TextField(
                    controller: _numeroCartaController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: "Numero Carta di Credito",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 400,top: 20,left: 400),
                  child: TextField(
                    controller: _tipoController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: "Tipo Carta di credito",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 400,top: 20,left: 400),
                  child: TextField(
                    controller: _scadenzaController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: "Scadenza Carta di Credito",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}