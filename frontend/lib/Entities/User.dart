
import 'dart:convert';

import 'package:nuovo_flutter/Entities/CredentialRepresentation.dart';

String userToJson(User p)=> json.encode(p.toJson());

class User{
  String username;
  String email;
  List<CredentialRepresentation> cr;

  User({this.username,this.email,this.cr});

  Map<String,dynamic> toJson() =>{
    'username':username,
    'email':email,
    'enabled':true,
    'credentials':_printCR(cr),
  };

  List<Map<String,dynamic>> _printCR(List<CredentialRepresentation> cr){
    var ris=<Map<String,dynamic>>[];
    for(CredentialRepresentation i in cr){
      ris.add(i.toJson());
    }
    return ris;
  }


}