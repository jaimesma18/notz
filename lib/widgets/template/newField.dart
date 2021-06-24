import 'package:flutter/material.dart';
//import 'package:universal_html/html.dart';


class NewField extends StatefulWidget {

  //bool mandatory;
  Function onAccept;
  Map values;
  //Function onRemove;
  //Function validate;
  NewField({this.onAccept,this.values});
  @override
  _NewFieldState createState() => _NewFieldState();
}

class _NewFieldState extends State<NewField> {
  TextEditingController fieldController=new TextEditingController();
  int phase=0;
  //String type="";
  List<bool>selected=[];
  int currentSelected=-1;

  @override
  void initState() {
    selected.add(false);
    selected.add(false);
    selected.add(false);
    selected.add(false);
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return wrapCard();
   // );
  }

  Widget wrapCard(){
    return Container(width: 200,height: 60,
      child: Card(elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: Colors.blue,width: 2) ),
        child: Container(width: 240,
          child:  createCard(),
        ),
      ),
    );
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

           Positioned(right:40,bottom: 17,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:28,icon: Icon(Icons.check_circle_outline,color: fieldController.text.isNotEmpty?Colors.green:Colors.grey),onPressed: fieldController.text.isNotEmpty?(){
             setState(() {
               phase=2;
             });
           }:null,)),

           Positioned(right:0,bottom: 17,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:28,icon: Icon(Icons.cancel_outlined,color: Colors.red),onPressed: (){
             fieldController=new TextEditingController();
             currentSelected=-1;
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
                 Text("1.0"),
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

                 if(index==0){
                   //widget.type='string';
                   widget.values['type']='string';
                 }
                 if(index==1){
                   //widget.type="positive";
                   widget.values['type']='positive';
                 }
                 if(index==2){
                   //widget.type="double";
                   widget.values['type']='double';
                 }
                 if(index==3){
                   //widget.type='bool';
                   widget.values['type']='bool';
                 }

                   setState(() {
                     currentSelected=index;
                    for(int i=0;i<selected.length;i++){
                      selected[i]=false;
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

           Positioned(right:40,bottom: 17,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:28,icon: Icon(Icons.check_circle_outline,color: currentSelected>=0?Colors.green:Colors.grey),onPressed: currentSelected>=0?(){
             setState(() {
               phase=0;
               widget.values['field']=  fieldController.text;
             });
             widget.onAccept();
           }:null,)),

           Positioned(right:0,bottom: 17,child: IconButton(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),iconSize:28,icon: Icon(Icons.cancel_outlined,color: Colors.red),onPressed: (){
             fieldController=new TextEditingController();
             widget.values=new Map();
             //widget.type="";
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
