import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class BoolField extends StatefulWidget {
  String field;
  Function callback;
  Function onRemove;
  List<bool> selected;
  BoolField({this.field,this.callback,this.selected});
  @override
  _BoolFieldState createState() => _BoolFieldState();
}

class _BoolFieldState extends State<BoolField> {
//List<bool> selected;
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
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Container(width: 198,padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: ToggleButtons(children: [
                  Icon(Icons.check_outlined),
                  Icon(Icons.clear_outlined)
                ],
                  isSelected: widget.selected,
                  onPressed: (index){
                  setState(() {
                    widget.selected[index]=! widget.selected[index];
                    widget.selected[(index-1)^2]=! widget.selected[(index-1)^2];
                  });
                  widget.callback();
                  },
                  color: Colors.grey,
                  selectedColor:  widget.selected[0]?Colors.green:Colors.red,
                  fillColor: Colors.lightBlue[100],

                ),
              ),
              IconButton(padding: EdgeInsets.fromLTRB(0, 14, 8, 0),iconSize:12,icon: Icon(Icons.clear,color: Colors.blue),onPressed: widget.onRemove,),
            ]),
        ),
      ),
    );
   // );
  }
}
