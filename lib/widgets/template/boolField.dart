import 'dart:math';

import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class BoolField extends StatefulWidget {
  String field;
  Function callback;
  Function onRemove;
  List<bool> selected;
  bool mandatory;
  BoolField({this.field,this.callback,this.selected,this.onRemove,this.mandatory});
  @override
  _BoolFieldState createState() => _BoolFieldState();
}

class _BoolFieldState extends State<BoolField> {
//List<bool> selected;
bool neverSelected=true;
  @override
  void initState() {
  //  selected[0]=false;
  //  selected[1]=true;
    super.initState();

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
              padding: const EdgeInsets.fromLTRB(80,20,0,0),
              child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 36),
               // Container(width: 198,padding: EdgeInsets.fromLTRB(60, 20, 10, 0),
              child: ToggleButtons(children: [
                Icon(Icons.check_outlined),
                Icon(Icons.clear_outlined)
              ],
                borderColor: Colors.blue,
                selectedBorderColor: Colors.blue,
                borderWidth: 1,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                //renderBorder: false,
                isSelected: widget.selected,
                onPressed: (index){
                int index2=pow(index-1,2);

                setState(() {
                  if(neverSelected){
                    widget.selected[index] = !widget.selected[index];
                    neverSelected=false;
                  }
                  else {
                    widget.selected[index] = true;//!widget.selected[index];
                    widget.selected[index2] = false;//!widget.selected[index2];
                  }
                });
                widget.callback();
                },
                color: Colors.grey,
                selectedColor:  widget.selected[0]?Colors.green:Colors.red,
                //fillColor: Colors.transparent,//Colors.lightBlue[100],

              ),
                ),
            ),
              Positioned(left:10,top: 4,child: Text(widget.field,style: TextStyle(fontSize: 12,color: widget.mandatory&&widget.selected[0]==widget.selected[1]?Colors.red:Colors.blue),)),
              Positioned(right:0,bottom: 10,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:18,icon: Icon(Icons.delete,color: widget.mandatory?Colors.grey:Colors.blue),onPressed: widget.mandatory?null:widget.onRemove,))
        ]  ),
        ),
      ),
    );
   // );
  }
}
