import 'dart:math';
import 'package:multi_select_flutter/multi_select_flutter.dart' as multiSelect;
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:universal_html/html.dart';

class MultiField extends StatefulWidget {
  String field;
  Function callback;
  Function onRemove;
  Map<String,bool> valuesMap;
  bool mandatory;
  bool singleSelection;
  Function validate;
  MultiField({this.field,this.callback,this.valuesMap,this.onRemove,this.mandatory,this.singleSelection,this.validate});
  @override
  _MultiFieldState createState() => _MultiFieldState();
}

class _MultiFieldState extends State<MultiField> {
//List<bool> selected;
ScrollController scroller=new ScrollController();
bool neverSelected=true;
String displaySingleSelection="";
bool isValid;
  @override
  void initState() {

    isValid=widget.validate();

    if(widget.singleSelection!=null){

      if(widget.singleSelection){
        displaySingleSelection="Selecciona solo 1";
      }
      else{
        displaySingleSelection="Selecciona 1 o más";
      }
    }

    super.initState();

  }

  bool logicalOr(List<bool> l){
    bool res=false;
    int i=0;

    while(!res&&i<l.length){
      if(l[i]){
        res=true;
      }
      else{
        i++;
      }
    }
    return res;

  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 200,height: 60,
      child: Card(elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: Colors.blue,width: 2) ),
        child: Container(width: 240,
          child: Stack(
            children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10,20,40,0),
              child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 36),
               // Container(width: 198,padding: EdgeInsets.fromLTRB(60, 20, 10, 0),
              child: (multiSelect.MultiSelectChipDisplay(
                textStyle: TextStyle(color: Colors.blue[900]),

                //decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                //chipColor: Colors.green,
                colorator: (index){
                  if(widget.valuesMap[index]){
                    return Colors.lightBlue[600];
                  }
                  else{
                    return Colors.lightBlue[50];
                  }
                },
                scroll: true,
                items: widget.valuesMap.keys.toList().map((e) => MultiSelectItem(e, e)).toList(),
                onTap: (index){
                if(widget.singleSelection){
                  for(var x in widget.valuesMap.keys){
                    widget.valuesMap[x]=false;
                  }
                  setState(() {
                    widget.valuesMap[index]=true;
                  });

                }
                else{
                  setState(() {
                    widget.valuesMap[index]=! widget.valuesMap[index];
                  });

                }
                widget.callback();
                setState(() {
                  isValid=widget.validate();
                });
                },
              )),
                ),
            ),
              Positioned(left:10,top: 4,child: Text(widget.field,style: TextStyle(fontSize: 12,color: widget.mandatory&&(!logicalOr(widget.valuesMap.values.toList()))?Colors.red:isValid?Colors.blue:Colors.amber[600]),)),
              Positioned(right:0,bottom: 10,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:18,icon: Icon(Icons.delete,color: widget.mandatory?Colors.grey:Colors.blue),onPressed: widget.mandatory?null:widget.onRemove,)),
              Positioned(right:10,top: 4,child: Tooltip(message: displaySingleSelection,decoration:BoxDecoration(color: Colors.blue,border: Border.all(color: Colors.blue[200]),borderRadius: BorderRadius.circular(6)) ,
                child: Icon(Icons.info_outline_rounded,color: Colors.blue,size: 18,),
              )),
             // Positioned(left:10,top: 4,child: Text(widget.field,style: TextStyle(fontSize: 12,color: Colors.blue),)),
             // Positioned(right:10,bottom: 16,child: IconButton(padding: EdgeInsets.fromLTRB(0, 14, 8, 0),iconSize:18,icon: Icon(Icons.delete,color: Colors.blue),onPressed: widget.onRemove,))
        ]  ),
        ),
      ),
    );
   // );
  }
}
