import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';

import 'package:nuovo_flutter/Pagine/CercaByPrice.dart';
import 'package:nuovo_flutter/Pagine/CercaHome.dart';
import 'package:nuovo_flutter/Oggetti/MyFloatingButton.dart';
import 'package:nuovo_flutter/Oggetti/ProdottoCard.dart';
import 'package:nuovo_flutter/Pagine/NoLogin.dart';
import 'package:nuovo_flutter/Pagine/NotLoggedYet.dart';
import 'package:nuovo_flutter/Pagine/Pagamento.dart';
import 'package:nuovo_flutter/Pagine/Registrazione.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';
import 'package:http/http.dart' as http;

import 'Entities/User.dart';
import 'Pagine/Carrello.dart';
import 'Pagine/CarrelloVuoto.dart';
import 'Pagine/Dettagli.dart';
import 'Oggetti/NavDrawer.dart';
import 'Pagine/LoggedPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  List<ProductInPurchase> carrello ;
  bool logged;
  cliente user;
  String refreshToken;

  MyApp(){
    this.carrello=[];
    logged=false;
    user=null;
    refreshToken=null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home:MyScaffold(carrello,logged,user,refreshToken),
    );
  }
}
class MyScaffold extends StatefulWidget{
  String refreshToken;
  bool logged;
  cliente user;
  List<ProductInPurchase> carrello;

  MyScaffold(List<ProductInPurchase> carrello,bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
    this.user=user;
    this.logged=logged;
  }
  @override
  State<StatefulWidget> createState() {
    return MyScaffoldState(carrello,logged,user,refreshToken);
  }

}

class MyScaffoldState extends State<MyScaffold>{
  String refreshToken;
  bool logged;
  cliente user;
  List<ProductInPurchase> carrello;

  MyScaffoldState(List<ProductInPurchase> carrello,bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
    this.logged=logged;
    this.user=user;
  }


  Future<List<prodotto>> getProdotti() async {
    var prodotti = List<prodotto>.generate(0, (index) => null, growable: true);

    var dati = await http.get(Uri.parse('http://localhost:80/products/'));
    var JsonData = json.decode(dati.body);

    for (var i in JsonData) {
      prodotto p = new prodotto();
      p.id = i["id"];
      p.name = i["name"];
      p.barCode = i["barCode"];
      p.description = i["description"];
      p.price = i["price"];
      p.quantity = i["quantity"];
      p.immagine = i["immagine"];
      p.genere = i["genere"];
      prodotti.add(p);
    }


    return prodotti;
  }

  waiting(){
    return Center(
      child: CircularProgressIndicator(),
    );

  }

  @override
  Widget build(BuildContext context){
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
      floatingActionButton: MyFloatingButton(carrello,logged,user,refreshToken),
      drawer: NavDrawer(carrello,logged,user,refreshToken),
      body: Container(
        child: FutureBuilder(
          future:getProdotti(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasError) {
              return Container(child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Nessun prodotto trovato"),
                      Icon(Icons.error)
                    ]
                ),
              )
              );
            }
            if(snapshot.hasData)return Scrollbar(
                child: GridView.count(
                  crossAxisCount: 5,
                  children: List.generate(snapshot.data.length, (index) {
                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: ProdottoCard(snapshot.data[index],carrello,logged,user,refreshToken),
                    );
                  }),
                )
            );
            return waiting();
            },
        ),
      ),
    );
  }
}

