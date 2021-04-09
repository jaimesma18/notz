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
  TextEditingController fieldController=new TextEditingController();
  int phase=0;
  String type="";
  List<bool>selected=[];

  @override
  void initState() {
    selected.add(true);
    selected.add(false);
    selected.add(false);
    selected.add(false);
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
          },)),
        ),
      );
    }

   if(phase==1){
     return Container(width: 240,
       child: Stack(
         children: [
           Container(width: 198,padding: EdgeInsets.fromLTRB(10, 0, 10, 16),
             child: TextField(controller: fieldController,
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

                 //widget.callback();
                 setState(() {

                 });
               },),
           ),
           Positioned(left:10,top: 4,child: Text("Nombre del campo",style: TextStyle(fontSize: 12,color: Colors.blue),)),

           Positioned(right:40,bottom: 20,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:28,icon: Icon(Icons.check_circle_outline,color: fieldController.text.isNotEmpty?Colors.green:Colors.grey),onPressed: fieldController.text.isNotEmpty?(){
             fieldController=new TextEditingController();
             setState(() {
               phase=2;
             });
           }:null,)),

           Positioned(right:0,bottom: 20,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:28,icon: Icon(Icons.cancel_outlined,color: Colors.red),onPressed: (){
             fieldController=new TextEditingController();
             setState(() {
               phase=0;
             });
           },)),
         ],
       ),
     );
   }

   if(phase==2){
     return Container(width: 240,
       child: Stack(
         children: [
           Padding(
             padding: const EdgeInsets.fromLTRB(10,25,0,0),
             child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 36),
               // Container(width: 198,padding: EdgeInsets.fromLTRB(60, 20, 10, 0),
               child: ToggleButtons(children: [
                 Text("Tx"),
                 Text("1..N"),
                 Text("1.7"),
                 Text("ToF")
                 //Icon(Icons.),
                // Icon(Icons.clear_outlined)
               ],
                 borderColor: Colors.blue,
                 selectedBorderColor: Colors.blue,
                 borderWidth: 1,
                 borderRadius: BorderRadius.all(Radius.circular(10)),
                 //renderBorder: false,
                 isSelected: selected,
                 onPressed: (index){


                   setState(() {
                    for(var x in selected){
                      x=false;
                    }
                    selected[index]=true;
                   });
                  // widget.callback();
                 },
                 color: Colors.grey,
                 selectedColor:  Colors.blue,
                 //fillColor: Colors.transparent,//Colors.lightBlue[100],

               ),
             ),
           ),
           Positioned(left:10,top: 4,child: Text("Tipo del campo",style: TextStyle(fontSize: 12,color: Colors.blue),)),

           Positioned(right:40,bottom: 20,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:28,icon: Icon(Icons.check_circle_outline,color: fieldController.text.isNotEmpty?Colors.green:Colors.grey),onPressed: fieldController.text.isNotEmpty?(){
             fieldController=new TextEditingController();
             setState(() {
               phase=3;
             });
           }:null,)),

           Positioned(right:0,bottom: 20,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:28,icon: Icon(Icons.cancel_outlined,color: Colors.red),onPressed: (){
             fieldController=new TextEditingController();
             setState(() {
               phase=0;
             });
           },)),
         ],
       ),
     );
   }
      return Container();


  }

}
