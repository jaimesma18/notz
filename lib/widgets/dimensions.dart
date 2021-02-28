import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Dimensions extends StatefulWidget {
  Map dimensions;
 bool edit;
  Dimensions({this.dimensions,this.edit});
  @override
  _DimensionsState createState() => _DimensionsState();
}

class _DimensionsState extends State<Dimensions> {
  @override
  int group=1;
  String cm="cm";
  String kg="kg";
  double multKg=1;
  double multCm=1;
  Widget build(BuildContext context) {

    if(group==0){
     cm="in";
     kg="lb";
     multKg=2.2046226;
     multCm=0.39370079;
    }
    else{
      cm="cm";
      kg="kg";
      multKg=1;
      multCm=1;
    }
    return
      Column(
        children: [
        /*  Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("CARACTERÍSTICAS"),
          ],
        ),
          SizedBox(height: 10,),*/
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(height: 400,width: 300,
                child: Column(//crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
                      Expanded(flex:6,
                        child: ListTile(leading: Radio(value: 1,onChanged: (val){
                          setState(() {
                            group=val;
                          });
                        },groupValue:group ,),title: Text("kg / cm",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),),
                      ),
                      Expanded(flex:1,child: Container()),
                      Expanded(flex: 6,
                        child: ListTile(leading: Radio(value: 0,onChanged: (val){
                          setState(() {
                            group=val;
                          });
                        },groupValue: group,),title: Text("lb / in",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),),
                      )
                    ],),
                    SizedBox(height: 10,),
                    Row(
                      children: [Expanded(flex:4,child: FlatButton(child: Text("\u2022",style: TextStyle(fontSize: 24),),onPressed: (){Clipboard.setData(new ClipboardData(text:widget.dimensions['wt']*multKg));},)),
                        //Expanded(flex:1,child: Container()),
                        Expanded(flex:4,child: Text("Peso: ")),
                       // Expanded(flex:1,child: Container()),
                        Expanded(flex:4,child: new SelectableText("${(widget.dimensions['wt']*multKg).toStringAsFixed(3)}"),),
                        Expanded(flex:2,child: Text(kg)),
                      ],
                    ),
                    SizedBox(height: 8,),

                  Row(
                    children: [Expanded(flex:4,child: FlatButton(child: Text("\u2022",style: TextStyle(fontSize: 24),),onPressed: (){Clipboard.setData(new ClipboardData(text:widget.dimensions['l']*multCm));},)),
                      //Expanded(flex:1,child: Container()),
                      Expanded(flex:4,child: Text("Largo: ")),
                      // Expanded(flex:1,child: Container()),
                      Expanded(flex:4,child: new SelectableText("${(widget.dimensions['l']*multCm).toStringAsFixed(2)}"),),
                      Expanded(flex:2,child: Text(cm)),
                    ],),


                    SizedBox(height: 8,),

                      Row(
                        children: [Expanded(flex:4,child: FlatButton(child: Text("\u2022",style: TextStyle(fontSize: 24),),onPressed: (){Clipboard.setData(new ClipboardData(text:widget.dimensions['w']*multCm));},)),
                          //Expanded(flex:1,child: Container()),
                          Expanded(flex:4,child: Text("Ancho: ")),
                          // Expanded(flex:1,child: Container()),
                          Expanded(flex:4,child: new SelectableText("${(widget.dimensions['w']*multCm).toStringAsFixed(2)}"),),
                          Expanded(flex:2,child: Text(cm)),
                      ],
                    ),
                    SizedBox(height: 8,),

                      Row(
                      children: [Expanded(flex:4,child: FlatButton(child: Text("\u2022",style: TextStyle(fontSize: 24),),onPressed: (){Clipboard.setData(new ClipboardData(text:widget.dimensions['h']*multCm));},)),
                      //Expanded(flex:1,child: Container()),
                      Expanded(flex:4,child: Text("Alto: ")),
                      // Expanded(flex:1,child: Container()),
                      Expanded(flex:4,child: new SelectableText("${(widget.dimensions['h']*multCm).toStringAsFixed(2)}"),),
                      Expanded(flex:2,child: Text(cm)),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Align(alignment:Alignment.centerLeft,child: Text(widget.dimensions['notas']??"")),
                  ],),

              ),
            ),
          ),
        ],
      );

  }
}
