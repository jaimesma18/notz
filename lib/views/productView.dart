//import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:notz/services/auth.dart';
/*import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_image/barcode_image.dart';*/
import 'package:image/image.dart' as img;
import 'package:notz/widgets/barcode.dart';
import 'package:notz/widgets/bullets.dart';
import 'package:notz/widgets/dimensions.dart';
import 'package:notz/widgets/carousel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:notz/classes/Product.dart';
import 'package:notz/services/db.dart';
import 'package:notz/views/users.dart';

class ProductView extends StatefulWidget {
  @override

  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  final AuthService _auth=AuthService();
 Widget selectedWidget;
 String selectedWidgetText="Características";
  Map permissions;
  bool loaded=false;
  Map data=new Map();
  //int sgroup;
  //String model="LC-1192";
  Product product;
  TextEditingController search= new TextEditingController();
  ScrollController scroller=new ScrollController();


  @override
  void initState() {
    super.initState();

    init();

  }

  Future init()async{


    //product=await downloadProduct(model);
    permissions=await _auth.permissions();

    //int res=await _auth.securityGroup();

    if(this.mounted){
    setState(() {
     // sgroup= res;


    });}


  }
 

Future<Product> downloadProduct(String model)async{
    DatabaseService db=new DatabaseService();

    return await db.getProducto(model);
}



