import 'dart:convert';

cliente clienteJson(String s) => cliente.fromJson(json.decode(s));

String clienteToJson(cliente c)=> json.encode(c.toJson());

class cliente {
  int id;
  String nome;
  String cognome;
  String email;
  String telefono;
  String cap;
  String via;
  int numCivico;
  String provincia;

  cliente({this.id,this.nome,this.cognome,this.email,this.telefono,this.cap,this.via,this.numCivico,this.provincia});

  factory cliente.fromJson(Map<String, dynamic> json) => cliente(
    id:json['id'],
    nome:json['nome'],
    cognome: json['cognome'],
    email: json['email'],
    telefono: json['telefono'],
    cap: json['cap'],
    via: json['via'],
    numCivico: json['numCivico'],
    provincia:json['provincia']
  );

  Map<String,dynamic> toJson() =>{
    'id':id,
    'nome':nome,
    'cognome':cognome,
    'email':email,
    'telefono':telefono,
    'via':via,
    'cap':cap,
    'numCivico':numCivico,
    'provincia':provincia,
  };

  @override
  String toString()=>nome;



}