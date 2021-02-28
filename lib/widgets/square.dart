import 'package:flutter/material.dart';
import 'package:notz/classes/Product.dart';
class Square extends StatelessWidget {
  Product p;
  Function f;
  Square(this.p,{this.f});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: ()async{
      Map m=new Map();
      m['product']=p;

      dynamic res=await Navigator.pushNamed(context, '/productView',arguments: m,);
      f(res);

    },
      child: Container(height: 220,width:220,margin: EdgeInsets.fromLTRB(7.5, 15, 7.5, 0),
        child: Column(children: [
          Expanded(flex:5,child: Text(p.title,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),)),
          Expanded(flex: 10,
            child: Image.network(p.photos[0]
            ,height: 140,),
          ),
          Expanded(flex:2,child: Text(p.model,style: TextStyle(fontWeight: FontWeight.bold),)),
          Expanded(flex:2,child: Text(p.upc,style: TextStyle(fontWeight: FontWeight.bold))),

        ],),

      ),
    );
  }
}
