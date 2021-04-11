import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';


class SaveCancel extends StatefulWidget {

  bool save;
  Function callback;
  SaveCancel({this.save,this.callback});
  @override
  _SaveCancelState createState() => _SaveCancelState();
}

class _SaveCancelState extends State<SaveCancel> {

  Icon icon;
  String string;
  Color c;

  @override
  void initState() {

    if(widget.save){
      c=Colors.green;
      icon=new Icon(Icons.check_circle,color: c,size: 24,);
      string="Guardar";
    }
    else{
      c=Colors.red;
      icon=new Icon(Icons.cancel,color: c,size: 24,);
      string="Cancelar";
    }
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return wrapCard();
   // );
  }

  Widget wrapCard(){
    return Container(width: 200,height: 40,
      child: Card(elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color:c,width: 2) ),
        child: createCard(),
      ),
    );
  }

  Widget createCard(){

      return Center(
        child: SizedBox.expand(
          child: (
          FlatButton.icon(icon:icon,label: Text(string,style: TextStyle(color: c,),),onPressed: (){
            widget.callback();
          },

          )),
        ),
      );
    }
  }


