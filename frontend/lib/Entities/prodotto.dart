import 'package:flutter/material.dart';
import 'dart:convert';

prodotto prodottoJson(String s) => prodotto.fromJson(json.decode(s));

String prodottoToJson(prodotto p)=> json.encode(p.toJson());

class prodotto {
  int id;
  String name;
  String barCode;
  String description;
  double price;
  int quantity;
  String immagine;
  String genere;

  prodotto({this.id,this.name,this.barCode,this.description,this.price,this.quantity,this.immagine,this.genere});

  factory prodotto.fromJson(Map<String, dynamic> json) => prodotto(
    id:json['id'],
    name:json['name'],
    barCode: json['barCode'],
    description: json['description'],
    price: json['price'],
    quantity: json['quantity'],
    immagine: json['immagine'],
    genere: json['genere'],
  );

  Map<String,dynamic> toJson() =>{
    'id':id,
    'name':name,
    'barCode':barCode,
    'description':description,
    'price':price,
    'quantity':quantity,
    'immagine':immagine,
    'genere':genere,
  };

  @override
  String toString()=>name;



}