import 'package:flutter/material.dart';
//import 'package:universal_html/html.dart';

class StringField extends StatefulWidget {
  String field;
  TextEditingController controller;
  Function callback;
  Function onRemove;
  String tooltip;
  bool mandatory;
  String type;
  Function validate;
  StringField({this.field,this.callback,this.controller,this.onRemove,this.mandatory,this.type,this.validate,this.tooltip});
  @override
  _StringFieldState createState() => _StringFieldState();
}

class _StringFieldState extends State<StringField> {

  String tooltip="";

  @override
  void initState() {
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
            Container(width: 198,padding: EdgeInsets.fromLTRB(10, 0, 10, 16),
              child: TextField(controller: widget.controller,
                maxLines:null,style: TextStyle(fontSize: 14),
                decoration: InputDecoration(isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(4, 30, 0, 10),
                 // labelText: widget.field,labelStyle: TextStyle(fontSize: 12),floatingLabelBehavior: FloatingLabelBehavior.never,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),onChanged: (val){

                  widget.callback();
                  setState(() {

                  });
              },),
            ),
              Positioned(left:10,top: 4,child: Text(widget.field,style: TextStyle(fontSize: 12,color: widget.mandatory&&widget.controller.text.isEmpty?Colors.red:widget.controller.text.isNotEmpty&&!widget.validate(widget.controller.text, widget.type)?Colors.amber[600]:Colors.blue),)),
              Positioned(right:0,bottom: 10,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:18,icon: Icon(Icons.delete,color: widget.mandatory?Colors.grey:Colors.blue),onPressed: widget.mandatory?null:widget.onRemove,)),
              Positioned(right:10,top: 4,child: Tooltip(message: widget.tooltip,decoration:BoxDecoration(color: Colors.blue,border: Border.all(color: Colors.blue[200]),borderRadius: BorderRadius.circular(6)) ,
                child: Icon(Icons.info_outline_rounded,color: Colors.blue,size: 18,),
              )),
            ],
          ),
        ),
      ),
    );
   // );
  }
}
