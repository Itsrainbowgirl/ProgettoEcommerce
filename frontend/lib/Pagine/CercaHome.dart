import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/User.dart';
import 'package:nuovo_flutter/Pagine/CercaByName.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';
import 'package:http/http.dart' as http;

import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import '../Oggetti/ProdottoCard.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class CercaHome extends StatefulWidget {
  String refreshToken;
  bool logged;
  cliente user;

  List<ProductInPurchase> carrello;

  CercaHome(List<ProductInPurchase> carrello,bool logged,cliente user,String refreshToken) {
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.carrello = carrello;
  }

  @override
  State<StatefulWidget> createState() {
    return CercaHomeState(carrello,logged,user,refreshToken);
  }
}

class CercaHomeState extends State<CercaHome>{
  bool logged;
  cliente user;
  String refreshToken;


  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  List<ProductInPurchase> carrello;

  CercaHomeState(List<ProductInPurchase> carrello,bool logged, cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
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
      body: Container(
        color: Colors.amber.withOpacity(0.6),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left:60,right: 60,top:60,bottom: 20),
              child: TextField(
                onSubmitted: (value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaByNameState(carrello,myController.text,logged,user,refreshToken).build(context)));
                },
                controller: myController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  hintText: "Search",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.deepOrangeAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.deepOrangeAccent),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaByNameState(carrello,myController.text,logged,user,refreshToken).build(context)));
              },
              icon: Icon(Icons.search),
              label: Text("Search"),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
            ),
          ],
        ),
      ),
    );
  }


}
