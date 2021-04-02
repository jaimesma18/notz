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
//List<Widget> allFields=[];
//List<Widget> template=[];//de los seleccionados


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
            print(enabledFields);
            print(technical);
          }),
          Row(
            children: [
              Expanded(flex:10,child:buildTemplate2()), //Column(children: template,)),
              Expanded(flex:6,child: buildFieldBox()),
            ],
          ),


        ]),
      ),

    );
  }

  Widget createStringField(String field){

    TextEditingController controller=new TextEditingController();
    controller.text=technical[field]??"";

    callback(){

      if(controller.text.isNotEmpty) {
        technical[field] = controller.text;
      }
      else{
        technical.remove(field);
      }



    }
    return StringField(field: field,callback: callback,controller:controller,);
  }


  Widget buildTemplate2(){
    List l1=[];
    for(var x in enabledFields.keys.toList()){
      if(enabledFields[x]){
        l1.add(x);
      }
    }

    return GridView.count( shrinkWrap: true,
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 3,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(l1.length, (int index) {
        return  createStringField(l1[index]);
      }));
      }

Widget buildTemplate(){
  List l1=[];
  for(var x in enabledFields.keys.toList()){
    if(enabledFields[x]){
      l1.add(x);
    }
  }

  return ListView.builder(   scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: l1.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return  createStringField(l1[index]);
      });

}

  Widget buildFieldBox(){
    List l1=[];
    List l2=[];
    l1=enabledFields.keys.toList();
    for(var x in l1){
      l2.add(enabledFields[x]);
    }
   return ListView.builder(   scrollDirection: Axis.vertical,
       shrinkWrap: true,
       itemCount: l1.length,
       itemBuilder: (BuildContext ctxt, int index) {
         return  createFieldBoxTile(l1[index],l2[index]);
       });

  }


  Widget createFieldBoxTile(String field,bool enabled){
    Color c;
    //if(enabledFields[field]){
    if(enabled){
      c=Colors.green;
    }
    else{
      c=Colors.grey;
    }
    return Row(children: [
      IconButton(color: c,icon: Icon(Icons.check_circle_outline,), onPressed: (){
        setState(() {
          enabledFields[field]=!enabledFields[field];
          if(!enabledFields[field]){
            technical.remove(field);
          }
          FocusScope.of(context).requestFocus(FocusNode());
        });
      }),
      Text(field)
    ],);
  }



}
