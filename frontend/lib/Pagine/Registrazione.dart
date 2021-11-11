
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nuovo_flutter/Entities/AuthenticationData.dart';
import 'package:nuovo_flutter/Entities/CredentialRepresentation.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/User.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';

import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import '../Entities/Cliente.dart';
import '../Oggetti/NavDrawer.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class Registrazione extends StatefulWidget{
  String refreshToken;
  bool logged;
  cliente utente;
  List<ProductInPurchase> carrello;

  Registrazione(List<ProductInPurchase> carrello,bool logged, cliente utente,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
    this.logged=logged;
    this.utente=utente;
  }
  @override
  State<StatefulWidget> createState() {
    return RegistrazioneState(carrello,logged,utente,refreshToken);
  }

}

class RegistrazioneState extends State<Registrazione> {
  String refreshToken;
  bool logged;
  cliente utente;

  bool added = false;


  List<ProductInPurchase> carrello;
  RegistrazioneState(List<ProductInPurchase> carrello,bool logged, cliente utente,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
    this.utente=utente;
    this.logged=logged;
  }

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cognomeFiledController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _capController = TextEditingController();
  TextEditingController _viaController = TextEditingController();
  TextEditingController _provinciaController = TextEditingController();
  TextEditingController _numero_civicoController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,

        title: Text('MyEcommerce',),
        actions:<Widget> [
          IconButton(icon: Icon(Icons.search),tooltip: 'Search',
              onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaHomeState(carrello, logged, utente,refreshToken).build(context)));}),
          IconButton(icon: Icon(Icons.account_box_outlined), onPressed:(){
            if (logged)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => loggedPage(carrello,logged,utente,refreshToken),
                ),
              );
            else
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoLogin(carrello,logged,utente,refreshToken),
                ),
              );
          },),
          IconButton(icon: Icon(Icons.shopping_cart_outlined), tooltip: 'Shopping Cart',
            onPressed:(){
              if(!logged)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotLoggedYet(carrello,logged,utente,refreshToken),
                  ),
                );
              else if (carrello.isNotEmpty)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CarrelloFisico(carrello,logged,utente,refreshToken),
                  ),
                );
              else
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CarrelloVuoto(carrello,logged,utente,refreshToken),
                  ),
                );
            },)
        ],

      ),
      drawer: NavDrawer(carrello,logged,utente,refreshToken),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25,bottom:20),
                    child: Text(
                      "Nuova Registrazione",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 50,
                          fontStyle: FontStyle.italic,
                          color: Colors.deepOrangeAccent
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child:Padding(
                          padding: EdgeInsets.only(right: 300,top: 20,left: 300),
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
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right:10,left: 300,top: 20),
                            child: TextField(
                              keyboardType: TextInputType.name,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[A-Z a-z]')),
                              ],
                              controller: _nomeController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                hintText: "Nome",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                            ),
                          ),
                      ),
                      Flexible(
                          child:Padding(
                            padding: EdgeInsets.only(right: 300,top: 20,left: 10),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[A-Z a-z]')),
                              ],
                              controller: _cognomeFiledController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                hintText: "Cognome",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 300,right:10,top: 20),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                            ],
                            controller: _telefonoController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              hintText: "Telefono",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 300,top: 20,left: 10),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                hintText: "Email",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                            ),
                          ),
                      )
                    ],
                  ),

                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 300,top: 20,right: 10),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _capController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              hintText: "CAP",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20,right: 300,left: 10),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[A-Z a-z]')),
                            ],
                            controller: _provinciaController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              hintText: "Provincia",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20,left: 300,right: 10),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[A-Z a-z]')),
                            ],
                            controller: _viaController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              hintText: "Via",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),

                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20,right: 300,left: 10),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _numero_civicoController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              hintText: "Num. Civico",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),

                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () async {
                        if(_capController.text==""||_numero_civicoController.text==""||
                        _provinciaController.text==""||_viaController.text==""||
                        _emailController.text==""||_passwordController.text==""||
                        _telefonoController.text==""||_cognomeFiledController.text==""||
                        _nomeController.text==""){
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              content: Container(
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Inserire le informazioni mancanti!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                      )
                                    ],
                                  )
                              ),
                            );
                          });
                        }
                        else{
                          cliente c=cliente(
                              nome: _nomeController.text.toString(),
                              cognome: _cognomeFiledController.text.toString(),
                              telefono: _telefonoController.text.toString(),
                              email: _emailController.text.toString(),
                              via: _viaController.text.toString(),
                              numCivico: int.parse(_numero_civicoController.text.toString()),
                              provincia: _provinciaController.text.toString(),
                              cap: _capController.text.toString()
                          );
                          try {
                            Map<String, String> headers = Map();
                            headers[HttpHeaders.contentTypeHeader] = "application/json;charset=utf-8";
                            dynamic body = json.encode(c);
                            Uri uri = Uri.parse("http://localhost:80/users/");
                            var response = await http.post(uri, headers: headers, body: body);
                            if (response.body.contains("ERROR_MAIL_USER_ALREADY_EXISTS")) {
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  content: Container(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("L'email inserita appartiene ad un altro utente",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                          )
                                        ],
                                      )
                                  ),
                                );
                              });

                            }
                            else{added=true;}

                            if(added==true){
                              Map<String, String> headers2 = Map();
                              headers2[HttpHeaders.contentTypeHeader] =
                              "application/x-www-form-urlencoded";

                              Map<String, String> params = Map();
                              params["grant_type"] = "password";
                              params["client_id"] = "****";
                              params["client_secret"] =
                              "****";
                              params["username"] = "proprietario";
                              params["password"] = "****";

                              dynamic formattedBody = params.keys.map((key) => "$key=${params[key]}").join("&");

                              Uri uri2 = Uri.parse("http://localhost:8080/auth/realms/****/protocol/openid-connect/token");

                              var result = await http.post(
                                  uri2, headers: headers2, body: formattedBody);
                              AuthenticationData _authenticationData = AuthenticationData
                                  .fromJson(jsonDecode(result.body));
                              print(_authenticationData.accessToken);
                              String token=_authenticationData.accessToken;

                              Uri uri3 = Uri.parse(
                                  "http://localhost:8080/auth/admin/realms/****/users");

                              Map<String,String>headers3 = Map();
                              headers3[HttpHeaders.contentTypeHeader] =
                              "application/json;charset=utf-8";
                              headers3[HttpHeaders.authorizationHeader] =
                              'bearer $token';

                              User user = new User();
                              user.username = _emailController.text;
                              user.email = _emailController.text;
                              List<CredentialRepresentation> list = new List.filled(
                                  1, new CredentialRepresentation(
                                  _passwordController.text));
                              user.cr = list;
                              dynamic body3 = userToJson(user);

                              var response2 = await http.post(
                                  uri3, headers: headers3, body: body3);

                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  content: Container(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Utente registrato con successo",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                          ),
                                          Text("Vai a fare il login!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15),
                                          )
                                        ],
                                      )
                                  ),
                                );
                              });
                            }


                          }catch(e){}
                        }


                      },
                      child: Text("Registrati!"),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}