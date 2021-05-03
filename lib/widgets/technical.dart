import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notz/classes/category.dart';
import 'package:notz/services/db.dart';
import 'package:notz/widgets/template/boolField.dart';
import 'package:notz/widgets/template/multiField.dart';
import 'package:notz/widgets/template/newField.dart';
import 'package:notz/widgets/template/saveCancel.dart';
import 'package:notz/widgets/template/stringField.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:notz/widgets/template/viewWidget.dart';


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
bool editLoaded=false;
Map technical=new Map();//Este es el que se va a usar para subir al producto
Map<String,bool> templateFields=new Map<String,bool>();
Map uploaded=new Map();
Category category;
bool editing=false;
bool hasCategory=false;
Map data=new Map();



  @override
  void initState() {
    super.initState();

   /* if(widget.category!=null) {
      initEdit().whenComplete(() => print("complete"));
      hasCategory=true;
    }*/

    widget.data!=null?
    data = json.decode(json.encode(widget.data)):data=new Map();

  }


  Future initEdit()async{

    if(!editLoaded) {
      category = await DatabaseService().getCategory(widget.category);
    }
    templateFields.clear();
    technical.clear();

    //widget.data!=null?
    //technical = json.decode(json.encode(widget.data)):technical=new Map();

    for(var x in category.template.keys){
      templateFields[x]=false;
      //technical[x]=new Map();
      //technical[x]['value']=null;
      //technical[x]['type']=category.template[x];
      if(category.template[x].startsWith("*")&&!data.keys.contains(x)){
        templateFields[x]=true;
        technical[x]=new Map();
        technical[x]['value']=null;
        technical[x]['type']=category.template[x];
      }
      // allFields.add(createFieldBoxTile(x));
      //template.add(createStringField(x));
    }

    for(var x in data.keys.toList()){
      if(category.template.keys.contains(x)){
        templateFields[x]=true;
      }
    /*  if(!technical.keys.contains(x)) {
        technical[x]=new Map();
      }
      else{
        templateFields[x]=true;
      }*/
        technical[x]=new Map();
        technical[x]['value']=data[x]['value'];
        technical[x]['type']=data[x]['type'];

    }



    setState(() {
      editLoaded = true;
    });

  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        !editing?viewWidget():
        editingWidget()

      ],
    );


  }



  Widget viewWidget(){
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    FlatButton.icon(icon:Icon(Icons.edit,color:Colors.blue),label: Text("Editar",style: TextStyle(color: Colors.blue,),),onPressed: (){
      if(widget.category!=null) {
        initEdit().whenComplete(() => print(""));
        hasCategory=true;
      }
      setState(() {
        editing=true;
      });
    }
    ),
        buildViewBox(),



      ],
    );
  }

  Widget editingWidget(){

    if(hasCategory) {
      if(editLoaded){
      return Column(children: [

        Padding(
          padding: const EdgeInsets.fromLTRB(12, 15, 0, 15),
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SaveCancel(save: true, callback: () async{
                if (validate()) {
                  List l = technical.keys.toList();
                  for (var x in l) {
                    if (technical[x]['value'] == null) {
                      technical.remove(x);
                    }
                    else{
                      technical[x]['exists']=true;
                    }
                  }
                  await DatabaseService().updateProduct(
                      widget.model, technicals: technical);
                  technical!=null?
                  data = json.decode(json.encode(technical)):data=new Map();
                  setState(() {
                    editing = false;
                  });
                }

              },),
              SizedBox(width: 20,),
              SaveCancel(save: false, callback: () {
                setState(() {
                  editing = false;
                });
              },),
            ],),
        ),

        buildFieldBox(),
        buildTemplate2(),

      ]);}
      else{
        return Container(height:400,child: Center(child: SpinKitCircle(color: Colors.blue,)));
      }
    }
    else{
      return Text("No hay categoria, reportar");
    }
  }

  Widget createStringField(String field,{bool mandatory,String type}){

    String tooltip;


    if(type=='string'){
      tooltip="Texto abierto";
    }
    if(type=='double'){
      tooltip="Número positivo o negativo, entero o decimal";
    }
    if(type=='int'){
      tooltip="Número entero positivo o negativo";
    }
    if(type=='natural'){
      tooltip="Cero o número positivo";
    }
    if(type=='positive'){
      tooltip="Número positivo";
    }
    if(type=='negative'){
      tooltip="Número negativo";
    }

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
        if(controller.text!="") {
          technical[field]['value'] = controller.text;
        }
        else{
          technical[field]['value']=null;
        }
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



    return StringField(field: field,callback: callback,controller:controller,onRemove: onRemove,mandatory: mandatory??false,type: type,validate: validate,tooltip: tooltip,);
  }

  Widget createBoolField(String field,{bool mandatory}){

    List<bool> selected=[];
    selected.add(false);
    selected.add(false);

    if(technical[field]['value']!=null&& technical[field]['value'] is bool){
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
      setState(() {
        technical.remove(field);
      });

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
    String actual;
    if(technical[field]['value'] is String)
      actual =technical[field]['value'];

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
      setState(() {
        technical.remove(field);
      });
    }

    bool validate(){


      int cont=0;

      if(singleChoice){
        for(var x in multiValues.values){
          if(x){
            cont++;
          }
        }
        if(cont>1){
         return false;
        }
      }

      if(!(technical[field]['value'] is String)){
        return false;
      }
      if(technical[field]['value']!=null) {
        for (var x in technical[field]['value'].split(";")) {
          if (!multiValues.keys.contains(x)) {
            return false;
          }
        }
      }


      return true;

    }

    return MultiField(field: field,callback: callback,valuesMap:multiValues,onRemove: onRemove,mandatory: mandatory,singleSelection: singleChoice,validate: validate,);
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

  Widget createSaveCancelButtons(){

    List<bool> l1=[];
    l1.add(true);
    l1.add(false);

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
              child: SaveCancel(save: l1[index],),
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

  Widget buildViewBox(){
    List temp=[];
    List l1=[];
    temp=data.keys.toList();
    sortList(temp);
    for(var x in temp){
        l1.add(x);


    }
    int determineStatus(dynamic s,String type){

      int res=1;
        if(s==null){
          res=-1;
        }
        else{
          if(!checkType(s,type)){
            res=0;
          }
        }
        return res;
    }
    return SingleChildScrollView(scrollDirection: Axis.vertical,
      child: GridView.count( shrinkWrap: true,
          childAspectRatio: (3),
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 3,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(l1.length, (int index) {
            return  Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: ViewWidget(field: l1[index],value: data[l1[index]]['value'],valid: determineStatus(data[l1[index]]['value'], data[l1[index]]['type']),)
              //child: createStringField(l1[index]),
            );
          })),
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
            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
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
      FittedBox(  fit: BoxFit.fitWidth,
          child: Text(field))
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
      res=res&&checkType(technical[x]['value'], technical[x]['type']);
    }
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
  if(type.startsWith("(")){

    if(!(s is String)){
      return false;
    }
    if(s.contains(";")){

      return false;
    }
    else{
      if(s!=""){
        List val = s.split(";");
        String st = type.substring(1, type.length - 1);
        List ty = st.split(";");
        for (var x in val) {
          if (!ty.contains(x)) {
            return false;
          }
        }
      }
      return true;
    }

  }
  if(type.startsWith('[')) {
    if(!(s is String)){
      return false;
    }
    if(s!=""){
    List val = s.split(";");
    String st = type.substring(1, type.length - 1);
    List ty = st.split(";");
    for (var x in val) {
      if (!ty.contains(x)) {
        return false;
      }
    }
  }
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
