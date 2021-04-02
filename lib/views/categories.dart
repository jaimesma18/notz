import 'package:flutter/material.dart';
import 'package:notz/classes/category.dart';
import 'package:notz/classes/subCategory.dart';
import 'package:notz/services/db.dart';
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
Map<String,Subcategory>subs=new Map<String,Subcategory>();
Map technical=new Map();//Este es el que se va a usar para subir al producto
Map<String,bool> enabledFields=new Map<String,bool>();
List<Widget> allFields=[];
List<Widget> template=[];//de los seleccionados
  @override
  void initState() {
    super.initState();

    init().whenComplete(() => print(""));


  }

  Future init()async{

   cats=await DatabaseService().getCategories();
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
             subs=await DatabaseService().getSubcategories(cats[val].id);
             setState(() {
               template=[];
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
                template=[];
                technical.clear();
                selectedSubcategory=val;

              for(var x in subs[val].template.keys){
                enabledFields[x]=true;
                allFields.add(createFieldBoxTile(x));
                //template.add(createStringField(x));
              }
              });
             // print(subs[val].template);
            },
          ),
          RaisedButton(child:Text("Click"),onPressed:(){
            print(enabledFields);
            //print(technical);
          }),
          Row(
            children: [
              Column(children: template,),
              Column(children: allFields,),
            ],
          ),


        ]),
      ),

    );
  }

  Widget createStringField(String field){
    String callback(String val){
      if(val.isNotEmpty) {
        technical[field] = val;
      }
      else{
        technical.remove(field);
      }
    }
    return StringField(field: field,callback: callback,);
  }

  Widget createFieldBoxTile(String field){
    Color c;
    if(enabledFields[field]){
      c=Colors.green;
    }
    else{
      c=Colors.grey;
    }
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(children: [
          IconButton(color: c,icon: Icon(Icons.check_circle_outline,), onPressed: (){
            setState(() {
              enabledFields[field]=!enabledFields[field];
            });
          }),
          Text(field)
        ],)
      ],),
    );
  }



}
