
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/User.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';
import 'package:nuovo_flutter/Pagine/Carrello.dart';

import 'CercaHome.dart';
import '../Oggetti/NavDrawer.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class CarrelloVuoto extends StatelessWidget{
  bool logged;
  cliente user;

  List<ProductInPurchase> prodotti;
  String refreshToken;



  CarrelloVuoto(List<ProductInPurchase> prodotti,bool logged, cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.prodotti=prodotti;
    this.logged=logged;
    this.user=user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,

        title: Text('MyEcommerce',),
        actions:<Widget> [
          IconButton(icon: Icon(Icons.search),tooltip: 'Search',
              onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaHomeState(prodotti, logged, user,refreshToken).build(context)));}),
          IconButton(icon: Icon(Icons.account_box_outlined), onPressed:(){
            if (logged)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => loggedPage(prodotti,logged,user,refreshToken),
                ),
              );
            else
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoLogin(prodotti,logged,user,refreshToken),
                ),
              );
          },),
          IconButton(icon: Icon(Icons.shopping_cart_outlined), tooltip: 'Shopping Cart',
            onPressed:(){
              if(!logged)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotLoggedYet(prodotti,logged,user,refreshToken),
                  ),
                );
              else if (prodotti.isNotEmpty)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CarrelloFisico(prodotti,logged,user,refreshToken),
                  ),
                );
              else
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CarrelloVuoto(prodotti,logged,user,refreshToken),
                  ),
                );
            },)
        ],

      ),
      drawer: NavDrawer(prodotti,logged,user,refreshToken),
      body: Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Carrello vuoto"),
                Icon(Icons.mood_bad)
              ]
          ),
        ),

      ),
    );
  }
}