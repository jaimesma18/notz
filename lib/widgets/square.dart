import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notz/classes/Product.dart';
import 'package:notz/services/storageManager.dart';
class Square extends StatelessWidget {
  Product p;
  Function f;
  Square(this.p,{this.f});
  Uint8List bytes;
  bool imageLoaded=false;

  Future<bool> getPhoto()async {

    if(p.photos2!=null&&p.photos2[0]!=null) {
      bytes = await StorageManager().downloadFile(
          "productos/${p.model}/${p.photos2[0]}");
      imageLoaded=true;
    }
    else{
      bytes=(await rootBundle.load('assets/images/logo_Lloyds.jpg'))
          .buffer
          .asUint8List();
    }
    if(bytes==null){
      (await rootBundle.load('assets/images/logo_Lloyds.jpg'))
          .buffer
          .asUint8List();
    }


    return true;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(


      future: getPhoto(),
      builder: (context, snapshot)
  {






      final double deviceWidth = MediaQuery
          .of(context)
          .size
          .width;
      bool isMobile;
      deviceWidth >= 768 ? isMobile = false : isMobile = true;
      String prodView = "/productView";
      if (isMobile) {
        prodView = "/productViewMobile";
      }
      if(snapshot.hasData) {

      return GestureDetector(onTap: () async {
        Map m = new Map();
        m['product'] = p;


        dynamic res = await Navigator.pushNamed(
          context, prodView, arguments: m,);
        f(res);
      },
          child: !isMobile ? Container(height: 220,
            width: 220,
            margin: EdgeInsets.fromLTRB(7.5, 15, 7.5, 0),
            child: Column(children: [
              Expanded(flex: 2,
                  child: Text(p.model, textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),)),
              Expanded(flex: 10,
                child:
                imageLoaded==false? Opacity(opacity:0.5,child: Image.asset("assets/images/logo_Lloyds.jpg",height: 140,))
                :Image.memory(bytes,height: 140,)
                //Image.network(p.photos[0],height: 140,),
              ),
              Expanded(flex: 5,
                  child: Text(p.title, textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),)),
              // Expanded(flex:2,child: Text(p.upc,style: TextStyle(fontWeight: FontWeight.bold))),

            ],),

          ) :
          Container(height: 220,
            width: 220,
            margin: EdgeInsets.fromLTRB(7.5, 15, 7.5, 0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              child: Column(children: [
                Expanded(flex: 2,
                    child: Text(p.model, textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),)),
                Expanded(flex: 10,
                  child:
                  imageLoaded==false? Opacity(opacity:0.5,child: Image.asset("assets/images/logo_Lloyds.jpg",height: 140,))
                      :Image.memory(bytes,height: 140,)
                  //Image.network(p.photos[0], height: 140,),
                ),
                Expanded(flex: 4,
                    child: Text(p.title, textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),)),
                // Expanded(flex:2,child: Text(p.upc,style: TextStyle(fontWeight: FontWeight.bold))),


              ],),
            ),

          )
      );
    }
    else{

      return
       /* Container(height: 220,
        width: 220,
        margin: EdgeInsets.fromLTRB(7.5, 15, 7.5, 0),
        child: Column(children: [
          Expanded(flex: 2,
              child: Text(p.model, textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),)),
          Expanded(flex: 10,
            child:
           // Container(),
            Image.asset("assets/images/logo_Lloyds.jpg",height: 140,)
            //Image.network("https://m.facebook.com/855398481144319/photos/a.855403197810514/5427040920646696/?type=3&source=54&ref=page_internal"),
          ),
          Expanded(flex: 5,
              child: Text(p.title, textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),)),
          // Expanded(flex:2,child: Text(p.upc,style: TextStyle(fontWeight: FontWeight.bold))),

        ],),

      );*/
        CircularProgressIndicator();
    }


  }

);
}
