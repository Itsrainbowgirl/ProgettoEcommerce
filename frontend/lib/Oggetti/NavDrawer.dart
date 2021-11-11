
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/User.dart';
import 'package:nuovo_flutter/Pagine/CercaByGenere.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';

import '../main.dart';

class NavDrawer extends StatelessWidget {
  bool logged;
  cliente user;
  List<ProductInPurchase> carrello;
  String refreshToken;

  NavDrawer(List<ProductInPurchase> carrello,bool logged, cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.carrello=carrello;
    this.logged=logged;
    this.user=user;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(children:<Widget> [
              Text(
                'Side menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              Icon(Icons.emoji_nature_outlined,color: Colors.white,),
            ],),
            decoration: BoxDecoration(
                color: Colors.amber,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>MyScaffoldState(carrello,logged,user,refreshToken).build(context)))},

          ),
          Divider(thickness: 2.5,),
          ListTile(
            leading: Icon(Icons.restaurant),
            title: Text('Food'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaGenereState("food",carrello,logged,user,refreshToken).build(context)))},
          ),
          ListTile(
            leading: Icon(Icons.sports_football_outlined),
            title: Text('Sport'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaGenereState("sport",carrello,logged,user,refreshToken).build(context)))},
          ),
          ListTile(
            leading: Icon(Icons.sports_esports_outlined),
            title: Text('Games'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaGenereState('games',carrello,logged,user,refreshToken).build(context)))},
          ),
          ListTile(
            leading: Icon(Icons.dry_cleaning),
            title: Text('Clothes'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaGenereState('clothes',carrello,logged,user,refreshToken).build(context)))},
          ),
        ],
      ),
    );
  }
}