  @override
  Widget build(BuildContext context) {
    if(permissions==null){

    }
    else {
      final double deviceWidth = MediaQuery
          .of(context)
          .size
          .width;
      bool isMobile;
      deviceWidth >= 768 ? isMobile = false : isMobile = true;
      if (!loaded) {
        data = ModalRoute
            .of(context)
            .settings
            .arguments;
        if (data == null) {
          Navigator.pop(context);
        }

        else {
          product = data['product'];
          selectedWidget = Bullets(bullets: product
              .bullets,edit: permissions[selectedWidgetText]>1,model: product.model,);

          loaded = true;
        }
      }
      //print(product.upc);
    }




    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(title: TextBox(),
        actions: [
          /*IconButton(icon: Icon(Icons.logout,size: 26),onPressed: ()async{
            await _auth.signOut();
          },)*/
        ],),
      body: product==null||permissions==null?Container():
      Scrollbar(isAlwaysShown: true,controller: scroller,
        child: SingleChildScrollView(scrollDirection: Axis.vertical,child:
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(34, 8, 0, 14),
                  child: permissionsBar(),
                ),
                SizedBox(height: 10,),
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex:2,child: Container()),
                    Expanded(flex:14,child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(product.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                      SizedBox(height: 10,),
                      RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            letterSpacing: .6,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: 'Marca: ',style: new TextStyle(fontWeight: FontWeight.bold)),
                            new TextSpan(text: product.brand, ),
                          ],
                        ),
                      ),
                        SizedBox(height: 4,),
                        RichText(
                          text: new TextSpan(
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              new TextSpan(text: 'Modelo: ',style: new TextStyle(fontWeight: FontWeight.bold)),
                              new TextSpan(text: product.model, ),
                            ],
                          ),
                        ),
                      SizedBox(height: 10,),

                       selectedWidget,
                       // Dimensions(dimensions: product.dimensions,)
                      //Bullets(bullets:product.bullets),
                    ],)),
                    Expanded(flex:2,child: Container()),
                    Expanded(flex: 14,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40,),
                         // Container(child: Text("$sgroup"),),
                          Stack(children: [

                            Positioned(top: 0,right: 70,
                              child: IconButton(icon: Icon(Icons.edit,color: Colors.blue,),onPressed:()async
                               {
                                 Map m=new Map();
                                 m['model']=product.model;
                                 print('pre');
                                  await Navigator.pushNamed(context, "/imageEditor",arguments: m);

                                   print('post');
                                 product= await  downloadProduct(product.model);

                                 print(product.photos);

                              },),
                            ),

                            Container(padding:EdgeInsets.all(40),child: Carousel(urls:product.photos))]),

                         /* Row(
                            children: [
                              Expanded(flex:3,child: Container(),),
                              product.upc!=null?kIsWeb?Expanded(flex:3,child: Container(width: 10,child: BarcodeWidget(data: product.upc, barcode: Barcode.ean13()))):Expanded(flex:7,child: Container(width: 10,child: BarcodeWidget(data: product.upc, barcode: Barcode.ean13()))):Container(),
                              Expanded(flex:3,child: Container(),),
                            ],
                          ),
                          IconButton(icon: Icon(Icons.download_rounded),onPressed: ()async{
                            print(Barcode.ean13().isValid(product.upc));

                          //  buildBarcode(Barcode.ean13(), "7506304311925");
                            *//*if(kIsWeb){
                              final image = Image(600, 350);

                              // Fill it with a solid color (white)
                              fill(image, getColor(255, 255, 255));

                              // Draw the barcode
                              drawBarcode(image, Barcode.code128(), 'Test', font: arial_24);

                              // Save the image
                              File('barcode.png').writeAsBytesSync(encodePng(image));
                            }
                            else{

                            }*//*
                             //   buildBarcode(Barcode.ean13(), "7506304311925",filename: "bc_7506304311925",height: 200,width: 400,fontHeight: 20);
                          },),*/
                        ],
                      ),
                    ),
                    Expanded(flex:1,child: Container()),
                  ],
                ),
              ],
            ),
          ),

        ),
      )


    );
  }

  Widget TextBox2(){
    return Align(alignment: Alignment.centerLeft,
      child: Container(
          decoration: new BoxDecoration(
           border: Border.all(color: Colors.white,width: 2),
              borderRadius: BorderRadius.all(Radius.circular(14))
      ),
          width: 600,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex:2,child: IconButton(icon:Icon(Icons.search),onPressed: (){
                print(search.text);
              },)),
               Expanded(flex: 20,
                 child: TextField(

                     decoration: InputDecoration.collapsed(
                      hintStyle: new TextStyle(letterSpacing:.6,wordSpacing: 1,color: Colors.white,fontSize: 16),
                      hintText: "Buscar modelo, UPC o palabras clave",
                     // fillColor: Colors.white70),
                  )),
               ),

            ],
          ),
        ),
      ),
    );
  }

  Widget TextBox(){
    return Container(
        //color: bgColor,
        child: Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex:2,child: IconButton(icon:Icon(Icons.search),onPressed: (){
              if(search.text!=null||search.text!=""){
                Navigator.pop(context,search.text);
              }
            },)),
            Expanded(flex: 50,
              child: TextField(onSubmitted: (val){

                Navigator.pop(context,val);
              },
                controller:search,cursorColor:Colors.white,style:TextStyle(color: Colors.white, fontSize: 18),onChanged: (val){

                /* setState(() {

                  });*/
                },
                decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Buscar modelo, UPC o palabras clave',hintStyle: TextStyle(letterSpacing:.6,wordSpacing: 1,color: Colors.white,fontSize: 16)),
              ),
            ),
          ],
        )
    );
  }

  Widget permissionsBar(){

    bool mobile=false;

    Map<String,Widget> widgets=new Map<String,Widget>();
    widgets['Características']=Bullets(bullets:product.bullets,edit: permissions["Características"]>1,model: product.model,);
    widgets['Medidas']=Dimensions(dimensions:product.dimensions,edit: permissions["Medidas"]>1?true:false);
    widgets['Código de Barras']=BCode(upc:product.upc,edit: permissions["Código de Barras"]>1?true:false,mobile: mobile,);
    widgets['Usuarios']=Users();

    List l0=permissions.keys.toList();
    l0.sort((a, b) => a.toString().compareTo(b.toString()));
    if(permissions!=null){
      List<Widget> l=[];
      l.add(VerticalDivider(color: Colors.black,thickness: 1,));
      for(var x in l0){
        if(permissions[x]>0){
          Color c=Colors.black;
          if(x==selectedWidgetText){
            c=Colors.blue;
          }
          l.add(FlatButton(child: Text(x,style: TextStyle(color: c),),onPressed: (){
            setState(() {
              selectedWidget=widgets[x];
              selectedWidgetText=x;
            });
          },));
          l.add(SizedBox(width: 4,));
          l.add(VerticalDivider(color: Colors.black,thickness: 1,));
        }
      }

    //  l.removeLast();
     return SingleChildScrollView(scrollDirection:Axis.horizontal,child: Container(child: IntrinsicHeight(child: Row(mainAxisAlignment:MainAxisAlignment.start,children: l)),));
    }
  }



}
