import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/Purchase.dart';
import 'package:http/http.dart' as http;
import 'package:nuovo_flutter/Entities/prodotto.dart';
import 'package:nuovo_flutter/Oggetti/NavDrawer.dart';

import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class StoricoOrdini extends StatefulWidget{
  bool logged;
  cliente user;
  List<ProductInPurchase> carrello;
  String refreshToken;

  StoricoOrdini(List<ProductInPurchase> carrello,bool logged, cliente user,String refreshToken) {
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.carrello = carrello;
  }
  @override
  State<StatefulWidget> createState() {
    return StoricoOrdiniState(carrello,logged,user,refreshToken);
  }

}

class StoricoOrdiniState extends State<StoricoOrdini> {
  bool logged;
  cliente user;
  List<ProductInPurchase> carrello;
  String refreshToken;

  StoricoOrdiniState(List<ProductInPurchase> carrello,bool logged, cliente user,String refreshToken) {
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.carrello = carrello;
  }

  waiting(){
    return Center(
      child: CircularProgressIndicator(),
    );

  }

  Future<List<Purchase>> getOrdiniByUser() async {
    var ordini = List<Purchase>.generate(0, (index) => null, growable: true);

    var dati = await http.get(Uri.parse('http://localhost:80/purchases/byUser?user=${user.id}'));
    var JsonData = json.decode(dati.body);

    for (var i in JsonData) {

      Purchase p= new Purchase();

      p.id=i["id"];
      p.purchaseTime=DateTime.fromMicrosecondsSinceEpoch(i["purchaseTime"] * 1000);
      p.scadenza=i["scadenza"];
      p.tipo=i["tipo"];
      p.buyer=cliente.fromJson(i["buyer"]);
      p.numero_carta=i["numero_carta"];
      List<ProductInPurchase> prodotti=[];

      for( var j in i["productsInPurchase"]){
        ProductInPurchase pip = new ProductInPurchase();
        pip.id=j["id"];
        pip.product=prodotto.fromJson(j["product"]);
        pip.quantity=j["quantity"];
        prodotti.add(pip);
      }
      p.productsInPurchase= prodotti;
      ordini.add(p);

    }

    return ordini;
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

      body: FutureBuilder(
        future: getOrdiniByUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasError) {
            print(snapshot.error.toString());
            return Container(child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Nessun ordine trovato"),
                    Icon(Icons.error)
                  ]
              ),
            )
            );
          }
          if(snapshot.hasData)
            return Scrollbar(
                child: Container(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Center(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Id ordine: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  Text("${snapshot.data[index].id}"),
                                                ],
                                              )
                                            ],
                                          ),),
                                        Padding(padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Data ordine: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  Text("${snapshot.data[index].purchaseTime}"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(10),
                                          child: IconButton(
                                            tooltip: "Elimina Ordine",
                                            icon: Icon(Icons.delete), 
                                            onPressed: ()async{
                                              if(DateTime.now().isAfter(snapshot.data[index].purchaseTime.add(const Duration(days: 3)))){
                                                showDialog(context: context, builder: (context){
                                                  return AlertDialog(
                                                    content: Container(
                                                        height: 150,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("Impossibile annullare l'ordine!",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                                            ),
                                                            Text("Il tuo ordine è già stato spedito ",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                                            ),
                                                          ],
                                                        )
                                                    ),
                                                  );
                                                });
                                              }
                                              else {
                                                var ris=await http.delete(Uri.parse('http://localhost:80/purchases?id=${snapshot.data[index].id}'),headers: <String, String>{
                                                  'Content-Type': 'application/json; charset=UTF-8',
                                                },);
                                                if(ris.statusCode==200){
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => StoricoOrdiniState(carrello,logged,user,refreshToken).build(context),
                                                    ),
                                                  );
                                                }
                                                else{
                                                  showDialog(context: context, builder: (context){
                                                    return AlertDialog(
                                                      content: Container(
                                                          height: 150,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text("Errore!",
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
                                          )
                                        )
                                      ],
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data[index].productsInPurchase.length,
                                      itemBuilder: (BuildContext context, int index2) {
                                        return Container(
                                          height: 100,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(padding: EdgeInsets.all(5),child: Image.network(snapshot.data[index].productsInPurchase[index2].product.immagine, width: 95,height: 95,),),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 350),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Padding(padding: EdgeInsets.all(5), child: Text("${snapshot.data[index].productsInPurchase[index2].product.name.toUpperCase()}",style: TextStyle(fontWeight: FontWeight.bold),),),
                                                      Row(children: [
                                                        Padding(padding: EdgeInsets.all(5), child: Text('Quantità: '+snapshot.data[index].productsInPurchase[index2].quantity.toString())),
                                                        Padding(padding: EdgeInsets.all(5), child: Text("Prezzo: "+snapshot.data[index].productsInPurchase[index2].product.price.toString()))


                                                      ],)
                                                      ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        );
                                      },

                                    )

                                  ],
                                ),


                            ),
                          );
                      },
                    ),

                ),

          );
          return waiting();
        },
      )
    );
  }
}