import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';

class Purchase{
  List<ProductInPurchase> productsInPurchase;
  cliente buyer;
  int id;
  DateTime purchaseTime;
  String numero_carta;
  String tipo;
  String scadenza;

  Purchase({this.id,this.buyer,this.numero_carta,this.productsInPurchase,this.purchaseTime,this.scadenza,this.tipo});

  Map<String,dynamic> toJson() =>{
    'buyer':buyer.toJson(),
    'id':id,
    'purchaseTime':purchaseTime,
    'numero_carta':numero_carta,
    'tipo':tipo,
    'scadenza':scadenza,
    'productsInPurchase':_printProducts(productsInPurchase),
  };

  List<Map<String,dynamic>> _printProducts(List<ProductInPurchase> cr){
    var ris=<Map<String,dynamic>>[];
    for(ProductInPurchase i in cr){
      ris.add(i.toJson());
    }
    return ris;
  }

}