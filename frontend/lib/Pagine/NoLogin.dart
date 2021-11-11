import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nuovo_flutter/Entities/AuthenticationData.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';
import 'package:nuovo_flutter/Oggetti/NavDrawer.dart';
import 'package:nuovo_flutter/Pagine/LoggedPage.dart';
import 'package:nuovo_flutter/Pagine/Registrazione.dart';


import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import 'NotLoggedYet.dart';

class NoLogin extends StatefulWidget{
  String refreshToken;
  bool logged;
  cliente user;

  bool added = false;


  List<ProductInPurchase> carrello;

  NoLogin(List<ProductInPurchase> carrello,bool logged, cliente user,String refreshToken) {
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.carrello = carrello;
  }

  @override
  State<StatefulWidget> createState() {
    return NoLoginState(carrello,logged,user,refreshToken);
  }

}

class NoLoginState extends State<NoLogin>{
  String refreshToken;
  bool logged;
  cliente user;

  bool added = false;


  List<ProductInPurchase> carrello;

  NoLoginState(List<ProductInPurchase> carrello,bool logged, cliente user,String refreshToken) {
    this.refreshToken=refreshToken;
    this.logged=logged;
    this.user=user;
    this.carrello = carrello;
  }

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25,bottom:20),
              child: Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 50,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrangeAccent
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right:400,left: 400,top: 20),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  hintText: "Username",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 400,top: 20,left: 400),
              child: TextField(
                obscuringCharacter: "*",
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  hintText: "Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                child: Text("Login!"),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
                onPressed: ()async{
                  Map<String, String> headers2 = Map();
                  headers2[HttpHeaders.contentTypeHeader] =
                  "application/x-www-form-urlencoded";

                  Map<String, String> params = Map();
                  params["grant_type"] = "password";
                  params["client_id"] = "****";
                  params["client_secret"] =
                  "****";
                  params["username"] = "${_usernameController.text}";
                  params["password"] = "${_passwordController.text}";

                  dynamic formattedBody = params.keys.map((key) => "$key=${params[key]}").join("&");

                  Uri uri2 = Uri.parse("http://localhost:8080/auth/realms/****/protocol/openid-connect/token");

                  var result = await http.post(uri2, headers: headers2, body: formattedBody);

                  AuthenticationData authenticationData = AuthenticationData
                      .fromJson(jsonDecode(result.body));

                  if ( authenticationData.hasError() ) {
                    if ( authenticationData.error == "Invalid user credentials" ) {
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Container(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Credenziali utente errate",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                  )
                                ],
                              )
                          ),
                        );
                      });
                    }
                    else if ( authenticationData.error == "Account is not fully set up" ) {
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Container(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("L'account non è completamente configurato",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                  )
                                ],
                              )
                          ),
                        );
                      });
                    }
                    else {
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Container(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Errore Sconosciuto",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                  )
                                ],
                              )
                          ),
                        );
                      });
                    }
                  }
                  String token=authenticationData.accessToken;

                  String email=_usernameController.text;

                  String uri="http://localhost:80/users/utente?email=${email}";
                  Map<String,String>headers3 = Map();
                  headers3[HttpHeaders.contentTypeHeader] = "application/json;charset=utf-8";

                  var dati = await http.get(Uri.parse(uri),headers: headers3);
                  user=clienteJson(dati.body);


                  logged=true;

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>loggedPage(carrello,logged,user,authenticationData.refreshToken).build(context)));


                  Timer.periodic(Duration(seconds: (authenticationData.expiresIn - 50)), (Timer t) async {
                    Map<String, String> params = Map();
                    params["grant_type"] = "refresh_token";
                    params["client_id"] = "****";
                    params["client_secret"] = "****";
                    params["refresh_token"] = authenticationData.refreshToken;
                    dynamic formattedBody = params.keys.map((key) => "$key=${params[key]}").join("&");

                    Uri uri3 = Uri.parse("http://localhost:8080/auth/realms/****/protocol/openid-connect/token");

                    var response = await http.post(uri3, headers: headers2, body: formattedBody);
                    AuthenticationData _authenticationData2 = AuthenticationData.fromJson(jsonDecode(response.body));
                    if ( authenticationData.hasError() ) {
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Container(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Errore",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                  )
                                ],
                              )
                          ),
                        );
                      });
                    }
                    token = authenticationData.accessToken;

                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Se non sei ancora registrato, clicca "),
                  InkWell(
                    child: Text("qui",style: TextStyle(color: Colors.deepOrangeAccent),),
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrazioneState(carrello,logged,user,refreshToken).build(context)));},
                  )
                ],
              ),
            )
          ],)
        ,)

    );
  }





}