import 'dart:convert';

import 'package:nuovo_flutter/Entities/prodotto.dart';

String ProductInPurchaseToJson(ProductInPurchase p)=> json.encode(p.toJson());

class ProductInPurchase{
  prodotto product;
  int id;
  int quantity;

  ProductInPurchase({this.id,this.quantity,this.product});

  Map<String,dynamic> toJson() =>{
    'id':id,
    'quantity':quantity,
    'product':product.toJson(),
  };

}