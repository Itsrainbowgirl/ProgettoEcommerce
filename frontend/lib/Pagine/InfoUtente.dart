import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Oggetti/NavDrawer.dart';

import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import 'LoggedPage.dart';
import 'Modifica.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class InfoUtente extends StatelessWidget{
  String refreshToken;
  bool logged;
  cliente utente;

  bool added = false;


  List<ProductInPurchase> carrello;
  InfoUtente(List<ProductInPurchase> carrello,bool logged, cliente utente,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
    this.utente=utente;
    this.logged=logged;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,

        title: Text('MyEcommerce',),
        actions:<Widget> [
          IconButton(icon: Icon(Icons.search),tooltip: 'Search',
              onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaHomeState(carrello, logged, utente,refreshToken).build(context)));}),
          IconButton(icon: Icon(Icons.account_box_outlined), onPressed:(){
            if (logged)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => loggedPage(carrello,logged,utente,refreshToken),
                ),
              );
            else
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoLogin(carrello,logged,utente,refreshToken),
                ),
              );
          },),
          IconButton(icon: Icon(Icons.shopping_cart_outlined), tooltip: 'Shopping Cart',
            onPressed:(){
              if(!logged)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotLoggedYet(carrello,logged,utente,refreshToken),
                  ),
                );
              else if (carrello.isNotEmpty)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CarrelloFisico(carrello,logged,utente,refreshToken),
                  ),
                );
              else
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CarrelloVuoto(carrello,logged,utente,refreshToken),
                  ),
                );
            },)
        ],

      ),
      drawer: NavDrawer(carrello,logged,utente,refreshToken),
      body: Container(
        child: Column(

          children: [
            Padding(
              padding: EdgeInsets.only(top:25,bottom:50),
              child: Text(
                "Informazioni utente",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 50,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrangeAccent
                ),
              ),
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 520),
                child: Text("Nome: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepOrangeAccent
                  ),
                ),),
                Padding(padding: EdgeInsets.only(left: 81),
                child: Text("${utente.nome}"),)
              ],
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 520),
                child:
                Text("Cognome: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepOrangeAccent
                  ),
                ),),
                Padding(padding: EdgeInsets.only(left: 48),
                child: Text("${utente.cognome}"),)

              ],
            ),

            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 520),
                child: Text("Email: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepOrangeAccent
                  ),
                ),),
                Padding(padding: EdgeInsets.only(left: 86),
                  child: Text("${utente.email}"),)

              ],
            ),

            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 520),
                child: Text("Telefono: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepOrangeAccent
                  ),
                ),),
                Padding(padding: EdgeInsets.only(left: 58),
                child: Text("${utente.telefono}"),)
              ],
            ),

            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 520),
                  child: Text("Provincia: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.deepOrangeAccent
                    ),
                  ),),
                Padding(padding: EdgeInsets.only(left: 54),
                child: Text("${utente.provincia}"),)
              ],
            ),

            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 520),
                  child:Text("CAP: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.deepOrangeAccent
                    ),
                  ) ,),
                Padding(padding: EdgeInsets.only(left: 95),
                child: Text("${utente.cap}"),)
              ],
            ),

            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 520),
                  child:Text("Via: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.deepOrangeAccent
                    ),
                  ),),
                Padding(padding: EdgeInsets.only(left: 108),
                child: Text("${utente.via}"),)
              ],
            ),

            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 520),
                child: Text("Numero Civico: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepOrangeAccent
                  ),
                ),),
                Padding(padding: EdgeInsets.only(left: 5),
                child: Text("${utente.numCivico}"),)
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20,right: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vuoi modificare l'indirizzo di spedizione? Clicca "),
                InkWell(
                  child: Text("qui",style: TextStyle(color: Colors.deepOrangeAccent),),
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ModificaState(carrello,logged,utente,refreshToken).build(context)));},
                )
              ],
            ),)
          ],),
      ),
    );
  }

}