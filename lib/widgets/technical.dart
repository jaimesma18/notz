import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notz/classes/category.dart';
import 'package:notz/services/db.dart';
import 'package:notz/widgets/template/boolField.dart';
import 'package:notz/widgets/template/multiField.dart';
import 'package:notz/widgets/template/newField.dart';
import 'package:notz/widgets/template/stringField.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Technical extends StatefulWidget {
  Map data;
  bool edit;
  String model;
  bool mobile;
  String category;
  Technical({this.model,this.mobile,this.edit,this.data,this.category});

  @override
  _TechnicalState createState() => _TechnicalState();
}

class _TechnicalState extends State<Technical> {
bool loaded=false;
Map technical=new Map();//Este es el que se va a usar para subir al producto
Map<String,bool> templateFields=new Map<String,bool>();
Map uploaded=new Map();
Category category;



  @override
  void initState() {
    super.initState();

    init().whenComplete(() => print("complete"));


  }

  Future init()async{

    category= await DatabaseService().getCategory(widget.category);
    templateFields.clear();
    technical.clear();

    //widget.data!=null?
    //technical = json.decode(json.encode(widget.data)):technical=new Map();
    //print(technical);

    for(var x in category.template.keys){
      templateFields[x]=true;
      technical[x]=new Map();
      technical[x]['value']=null;
      technical[x]['type']=category.template[x];
      // allFields.add(createFieldBoxTile(x));
      //template.add(createStringField(x));
    }

    for(var x in widget.data.keys.toList()){
      if(!technical.keys.contains(x)) {
        technical[x]=new Map();
      }
        technical[x]['value']=widget.data[x]['value'];
        technical[x]['type']=widget.data[x]['type'];

    }

    print(technical);


    setState(() {
      loaded = true;
    });

  }
  @override
  Widget build(BuildContext context) {

    return
      loaded?Column(children:[
        buildFieldBox(),
          buildTemplate2(),

         /* Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex:1,child: Container()),
              Expanded(flex:20,child:buildTemplate2()), //Column(children: template,)),
              Expanded(flex:2,child: Container()),
              Expanded(flex:6,child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 4),
                child: buildFieldBox(),
              )),
              Expanded(flex:1,child: Container()),
            ],
          ),*/

          RaisedButton(child:Text("Click"),onPressed:()async{
            if(validate()){
              List l=technical.keys.toList();
              for(var x in l){
                if(technical[x]['value']==null){
                  technical.remove(x);
                }
              }
             await DatabaseService().updateProduct(widget.model,technicals: technical);

            }
            //print("Valid?: ${validate()}");
            //print(templateFields);
            //print(technical);
          }),

        ]):Container(height:400,child: Center(child: SpinKitCircle(color: Colors.blue,)));

  }

  Widget createStringField(String field,{bool mandatory,String type}){


    bool validate(String s,String type) {

      if(s==""){
        return false;
      }
      if (s == null) {
        return false;
      }
      if(type=='string'){
        return s!="";
      }
      if(type=='double') {
        return double.tryParse(s) != null;
      }
      if(type=='int'){
        return int.tryParse(s) != null;
      }
      if(type=='natural'){
        int x=int.tryParse(s);
        if(x!=null&&x>=0){
          return true;
        }
      }
      if(type=='positive'){
        int x=int.tryParse(s);
        if(x!=null&&x>0){
          return true;
        }
      }
      if(type=='negative'){
        int x=int.tryParse(s);
        if(x!=null&&x<0){
          return true;
        }
      }
      return false;
    }


    TextEditingController controller=new TextEditingController();
    if(technical[field]['value']==null){
      controller.text="";
    }
    else{
      controller.text="${technical[field]['value']}";
    }

    dynamic parse(String s){
      if(s==""){
        return null;
      }
      if(s==null){
        return null;
      }
      if(type=='string'){
        return s;
      }
      if(type=='double'){
        return double.parse(s);
      }
      return int.parse(s);
    }

    callback(){

      if(validate(controller.text,type)) {
        technical[field]['value'] = parse(controller.text);
      }
     else {
        technical[field]['value'] = controller.text;
      }
       // if(mandatory){
         // technical[field]['value']=null;
       // }
       // else {
       //   technical.remove(field);
      //  }
     // }
    }


    onRemove(){
      if(templateFields.keys.contains(field)) {
        setState(() {
          templateFields[field] = false;
        });
      }
      setState(() {
        technical.remove(field);
      });

    }



    return StringField(field: field,callback: callback,controller:controller,onRemove: onRemove,mandatory: mandatory??false,type: type,validate: validate,);
  }

