import 'dart:math';
import 'package:multi_select_flutter/multi_select_flutter.dart' as multiSelect;
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
//import 'package:universal_html/html.dart';

class TemplateCard extends StatefulWidget {
 // final TextEditingController fieldController;
 // final TextEditingController optionsController;
 // bool mandatory;
 // List<bool> selectedType;
 final Map values;
 final Function onDelete;
 final Function onDone;
 TemplateCard({this.values,this.onDelete,this.onDone});
  //TemplateCard({this.fieldController,this.optionsController,this.selectedType,this.mandatory,this.values,this.onDelete,this.onDone});
  @override
  _TemplateCardState createState() => _TemplateCardState();
}

class _TemplateCardState extends State<TemplateCard> {

  //bool mandatory=false;
  List types=[];
  //List selectedType=[];
  bool editable=false;
  //String options="";
  //TextEditingController fieldController=new TextEditingController();
  //TextEditingController optionsController=new TextEditingController();


  @override
  void initState() {


    types.add('Tx');
    types.add('ToF');
    types.add('[..]');
    types.add('(..)');
    types.add('1.0');
    types.add('1..N');
    types.add('-N..N');
    types.add('0..N');




   /* setState(() {
     // initSelectedTypes();
    });*/
   /* if(widget.values['type'].startsWith('*')){
      mandatory=true;
    }*/
   // determineType();




    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(width: 350,height: 350,
      child: Card(elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: Colors.blue,width: 2) ),
        child: Container(width: 350,
          child: Stack(children: [viewWidget(),
            editable?Positioned(left: 150,
            child: IconButton(icon: Icon(Icons.delete,color: Colors.red,),onPressed: (){

                setState(() {
                  editable=false;
                });
                widget.onDelete();

            },),):Container(),
            Positioned(left: 180,
                child: IconButton(icon: Icon(Icons.edit,color:editable?Colors.blue:Colors.grey), onPressed: (){
                  setState(() {

    if(widget.values['fieldController'].text!=""){
    if(editable){
    widget.onDone();
    }
    editable=!editable;
    }
                  });
                }))

          ]),
        ),
      ),
    );
   // );
  }

  Widget viewWidget(){
    return Column(
        children: [
          SizedBox(height: 10,),
          Expanded(flex:2,child: editable?
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 50, 0),
                child: TextField(decoration: new InputDecoration.collapsed(
                    hintText: 'Nombre del Campo'
                ),
                  controller: widget.values['fieldController'],style: TextStyle(fontSize: 14,color: Colors.blue),),
              )
              :Text(widget.values['fieldController'].text,style: TextStyle(color: Colors.blue),)),
          Divider(color: Colors.blue,thickness: 2,),
          Expanded(flex:2,child:
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1,child: Container(),),
            Expanded(flex:2,
              child: Theme(
                child: Checkbox(value: widget.values['mandatory'],
                  activeColor: Colors.blue[300],
                  onChanged:editable? (val){

                  setState(() {
                    widget.values['mandatory']=val;
                  });
                  }:null,),
                data: ThemeData(
                  primarySwatch: Colors.blue,
                  unselectedWidgetColor: Colors.blue, // Your color
                ),
              ),
            ),
            Expanded(flex:1,child: Container()),
              Expanded(flex:5,child: Text("Obligatorio",style: TextStyle(color: Colors.blue))),
              Expanded(flex: 1,child: Container(),),
          ],)),
          Divider(color: Colors.blue,thickness: 2,),

          Expanded(flex: 11,child:

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: toggleButtons(),
            )
              ),
          Divider(color: Colors.blue,thickness: 2,),
          widget.values['selectedType'][2]||widget.values['selectedType'][3]?
          Expanded(flex: 3,
            child:editable?Padding(
            padding: const EdgeInsets.symmetric(horizontal:6.0),
            child: TextField(decoration: new InputDecoration.collapsed(
            hintText: 'Opciones: (separar con ";")'
            ),
            controller: widget.values['optionsController'],style: TextStyle(fontSize: 14,color: Colors.blue),),
            ):
            SingleChildScrollView(scrollDirection:Axis.horizontal,child:
            Container(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: Text(widget.values['optionsController'].text,style: TextStyle(color: Colors.blue),),
            ))),
          ):Expanded(flex:3,child: Container()),


        ]  );
  }

  void initSelectedTypes(){

    widget.values['selectedType']=[];
    for(int i=0;i<types.length;i++){
      widget.values['selectedType'].add(false);
    }
  }
  Widget toggleButtons () {
    var counter = 0;

    return GridView.count(
        crossAxisCount: 4,
        children: types.map((e) => Text(e)).map((widgets) {
          final index = ++counter - 1;

          return ToggleButtons(splashColor: Colors.blue[100],
            color: Colors.blue,
            borderWidth: 2,
            //borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.blue,
            disabledColor: Colors.blue[100],
            borderColor: Colors.blue[100],
            selectedBorderColor: Colors.blue,
            isSelected: [widget.values['selectedType'][index]],
            onPressed: editable?(val) {

              setState(() {
                initSelectedTypes();
                widget.values['selectedType'][index]=true;
              });
            }:(val){},
            children: [widgets],
          );
        }).toList());
  }

  /*void determineType(){
    String val=widget.values['type'];

    if(val.endsWith("string")){
      selectedType[0]=true;
    }
    if(val.endsWith("bool")){
      selectedType[1]=true;
    }
    if(val.endsWith("]")){
      selectedType[2]=true;
      options=val.replaceAll("*", "");
      options=options.replaceAll("[", "");
      options=options.replaceAll("]", "");
      options=options.replaceAll(";", " ; ");
    }
    if(val.endsWith(")")){
      selectedType[3]=true;
      options=val.replaceAll("*", "");
      options=options.replaceAll("(", "");
      options=options.replaceAll(")", "");
      options=options.replaceAll(";", " ; ");
    }
    if(val.endsWith("double")){
      selectedType[4]=true;
    }
    if(val.endsWith("positive")){
      selectedType[5]=true;
    }
    if(val.endsWith("int")){
      selectedType[6]=true;
    }
    if(val.endsWith("natural")){
      selectedType[7]=true;
    }
  }*/

 /* String buildType(){
    String res="";
    if(mandatory){
      res="*";
    }
    if(selectedType[0]){
      res=res+"string";
    }
    if(selectedType[1]){
      res=res+"bool";
    }
    if(selectedType[2]){
      res=res+"[${widget.optionsController.text.replaceAll(" ", "")}";
      res=res.replaceAll(",", ";");
      if(res.endsWith(";")){
        res=res.substring(0,res.length-1);
      }
      res=res+"]";
    }
    if(selectedType[3]){
      res=res+"(${widget.optionsController.text.replaceAll(" ", "")}";
      res=res.replaceAll(",", ";");
      if(res.endsWith(";")){
        res=res.substring(0,res.length-1);
      }
      res=res+")";
    }
    if(selectedType[4]){
      res=res+"double";
    }
    if(selectedType[5]){
      res=res+"positive";
    }
    if(selectedType[6]){
      res=res+"int";
    }
    if(selectedType[7]){
      res=res+"natural";
    }
    return res;
  }*/

}
