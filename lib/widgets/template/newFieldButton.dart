import 'package:flutter/material.dart';

class NewFieldButton extends StatefulWidget {
  Function callback;
  TextEditingController controller;
  NewFieldButton({this.controller,this.callback});
  @override
  _NewFieldButtonState createState() => _NewFieldButtonState();
}

class _NewFieldButtonState extends State<NewFieldButton> {
  @override
  Widget build(BuildContext context) {
    return Container(width: 350,height: 350,
        child: Card(elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: Colors.blue,width: 2) ),
          child: SizedBox.expand(child:
          Column(
            children: [

              Expanded(flex: 4,
                child: Padding(
                  padding:EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      Container(height: 30,
                        child: TextField(
                          controller: widget.controller,decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        //  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                         /* enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[200],width: 2),
                          ),*/
                          hintText: "Nombre del campo...",hintStyle: TextStyle(color: Colors.blue[200],),),
                        style: TextStyle(color: Colors.blue),),
                      ),
                      Divider(thickness: 2,color: Colors.blue[200],)
                    ],
                  ),
                ),
              ),
              Expanded(flex: 11,
                child: Container(
                  child: SizedBox.expand(
                    child: TextButton(child:
                    // Text("+",style: TextStyle(fontSize: 128,color: Colors.blue),),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                      child: Icon(Icons.add,size: 96,color: Colors.blue,),
                    ),
                      onPressed: (){
                        if(widget.controller.text!="") {
                          widget.callback();
                        }
                      },),
                  ),
                ),
              ),

            ],
          ),),
        ));
  }
}