  Widget createBoolField(String field,{bool mandatory}){

    List<bool> selected=[];
    selected.add(false);
    selected.add(false);

    if(technical[field]['value']!=null){
      if(technical[field]['value']){
        selected[0]=true;
      }
      else{
        selected[1]=true;
      }
    }

    callback(){
      if(selected[0]==selected[1]){
        technical[field]['value']=null;
        //technical.remove(field);
      }
      else {
        technical[field]['value'] = selected[0];
      }
    }

    onRemove(){
      if(templateFields.keys.contains(field)) {
        setState(() {
          templateFields[field] = false;
        });
      }
      technical.remove(field);
    }

    return BoolField(field: field,callback: callback,selected:selected,onRemove: onRemove,mandatory: mandatory,);
  }

  Widget createMultiField(String field,String values,bool singleChoice,{bool mandatory}){

    Map<String,bool> multiValues=new Map<String,bool>();
    values=values.substring(0,values.length-1);
    List temp=[];
    List selectedValues=[];
    if(singleChoice){
     temp=values.split('(')[1].split(";");
      }
    else{
      temp=values.split('[')[1].split(";");
    }

    for(var x in temp) {
      multiValues[x] = false;
    }

    String actual=technical[field]['value'];
    if(actual!=null){
      selectedValues=actual.split(';');
      for(var x in selectedValues){
        if(multiValues.containsKey(x)){
          multiValues[x]=true;
        }
      }
    }



    callback(){
      List l=multiValues.keys.toList();
      if(singleChoice){
        bool found=false;
       int i=0;
       while(!found&&i<l.length){
         if(multiValues[l[i]]){
           found=true;
           technical[field]['value']=l[i];
         }
         else{
           i++;
         }
       }
       if(!found){
         technical[field]['value']=null;
       }
      }
      else{
        List temp=[];
        for(var x in l){
          if(multiValues[x]){
           temp.add(x);
          }
          else{
            temp.remove(x);
          }

        }
        if(temp.isEmpty){
          technical[field]['value']=null;
        }
        else{
          technical[field]['value']=temp.join(";");
        }
      }
    }

    onRemove(){
      if(templateFields.keys.contains(field)) {
        setState(() {
          templateFields[field] = false;
        });
      }
      technical.remove(field);
    }

    return MultiField(field: field,callback: callback,valuesMap:multiValues,onRemove: onRemove,mandatory: mandatory,singleSelection: singleChoice,);
  }

  Widget decideWidget(String field){
    String type="";

    if(field=="+"){
      Map values=new Map();

       void callback(){
        setState(() {
          technical[values['field']]=new Map();
          technical[values['field']]['value']=null;
          technical[values['field']]['type']=values['type'];
        });
      }
        return NewField(onAccept: callback,values: values,);
    }
    else {

      type = technical[field]['type'];
      bool mandatory = type.startsWith("*");




      if (type.endsWith("string")) {
        return createStringField(field, mandatory: mandatory, type: "string");
      }

      if (type.endsWith("bool")) {
        return createBoolField(field, mandatory: mandatory);
      }

      if (type.endsWith(")")) {
        return createMultiField(field, type, true, mandatory: mandatory);
      }

      if (type.endsWith("]")) {
        return createMultiField(field, type, false, mandatory: mandatory);
      }

      if (type.endsWith("int")) {
        return createStringField(field, mandatory: mandatory, type: "int");
      }

      if (type.endsWith("double")) {
        return createStringField(field, mandatory: mandatory, type: "double");
      }

      if (type.endsWith("natural")) {
        return createStringField(field, mandatory: mandatory, type: "natural");
      }

      if (type.endsWith("positive")) {
        return createStringField(field, mandatory: mandatory, type: "positive");
      }

      if (type.endsWith("negative")) {
        return createStringField(field, mandatory: mandatory, type: "negative");
      }


    }



    return null;
  }

