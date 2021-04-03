import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class StringField extends StatefulWidget {
  String field;
  TextEditingController controller;
  Function callback;
  Function onRemove;
  StringField({this.field,this.callback,this.controller,this.onRemove});
  @override
  _StringFieldState createState() => _StringFieldState();
}

class _StringFieldState extends State<StringField> {

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
              },),
            ),
              Positioned(left:10,top: 4,child: Text(widget.field,style: TextStyle(fontSize: 12,color: Colors.blue),)),
              Positioned(right:10,bottom: 16,child: IconButton(padding: EdgeInsets.fromLTRB(0, 14, 8, 0),iconSize:18,icon: Icon(Icons.delete,color: Colors.blue),onPressed: widget.onRemove,))
          ],
          ),
        ),
      ),
    );
   // );
  }
}
