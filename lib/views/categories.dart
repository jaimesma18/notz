import 'package:flutter/material.dart';
import 'package:notz/classes/category.dart';
import 'package:notz/services/db.dart';
import 'package:notz/widgets/template/boolField.dart';
import 'package:notz/widgets/template/multiField.dart';
import 'package:notz/widgets/template/stringField.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
bool loaded=false;
String selectedCategory="";
String selectedSubcategory="";
Map<String,Category>cats=new Map<String,Category>();
Map<String,Category>subs=new Map<String,Category>();
Map technical=new Map();//Este es el que se va a usar para subir al producto
Map<String,bool> enabledFields=new Map<String,bool>();
//List<Widget> allFields=[];
//List<Widget> template=[];//de los seleccionados


  @override
  void initState() {
    super.initState();

    init().whenComplete(() => print(""));


  }

  Future init()async{

   cats=await DatabaseService().getCategories(parent: null);
   if(cats.isNotEmpty) {
     selectedCategory = cats.keys.first ;
   }
   else{
     selectedCategory="";
   }

    setState(() {
      loaded = true;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(children:[
           DropdownButton<String>(value: selectedCategory,
            items: cats.keys.toList().map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (val) async{
             subs.clear();
             subs=await DatabaseService().getCategories(parent:cats[val].id);
             setState(() {
               enabledFields.clear();
               //template=[];
               technical.clear();
               selectedCategory=val;
               if(subs.isNotEmpty) {
                 selectedSubcategory = subs.keys.first ;
               }
               else{
                 selectedSubcategory="";
               }
             });
            },
          ),
          DropdownButton<String>(value: selectedSubcategory,
            items: subs.keys.toList().map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
               // template=[];
                enabledFields.clear();
                technical.clear();
                selectedSubcategory=val;

              for(var x in subs[val].template.keys){
                enabledFields[x]=true;
               // allFields.add(createFieldBoxTile(x));
                //template.add(createStringField(x));
              }
              });
             // print(subs[val].template);
            },
          ),
          RaisedButton(child:Text("Click"),onPressed:(){
            print("Valid?: ${validate()}");
            print(enabledFields);
            print(technical);
          }),
          Row(mainAxisAlignment: MainAxisAlignment.start,
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
          ),


        ]),
      ),

    );
  }

  Widget createStringField(String field,{bool mandatory,String type}){

    bool validate(String s,String type) {
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
    controller.text=technical[field]??"";

    callback(){
      if(validate(controller.text,type)) {
        technical[field] = controller.text;
      }
      else{
        if(mandatory){
          technical[field]=null;
        }
        else {
          technical.remove(field);
        }
      }
    }

    onRemove(){
      if(enabledFields.keys.contains(field)) {
        setState(() {
          enabledFields[field] = false;
        });
      }
      technical.remove(field);
    }
    return StringField(field: field,callback: callback,controller:controller,onRemove: onRemove,mandatory: mandatory??false,type: type,validate: validate,);
  }

  Widget createBoolField(String field,{bool mandatory}){

    List<bool> selected=[];
    selected.add(false);
    selected.add(false);

    callback(){
      if(selected[0]==selected[1]){
        technical.remove(field);
      }
      else {
        technical[field] = selected[0];
      }
    }

    onRemove(){
      if(enabledFields.keys.contains(field)) {
        setState(() {
          enabledFields[field] = false;
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
    if(singleChoice){
     temp=values.split('(')[1].split(";");
      }
    else{
      temp=values.split('[')[1].split(";");
    }
    for(var x in temp) {
      multiValues[x] = false;
    }


    callback(){
      List l=multiValues.keys.toList();
      if(singleChoice){
        bool found=false;
       int i=0;
       while(!found&&i<l.length){
         if(multiValues[l[i]]){
           found=true;
           technical[field]=l[i];
         }
         else{
           i++;
         }
       }
       if(!found){
         technical[field]=null;
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
          technical[field]=null;
        }
        else{
          technical[field]=temp.join(", ");
        }
      }
    }

    onRemove(){
      if(enabledFields.keys.contains(field)) {
        setState(() {
          enabledFields[field] = false;
        });
      }
      technical.remove(field);
    }

    return MultiField(field: field,callback: callback,valuesMap:multiValues,onRemove: onRemove,mandatory: mandatory,singleSelection: singleChoice,);
  }

  Widget decideWidget(String field){
    String type=subs[selectedSubcategory].template[field];
    bool mandatory=type.startsWith("*");


    if(type.endsWith("string")){
      return createStringField(field,mandatory: mandatory,type: "string");
    }
    if(type.endsWith("bool")){
      return createBoolField(field,mandatory: mandatory);
    }
    if(type.endsWith(")")){
      return createMultiField(field,type,true,mandatory: mandatory);
    }
    if(type.endsWith("]")){
      return createMultiField(field,type,false,mandatory: mandatory);
    }
    if(type.endsWith("int")){
      return createStringField(field,mandatory: mandatory,type: "int");
    }
    if(type.endsWith("double")){
      return createStringField(field,mandatory: mandatory,type:"double");
    }
    if(type.endsWith("natural")){
      return createStringField(field,mandatory: mandatory,type:"natural");
    }
    if(type.endsWith("positive")){
      return createStringField(field,mandatory: mandatory,type:"positive");
    }
    if(type.endsWith("negative")){
      return createStringField(field,mandatory: mandatory,type:"negative");
    }



    return null;
  }

  Widget buildTemplate2(){
    List l1=[];
    for(var x in enabledFields.keys.toList()){
      if(enabledFields[x]){
        l1.add(x);
      }
    }
    sortList(l1);

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
            child: decideWidget(l1[index]),
            //child: createStringField(l1[index]),
          );
        })),
    );
      }

Widget buildTemplate(){
  List l1=[];
  for(var x in enabledFields.keys.toList()){
    if(enabledFields[x]){
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
    l1=enabledFields.keys.toList();
    sortList(l1);
    /*l1.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });*/
    for(var x in l1){
      l2.add(enabledFields[x]);
    }
   return l1.length>0?SingleChildScrollView(scrollDirection: Axis.vertical,
     child: Container(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 6),
       decoration: BoxDecoration(border: Border.all(color:Colors.grey,width: 2), borderRadius: BorderRadius.all(Radius.circular(20))),
       child: ListView.builder(   scrollDirection: Axis.vertical,
           shrinkWrap: true,
           itemCount: l1.length,
           itemBuilder: (BuildContext ctxt, int index) {
             return  createFieldBoxTile(l1[index],l2[index]);
           }),
     ),
   ):Container();

  }


  Widget createFieldBoxTile(String field,bool enabled){
    bool mandatory=subs[selectedSubcategory].template[field].startsWith("*");
   if(mandatory) {
     technical[field] = null;
   }
    Color c;
    //if(enabledFields[field]){
    if(enabled||mandatory){
      c=Colors.green;
    }
    else{
      c=Colors.grey;
    }



    return Row(children: [
      IconButton(color: c,icon: Icon(Icons.check_circle_outline,), onPressed: (){
        if(!mandatory) {
          setState(() {
            enabledFields[field] = !enabledFields[field];
            if (!enabledFields[field]) {
              technical.remove(field);
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
    List l=technical.keys.toList();
    int i=0;
    while(res&&i<l.length) {
      if (technical[l[i]] == null) {
        res = false;
      }
      else{
        i++;
      }
    }
    return res;
  }


}
