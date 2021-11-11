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
import '../Oggetti/MyFloatingButton.dart';
import '../Oggetti/NavDrawer.dart';
import '../Oggetti/ProdottoCard.dart';
import '../main.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class CercaByPrice extends StatefulWidget{
  bool logged;
  cliente user;
  List<ProductInPurchase> carrello;
  int price;
  String refreshToken;



  CercaByPrice(int price, List<ProductInPurchase> carrello, bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.user=user;
    this.logged=logged;
   this.price=price;
   this.carrello=carrello;
  }

  @override
  State<StatefulWidget> createState() {
    return CercaByPriceState(price,carrello,logged,user,refreshToken);
  }

}

class CercaByPriceState extends State<CercaByPrice>{
  String refreshToken;
  int price;
  List<ProductInPurchase> carrello;
  bool logged;
  cliente user;

  CercaByPriceState(int price, List<ProductInPurchase> carrello,bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.price=price;
    this.carrello=carrello;
    this.logged=logged;
    this.user=user;
  }

  Future<List<prodotto>> getProdottibyPrice() async {
    var prodotti = List<prodotto>.generate(0, (index) => null, growable: true);

    Uri uri=null;
    switch (price){
      case -1: uri=Uri.parse('http://localhost:80/products/search/prezzo50');break;

      case 0: uri=Uri.parse('http://localhost:80/products/search/prezzo50_100');break;

      case 1: uri=Uri.parse('http://localhost:80/products/search/prezzo100');break;

      default:uri= Uri.parse('http://localhost:80/products/');

    }

    var dati = await http.get(uri);
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
          future:getProdottibyPrice(),
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