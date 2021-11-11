
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/User.dart';
import 'package:nuovo_flutter/Pagine/Carrello.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';

import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import '../Oggetti/NavDrawer.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class Dettagli extends StatefulWidget {
  bool logged;
  cliente user;
  prodotto p;
  List<ProductInPurchase> carrello;
  String refreshToken;

  Dettagli(prodotto p, List<ProductInPurchase> carrello, bool logged, cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.user=user;
    this.logged=logged;
    this.carrello=carrello;
    this.p=p;
  }

  @override
  State<StatefulWidget> createState() =>DettagliState(p,carrello,logged,user,refreshToken);

}

class DettagliState extends State<StatefulWidget>{
  String refreshToken;
  bool logged;
  cliente user;
  List<ProductInPurchase> carrello;
  prodotto p;
  String valore = "1";
  var valori;
  String my;

  DettagliState(prodotto p, List<ProductInPurchase> carrello, bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.p=p;
    this.carrello=carrello;
    valori = <String>[];
    for(int i=1; i<p.quantity+1; i++){
      valori.add(i.toString());
    }
  }

  void getState(){
    bool inserito=false;

    int quantita=int.parse(valore);

    for(ProductInPurchase pip in carrello){
      if(pip.product.barCode==p.barCode){
        pip.quantity=quantita;
        inserito=true;
      }
    }
    if(!inserito){
      ProductInPurchase newp= new ProductInPurchase();
      newp.product=p;
      newp.quantity=quantita;
      carrello.add(newp);
    }

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

      body: Scrollbar(
        showTrackOnHover: true,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(15),
              child:Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        child:ClipRect(
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/no.jpg",
                            image: p.immagine,
                            width: 450,
                            height: 450,
                          ),
                        ),

                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40,top: 20),
                        child: Column(
                          children: <Widget>[
                            Text("DESCRIZIONE:"),
                            Container(
                              width:500,
                              child: Text(
                                p.description,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 10,
                                textAlign: TextAlign.justify ,),
                            )
                          ],
                        ),
                      )
                    ],),

                  Padding(
                    padding: EdgeInsets.only(left: 50, bottom: 300),
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(5),
                          child:
                          Text(p.name.toUpperCase(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),),
                        ),
                        Padding(padding: EdgeInsets.all(5),child:Text("PRICE: "+p.price.toString()) ,),
                        Row(children: <Widget>[
                          Text("QUANTITA': ",),
                          DropdownButton(
                            value: valore,
                            items: this.valori.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepOrangeAccent),
                            underline: Container(
                              height: 2,
                              color: Colors.deepOrangeAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                valore = newValue;
                              });
                            },
                          ),
                        ],
                        ),
                        ElevatedButton(
                          onPressed: getState,
                          child: Text("Acquista"),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}