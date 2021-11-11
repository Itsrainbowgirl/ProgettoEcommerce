
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/User.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';

import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import '../Oggetti/NavDrawer.dart';
import '../Oggetti/ProdottoCard.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class CercaByGenere extends StatefulWidget{
  bool logged;
  cliente user;
  String genere;
  List<ProductInPurchase> carrello;
  String refreshToken;

  CercaByGenere(String genere, List<ProductInPurchase> carrello,bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.user=user;
    this.logged=logged;
    this.carrello=carrello;
    this.genere=genere;
  }

  @override
  State<StatefulWidget> createState() {
    return CercaGenereState(genere,carrello,logged,user,refreshToken);
  }

}

class CercaGenereState extends State<CercaByGenere>{
  bool logged;
  cliente user;
  String refreshToken;
  String genere;
  List<ProductInPurchase> carrello;

  CercaGenereState(String genere, List<ProductInPurchase> carrello, bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.genere=genere;
    this.carrello=carrello;
  }

  Future<List<prodotto>> getProdottibyGenere() async {
    var prodotti = List<prodotto>.generate(0, (index) => null, growable: true);

    var dati = await http.get(Uri.parse('http://localhost:80/products/search/by_genere?genere=${genere}'));
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
      drawer: NavDrawer(carrello,logged,user,refreshToken),
      body: Container(
        child: FutureBuilder(
          future:getProdottibyGenere(),
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