  Widget buildTemplate2(){
    List l1=[];
   // l1.add("Watts");
    for(var x in technical.keys.toList()){
        l1.add(x);
    }
    sortList(l1);
    l1.add("+");

    return SingleChildScrollView(scrollDirection: Axis.vertical,
      child: GridView.count( shrinkWrap: true,
          childAspectRatio: (3),
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(l1.length, (int index) {
          return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: decideWidget(l1[index]),
            //child: createStringField(l1[index]),
          );
        })),
    );
      }

Widget buildTemplate(){
  List l1=[];
  for(var x in templateFields.keys.toList()){
    if(templateFields[x]){
      l1.add(x);
    }
  }
  sortList(l1);

  return SingleChildScrollView(
    child: ListView.builder(   scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: l1.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return  decideWidget(l1[index]);
        }),
  );

}

Widget buildFieldBox(){
  List l1=[];
  List l2=[];
  l1=templateFields.keys.toList();
  sortList(l1);
  for(var x in l1){
    l2.add(templateFields[x]);
  }
  return l1.length>0?SingleChildScrollView(scrollDirection: Axis.vertical,
    child: GridView.count( shrinkWrap: true,
        childAspectRatio: (5),

        crossAxisCount: 3,
        children: List.generate(l1.length, (int index) {
          return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child:createFieldBoxTile(l1[index],l2[index]),
          );
        })),
  ):Container();
}



  Widget createFieldBoxTile(String field,bool enabled){
    bool mandatory=category.template[field].startsWith("*");
  // if(mandatory) {
  //   technical[field] = null;
  // }
    Color c;
    //if(enabledFields[field]){
    if(enabled||mandatory){
      c=Colors.green;
    }
    else{
      c=Colors.grey;
    }



    return Row(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      IconButton(color: c,icon: Icon(Icons.check_circle_outline,), onPressed: (){
        if(!mandatory) {
          setState(() {
            templateFields[field] = !templateFields[field];
            if (!templateFields[field]) {
              technical.remove(field);
            }
            else{
              technical[field]=new Map();
              technical[field]['value']=null;
              technical[field]['type']=category.template[field];
            }
            FocusScope.of(context).requestFocus(FocusNode());
          });
        }
      }),
      Text(field)
    ],);
  }

  void sortList(List l,{bool desc}) {
    if (desc == null || desc == false) {
      l.sort((a, b) {
        return a.toLowerCase().compareTo(b.toLowerCase());
      });
    }
    else {
      l.sort((a, b) {
        return b.toLowerCase().compareTo(a.toLowerCase());
      });
    }
  }

  bool validate(){
    bool res=true;
    List temp=technical.keys.toList();
    List l=[];
    for(var x in temp){
      if((technical[x]['type']).startsWith('*')){
        l.add(x);
      }
    }
    int i=0;
    while(res&&i<l.length) {
      if (technical[l[i]]['value'] == null) {
        res = false;
      }
      else{
        i++;
      }
    }
    for(var x in technical.keys.toList()){
     /* print("");
      print(x);
      print(technical[x]['value']);
      print(technical[x]['type']);
      print(checkType(technical[x]['value'], technical[x]['type']));*/

      res=res&&checkType(technical[x]['value'], technical[x]['type']);
    }
    print(res);
    return res;
  }


bool checkType(dynamic s,String type) {

    if(type.startsWith("*")) {
      type = type.split("*")[1];
    }
  if(s==""){
    return false;
  }
  if (s == null) {
    return true;
  }
  if(type.startsWith('[')||type.startsWith('(')){
    return true;
  }
  if(type=='bool'){
    return s==true||s==false;
  }
  s='$s';
  if(type=='string'){
    return s!="";
  }
  if(type=='double') {
    return double.tryParse(s) != null;
  }
  if(type=='int'){
    return int.tryParse(s) != null;
  }
  if(type=='natural'){
    int x=int.tryParse(s);
    if(x!=null&&x>=0){
      return true;
    }
  }
  if(type=='positive'){
    int x=int.tryParse(s);
    if(x!=null&&x>0){
      return true;
    }
  }
  if(type=='negative'){
    int x=int.tryParse(s);
    if(x!=null&&x<0){
      return true;
    }
  }
  return false;
}



}
