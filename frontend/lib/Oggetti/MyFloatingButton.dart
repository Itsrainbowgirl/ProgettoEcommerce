
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/User.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';

import '../Pagine/CercaByPrice.dart';
import '../main.dart';

class MyFloatingButton extends StatelessWidget{
  bool logged;
  cliente user;
  List<ProductInPurchase> carrello;
  String refreshToken;

  MyFloatingButton(List<ProductInPurchase> carrello,bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
    this.user=user;
    this.logged=logged;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child:Icon(Icons.filter_alt),
      backgroundColor: Colors.deepOrangeAccent,
      onPressed: (){ showDialog(context: context, builder:(context){
        return AlertDialog(
          content: Container(
            child: Text('Scegliere il filtro di ricerca da applicare'),
          ),
          actions: [Container(
            child: Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 5, right: 20),
                          child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
                              onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaByPriceState(-1,carrello,logged,user,refreshToken).build(context)));}, child: Text('price<50')),),
                        Padding(padding: EdgeInsets.only(left: 5,right: 20),child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
                            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaByPriceState(0,carrello,logged,user,refreshToken).build(context)));}, child: Text('50<price<100')),),
                        Padding(padding: EdgeInsets.all(5),
                          child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
                              onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaByPriceState(1,carrello,logged,user,refreshToken).build(context)));}, child: Text('price>100')),),

                      ],
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(right: 10,top: 10),
                        child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
                            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>MyScaffoldState(carrello,logged,user,refreshToken).build(context)));}, child: Text('Annulla filtro')),),
                    ],
                    ),
                  ],
                )
            ),
          )],
        );}
      );},
    );
  }

}