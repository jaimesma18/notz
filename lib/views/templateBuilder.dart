import 'package:flutter/material.dart';
import 'package:notz/classes/category.dart';
import 'package:notz/services/db.dart';
import 'package:notz/widgets/template/boolField.dart';
import 'package:notz/widgets/template/multiField.dart';
import 'package:notz/widgets/template/stringField.dart';
import 'package:notz/widgets/template/templateCard.dart';

class TemplateBuilder extends StatefulWidget {
  @override
  _TemplateBuilderState createState() => _TemplateBuilderState();
}

class _TemplateBuilderState extends State<TemplateBuilder> {
bool loaded=false;
String selectedCategory="";
String selectedSubcategory="";
Map<String,Category>categories=new Map<String,Category>();
Map<String,Category>subCats=new Map<String,Category>();
List cats=[];
List subs=[];


  @override
  void initState() {
    super.initState();

    init().whenComplete(() => print(""));


  }

  Future init()async{

   categories=await DatabaseService().getCategories(parent: null);
   cats=sortList(categories.keys.toList());
  /* if(cats.isNotEmpty) {
     selectedCategory = cats.keys.first ;
   }
   else{
     selectedCategory="";
   }*/

    setState(() {
      loaded = true;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30,30,30,30),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Container(width: 200,height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                    color: Colors.blue,
                    width: 4,
                ),
              ),
              child: ListView.builder
                (scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: cats.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Card(
                     /* shape:RoundedRectangleBorder(
                        side: new BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0)),*/
                      child: FlatButton(color: cats[index]==selectedCategory?Colors.blue[400]:Colors.blue[100],
                        hoverColor: Colors.blue[400],
                        child: new Text(cats[index])
                      ,onPressed: ()async{
                        subCats=await DatabaseService().getCategories(parent: categories[cats[index]].id);
                        subs=sortList(subCats.keys.toList());
                       setState(() {
                         selectedSubcategory="";
                         selectedCategory=cats[index];
                       });
                        },),
                    );
                  }
              ),
            ),

            SizedBox(width: 20,),

            Container(width: 200,height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue,
                  width: 4,
                ),
              ),
              child: ListView.builder
                (scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: subs.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Card(
                      child: FlatButton(
                        color: subs[index]==selectedSubcategory?Colors.blue[400]:Colors.blue[100],
                        hoverColor: Colors.blue[400],
                        child: new Text(subs[index])
                        ,onPressed: ()async{

                          setState(() {
                            selectedSubcategory=subs[index];
                          });

                      },),
                    );
                  }
              ),
            ),

            SizedBox(width: 20,),

          Expanded(child: buildTemplate()),



          ],),
        )
      ),

    );
  }


List sortList(List l,{bool desc}) {
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
  return l;
}


Widget buildTemplate(){
  List l1=[];

  if(subCats[selectedSubcategory]!=null) {
    for (var x in sortList(
        subCats[selectedSubcategory].template.keys.toList())) {
      Map m = new Map();
      m['field'] = x;
      m['type'] = subCats[selectedSubcategory].template[x];
      l1.add(m);
    }
   // print(l1);
    //sortList(l1);
  }
  //l1.add("+");

  return subCats[selectedSubcategory]==null?Container():SingleChildScrollView(scrollDirection: Axis.vertical,
    child: GridView.count( shrinkWrap: true,
        childAspectRatio: (1),
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(l1.length, (int index) {
          return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: TemplateCard(values:l1[index]),
            //child: createStringField(l1[index]),
          );
        })),
  );
}
}
