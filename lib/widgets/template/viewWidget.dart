import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';


class ViewWidget extends StatefulWidget {

  String field;
  dynamic value;
 
  ViewWidget({this.field,this.value});
  @override
  _ViewWidgetState createState() => _ViewWidgetState();
}

class _ViewWidgetState extends State<ViewWidget> {

  Icon icon;
  String string;
  Color c;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return wrapCard();

  }

  Widget wrapCard(){
    return Container(width: 100,height: 80,
      child: Card(elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: Colors.blue,width: 2) ),
        child: Container(width: 240,
          child: Stack(
            children: [
              Padding(
                padding:  EdgeInsets.fromLTRB(0,15,0,0),
                child: createCard(),
              ),
              Positioned(left:10,top: 4,child: FittedBox(  fit: BoxFit.fitWidth,child: Text(widget.field,style: TextStyle(fontSize: 12,color: Colors.blue),))),
            ],
          ),
        ),
      ),
    );
  }

  Widget createCard(){

    dynamic val=widget.value;
    if (val==null){
      val="";
    }
    if(val==true){
      val="Sí";
    }
    if(val==false){
      val="No";
    }

    val='$val';

      return SizedBox.expand(
        child: (
        FlatButton(child:FittedBox(  fit: BoxFit.fitWidth,
            child: Text(val,style: TextStyle(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.bold),))
          ,onPressed: (){

        },

        )),
      );
    }
  }


