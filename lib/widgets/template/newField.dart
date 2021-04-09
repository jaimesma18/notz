import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class NewField extends StatefulWidget {
  TextEditingController fieldController;
  String type;
  bool mandatory;
  Function onAccept;
  Function onRemove;
  Function validate;
  NewField({this.onAccept,this.fieldController,this.onRemove,this.mandatory,this.type,this.validate});
  @override
  _NewFieldState createState() => _NewFieldState();
}

class _NewFieldState extends State<NewField> {

  int phase=0;

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
          child:  createCard(),
        ),
      ),
    );
   // );
  }

  Widget createCard(){

    if(phase==0){
      return Center(
        child: SizedBox.expand(
          child: (

          FlatButton(child:
            Icon(Icons.add_circle_outline,size: 48,color: Colors.blue,),
       // IconButton(iconSize:48,padding: EdgeInsets.zero,icon: Icon(Icons.add_circle_outline,color: Colors.blue),
          onPressed: (){
            setState(() {
              phase++;
            });

          },)
          ),
        ),
      );
    }
    else{
      return Container();
    }

  }

}
