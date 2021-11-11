
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuovo_flutter/Entities/Cliente.dart';
import 'package:nuovo_flutter/Entities/ProductInPurchase.dart';
import 'package:nuovo_flutter/Entities/Purchase.dart';
import 'package:nuovo_flutter/Entities/User.dart';
import 'package:nuovo_flutter/Entities/prodotto.dart';
import 'package:nuovo_flutter/Pagine/Pagamento.dart';

import 'CarrelloVuoto.dart';
import 'CercaHome.dart';
import '../Oggetti/MyFloatingButton.dart';
import '../Oggetti/NavDrawer.dart';
import '../Oggetti/ProdottoCard.dart';
import 'LoggedPage.dart';
import 'NoLogin.dart';
import 'NotLoggedYet.dart';

class CarrelloFisico extends StatelessWidget{
  bool logged;
  cliente user;
  List<ProductInPurchase> prodotti;
  String refreshToken;



  CarrelloFisico(List<ProductInPurchase> prodotti,bool logged,cliente user,String refreshToken){
    this.refreshToken=refreshToken;
    this.prodotti=prodotti;
    this.logged=logged;
    this.user=user;
  }

  waiting(){
    return Center(
      child: CircularProgressIndicator(),
    );

  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,

          title: Text('MyEcommerce',),
          actions:<Widget> [
            IconButton(icon: Icon(Icons.search),tooltip: 'Search',
                onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>CercaHomeState(prodotti, logged, user,refreshToken).build(context)));}),
            IconButton(icon: Icon(Icons.account_box_outlined), onPressed:(){
              if (logged)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => loggedPage(prodotti,logged,user,refreshToken),
                  ),
                );
              else
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoLogin(prodotti,logged,user,refreshToken),
                  ),
                );
            },),
            IconButton(icon: Icon(Icons.shopping_cart_outlined), tooltip: 'Shopping Cart',
              onPressed:(){
                if(!logged)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotLoggedYet(prodotti,logged,user,refreshToken),
                    ),
                  );
                else if (prodotti.isNotEmpty)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CarrelloFisico(prodotti,logged,user,refreshToken),
                    ),
                  );
                else
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CarrelloVuoto(prodotti,logged,user,refreshToken),
                    ),
                  );
              },)
          ],

        ),
        drawer: NavDrawer(prodotti,logged,user,refreshToken),
        body: Scrollbar(
          child: Container(
            child: Center(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: prodotti.length,
                itemBuilder: (BuildContext context, int index) {
                  if(index==0)
                    return Column(children: [
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 550),
                              child: ElevatedButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PagamentoState(prodotti,user,logged,refreshToken).build(context)));
                                },
                                child: Text('Procedi all\'acquisto'),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),
                              ),
                          ),
                          
                          Padding(
                              padding: EdgeInsets.only(left: 400),
                              child: Text("Totale: ${_CalcolaTotale(prodotti)}",
                                style: TextStyle(fontSize: 30),
                              ),
                          )
                        ],
                      ),
                      Divider(color: Colors.deepOrangeAccent,),
                      Container(
                        height: 100,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.all(5),child: Image.network(prodotti[index].product.immagine, width: 95,height: 95,),),
                              Padding(
                                padding: EdgeInsets.only(left: 350),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(padding: EdgeInsets.all(5), child: Text(prodotti[index].product.name.toUpperCase()),),
                                    Padding(padding: EdgeInsets.all(5), child: Text('Quantità: '+prodotti[index].quantity.toString()))
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 350),child: Text("Prezzo: "+prodotti[index].product.price.toString()),),
                              Padding(
                                padding: EdgeInsets.only(left:0),
                                child:IconButton(icon: Icon(Icons.remove_shopping_cart),
                                  onPressed: (){
                                    prodotti.remove(prodotti[index]);
                                    if (prodotti.isNotEmpty)
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CarrelloFisico(prodotti,logged,user,refreshToken),),);
                                    else
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CarrelloVuoto(prodotti,logged,user,refreshToken),),);
                                  },) ,)
                            ],
                          ),
                        ),
                      )
                    ],);
                  else
                    return Container(
                      height: 100,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.all(5),child: Image.network(prodotti[index].product.immagine, width: 95,height: 95,),),
                            Padding(
                              padding: EdgeInsets.only(left: 350),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.all(5), child: Text(prodotti[index].product.name.toUpperCase()),),
                                  Padding(padding: EdgeInsets.all(5), child: Text('Quantità: '+prodotti[index].quantity.toString()))
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 350),child: Text("Prezzo: "+prodotti[index].product.price.toString()),),
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child:IconButton(icon: Icon(Icons.remove_shopping_cart),
                                onPressed: (){
                                  prodotti.remove(prodotti[index]);
                                  if (prodotti.isNotEmpty)
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CarrelloFisico(prodotti,logged,user,refreshToken),
                                      ),
                                    );
                                  else
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CarrelloVuoto(prodotti,logged,user,refreshToken),
                                      ),
                                    );
                                },) ,)
                          ],
                        ),
                      ),
                    );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
            ),

          ),
        ),
      );

  }
  
  double _CalcolaTotale(List<ProductInPurchase> prodotti){
    double totale=0;
    for(ProductInPurchase pip in prodotti)
      totale+=pip.quantity*pip.product.price;
    return totale;
      
  }

}

