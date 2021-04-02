import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class StringField extends StatefulWidget {
  String field;
  Function(String val) callback;
  Function onRemove;
  StringField({this.field,this.callback});
  @override
  _StringFieldState createState() => _StringFieldState();
}

class _StringFieldState extends State<StringField> {
  @override
  Widget build(BuildContext context) {
    return Card(elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: Colors.blue,width: 2) ),
      child: Container(width: 240,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(width: 198,padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: TextField(
                maxLines:null,style: TextStyle(fontSize: 14,height: 1),
                decoration: InputDecoration(labelText: widget.field,labelStyle: TextStyle(fontSize: 12),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),onChanged: (val){
                widget.callback(val);
              },),
            ),
            IconButton(padding: EdgeInsets.fromLTRB(0, 14, 8, 0),iconSize:12,icon: Icon(Icons.clear,color: Colors.blue),onPressed: widget.onRemove,),
          ]),
      ),
    );
   // );
  }
}
