import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Oggetti/NavDrawer.dart';
import 'package:nuovo_flutter/Pagine/InfoUtente.dart';

import 'Carrello.dart';
import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class Modifica extends StatefulWidget{
  String refreshToken;
  bool logged;
  cliente utente;

  bool added = false;


  List<ProductInPurchase> carrello;
  Modifica(List<ProductInPurchase> carrello,bool logged, cliente utente,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
    this.utente=utente;
    this.logged=logged;
  }

  @override
  State<StatefulWidget> createState() {
    return ModificaState(carrello,logged,utente,refreshToken);
  }

}

class ModificaState extends State<Modifica>{
  String refreshToken;
  bool logged;
  cliente utente;
  bool added = false;
  List<ProductInPurchase> carrello;

  TextEditingController _capController = TextEditingController();
  TextEditingController _viaController = TextEditingController();
  TextEditingController _provinciaController = TextEditingController();
  TextEditingController _numero_civicoController = TextEditingController();

  ModificaState(List<ProductInPurchase> carrello,bool logged, cliente utente,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
    this.utente=utente;
    this.logged=logged;
  }

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
              padding: EdgeInsets.only(top: 25,bottom:50),
              child: Text(
                "Modifica indirizzo di spedizione",
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
            Padding(padding: EdgeInsets.only(top:20),
            child:ElevatedButton(
              child: Text("Modifica"),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
              onPressed: ()async{
                String via1=null;
                String provincia1=null;
                int numCivico1=null;
                String cap1=null;
                if(_viaController.text==""){
                  via1=utente.via;
                }
                else
                  via1=_viaController.text.toString();

                if(_provinciaController.text==""){
                  provincia1=utente.provincia;
                }
                else
                  provincia1=_provinciaController.text.toString();

                if(_numero_civicoController.text==""){
                  numCivico1=utente.numCivico;
                }
                else
                  numCivico1=int.parse(_numero_civicoController.text.toString());

                if(_capController.text==""){
                  cap1=utente.cap;
                }
                else
                  cap1=_capController.text.toString();

                cliente c=cliente(
                    id:utente.id,
                    nome: utente.nome,
                    cognome: utente.cognome,
                    telefono: utente.telefono,
                    email: utente.email,
                    via: via1,
                    numCivico: numCivico1,
                    provincia: provincia1,
                    cap: cap1
                );
                utente=c;
                try{
                  Map<String, String> headers = Map();
                  headers[HttpHeaders.contentTypeHeader] = "application/json;charset=utf-8";
                  dynamic body = json.encode(c);
                  Uri uri = Uri.parse("http://localhost:80/users/");
                  var response = await http.put(uri, headers: headers, body: body);
                  if(response.statusCode!=200){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        content: Container(
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Errore durante le modifiche, riprova",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25),
                                ),
                              ],
                            )
                        ),
                      );
                    });
                  }
                  else
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>InfoUtente(carrello, logged, utente,refreshToken).build(context)));
                }catch(e){}

              },
            ),
            )
          ],
        ),
      ),
    );
  }

}