import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Oggetti/NavDrawer.dart';

import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';

class NotLoggedYet extends StatelessWidget{
  bool logged;
  String refreshToken;
  cliente user;

  List<ProductInPurchase> prodotti;



  NotLoggedYet(List<ProductInPurchase> prodotti,bool logged, cliente user,String refreshToken){
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Fai il "),
                    InkWell(
                      child: Text("login",style: TextStyle(color: Colors.deepOrangeAccent),),
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>NoLoginState(prodotti,logged,user,refreshToken).build(context)));},
                    ),
                    Text(" per poter visualizzare il carrello ed effettuare i tuoi acquisti"),
                  ],
                ),
                Icon(Icons.mood_bad)
              ]
          ),
        ),

      ),
    );
  }
}