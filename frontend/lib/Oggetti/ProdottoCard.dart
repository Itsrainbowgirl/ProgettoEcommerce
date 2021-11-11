import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/User.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';

import '../Pagine/Dettagli.dart';

class ProdottoCard extends StatelessWidget{
  bool logged;
  cliente user;
  prodotto p;
  List<ProductInPurchase> carrello;
  String refreshToken;


  ProdottoCard(prodotto p,List<ProductInPurchase> carrello,bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.user=user;
    this.logged=logged;
    this.p=p;
    this.carrello=carrello;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center ,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children:<Widget> [
            Flexible(
              child: ClipRect(
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/no.jpg",
                  image: p.immagine,
                  width: 200,
                  height: 200,
                  fit: BoxFit.fitWidth,

                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(p.price.toString()+'\$'),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(p.name.toUpperCase(),
              overflow: TextOverflow.ellipsis,),
            ),
          ],
        ),
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Dettagli(p,carrello,logged,user,refreshToken)));},
      ),
    );
  }

}