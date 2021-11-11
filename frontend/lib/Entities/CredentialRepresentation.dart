import 'dart:convert';


class CredentialRepresentation{
  String type;
  String value;
  bool temporary;

  CredentialRepresentation(String value){
    type="password";
    temporary=false;
    this.value=value;
  }



  Map<String,dynamic> toJson() =>{
    'type':type,
    'value':value,
    'temporary':temporary,

  };



}