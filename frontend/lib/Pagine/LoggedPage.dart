import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/AuthenticationData.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';
import 'package:nuovo_flutter/Oggetti/NavDrawer.dart';
import 'package:nuovo_flutter/Pagine/InfoUtente.dart';
import 'package:nuovo_flutter/Pagine/StoricoOrdini.dart';
import 'package:nuovo_flutter/main.dart';
import 'package:http/http.dart' as http;

import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';
import 'Pagamento.dart';

class loggedPage extends StatelessWidget{
  bool logged;
  cliente user;
  List<ProductInPurchase> carrello;
  String refreshToken;

  loggedPage(List<ProductInPurchase> carrello,bool logged, cliente user,String refreshToken) {
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.carrello = carrello;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(25),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Card(
                  child: Icon(Icons.account_box_outlined,size: 100,color: Colors.white,),
                  color: Colors.deepOrangeAccent,
                ),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InfoUtente(carrello,logged,user,refreshToken),
                    ),
                  );
                },
              ),
              Padding(padding: EdgeInsets.only(left: 25,right: 25),
              child: InkWell(
                child: Card(
                  child: Icon(Icons.access_time,size: 100,color: Colors.white,),
                  color: Colors.deepOrangeAccent,
                ),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StoricoOrdiniState(carrello,logged,user,refreshToken).build(context),
                    ),
                  );
                },
              ),),

              Padding(padding: EdgeInsets.only(left: 0),
              child: InkWell(
                child: Card(
                  child: Icon(Icons.logout,size: 100,color: Colors.white,),
                  color: Colors.deepOrangeAccent,
                ),
                onTap: ()async{

                  carrello.clear();
                  user=null;
                  logged=false;
                  try{
                    Map<String, String> params = Map();

                    params["client_id"] = "****";
                    params["client_secret"] = "****";
                    params["refresh_token"] = refreshToken;

                    dynamic formattedBody = params.keys.map((key) => "$key=${params[key]}").join("&");

                    Uri uri = Uri.parse("http://localhost:8080/auth/realms/****/protocol/openid-connect/logout");

                    Map<String, String> headers = Map();
                    headers[HttpHeaders.contentTypeHeader] = "application/x-www-form-urlencoded";

                    await http.post(uri, headers: headers, body: formattedBody);
                    print("uscita ok!");

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MyScaffoldState(carrello, logged, user,refreshToken).build(context),
                      ),
                    );

                  }catch(e){
                    print("errore!");
                  }

                },
              ),)


            ],
          ),
        ],
      )
    );
  }

}