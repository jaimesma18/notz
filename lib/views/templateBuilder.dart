import 'package:flutter/material.dart';
import 'package:notz/classes/category.dart';
import 'package:notz/services/db.dart';
import 'package:notz/widgets/template/boolField.dart';
import 'package:notz/widgets/template/multiField.dart';
import 'package:notz/widgets/template/newFIeldButton.dart';
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
Map cardsData=new Map();
Map original=new Map();


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
      loaded = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Diseñador de Templates"),),

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
                        child: new Text(cats[index],style: TextStyle(color: Colors.blue[900]),)
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
                        child: new Text(subs[index],style: TextStyle(color: Colors.blue[900]))
                        ,onPressed: ()async{
                            selectedSubcategory=subs[index];
                            setState(() {
                            loadCards();
                          });


                      },),
                    );
                  }
              ),
            ),

            SizedBox(width: 20,),

          Expanded(child:buildTemplate()),



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


Map createMapValues(String field,String type){
  Map m = new Map();
  m['field'] = field;
  m['type'] = type;
  Map decoded=decode(m['type']);
  m['fieldController']=new TextEditingController(text: field);
  m['optionsController']=new TextEditingController(text: decoded['options']);
  m['mandatory']=decoded['mandatory'];
  m['selectedType']=decoded['selectedType'];
return m;
}

void loadCards(){

    cardsData.clear();
    original.clear();

  if (subCats[selectedSubcategory].template != null) {
    List l=sortList(subCats[selectedSubcategory].template.keys.toList());
    for (var x in l) {
     // Map m = new Map();
      original[x]=subCats[selectedSubcategory].template[x];
    /*  m['field'] = x;
      m['type'] = subCats[selectedSubcategory].template[x];
      Map decoded=decode(m['type']);
      m['fieldController']=new TextEditingController(text: x);
      m['optionsController']=new TextEditingController(text: decoded['options']);
      m['mandatory']=decoded['mandatory'];
      m['selectedType']=decoded['selectedType'];*/
      cardsData[x]=createMapValues(x, subCats[selectedSubcategory].template[x]);
    }

    // print(l1);
    //sortList(l1);
  }

}

Widget buildCard({dynamic data}){
    Widget widget= Container();

    if(data=='+') {
        TextEditingController controller=new TextEditingController();
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: NewFieldButton(controller:controller,callback: ()async{
          Map m=createMapValues(controller.text,"string");
         setState(() {
           cardsData[controller.text]=m;
         });
          await updateTemplate();
        },),
      );
    }
    else {

      void onDone()async{
        String encoded=encode(data);

      if(data['field']!=data['fieldController'].text){
        await DatabaseService().updateProductsTechnical(subCats[selectedSubcategory].id, 2, data['field'],type: encoded,newField: data['fieldController'].text);
        setState(() {
          cardsData.remove(data['field']);
          cardsData[data['fieldController'].text]=createMapValues(data['fieldController'].text, encoded);
        });

        await updateTemplate();
        //cardsData[data['fieldController'].text]['type']=encoded
      }
      else{
        if(data['type']!=encoded) {
          if (encoded != data['type']) {
            await DatabaseService().updateProductsTechnical(subCats[selectedSubcategory].id, 1, data['field'],type: encoded);
            setState(() {
              cardsData[data['field']] =
                  createMapValues(data['field'], encoded);
            });

            await updateTemplate();
          }
        }
      }      }

      void onDelete() async{
        await DatabaseService().updateProductsTechnical(subCats[selectedSubcategory].id, 0, data['field']);
        setState(() {
          cardsData.remove(data['field']);
        });
      }

      widget= Padding(padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
          child: new TemplateCard(values: data,onDone:onDone ,onDelete: onDelete,));//TemplateCard(fieldController:data['fieldController'],optionsController:data['optionsController'],mandatory: data['mandatory'],selectedType: data['selectedType'],values: data,onDone:onDone ,onDelete: onDelete,));
    }
    return widget;
}

Widget buildTemplate(){


      List l1 = [];
      if (cardsData != null) {
      List sorted=sortList(cardsData.keys.toList());
      l1.add("+");
        for (var x in sorted) {
          l1.add(cardsData[x]);
        }

      }

  //l1.add("+");
  return subCats[selectedSubcategory]==null?Container():

  //return cards.isEmpty?Container():
  SingleChildScrollView(scrollDirection: Axis.vertical,

    child: /*GridView.count( shrinkWrap: true,
        childAspectRatio: (1),
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,
        children: List.of(cards),)*/
        // Generate 100 widgets that display their index in the List.
       /* children: List.generate(cards.length, (int index) {
          return cards[index];
        })),*/
        GridView.builder(shrinkWrap: true,
      itemCount: l1.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
           return  buildCard(data:l1[index]);

           // return  buildCard(newCard: false,data:l1[index]);
      })
  );
}

Map decode(String type){
    Map m=new Map();
    List<bool> selectedType=List.filled(8, false);
    String options="";

    m['mandatory']=type.startsWith("*");

    if(type.endsWith("string")){
      selectedType[0]=true;
    }
    if(type.endsWith("bool")){
      selectedType[1]=true;
    }
    if(type.endsWith("]")){
      selectedType[2]=true;
      options=type.replaceAll("*", "");
      options=options.replaceAll("[", "");
      options=options.replaceAll("]", "");
      options=options.replaceAll(";", " ; ");
    }
    if(type.endsWith(")")){
      selectedType[3]=true;
      options=type.replaceAll("*", "");
      options=options.replaceAll("(", "");
      options=options.replaceAll(")", "");
      options=options.replaceAll(";", " ; ");
    }
    if(type.endsWith("double")){
      selectedType[4]=true;
    }
    if(type.endsWith("positive")){
      selectedType[5]=true;
    }
    if(type.endsWith("int")){
      selectedType[6]=true;
    }
    if(type.endsWith("natural")){
      selectedType[7]=true;
    }

    m['selectedType']=selectedType;
    m['options']=options;

    return m;
}

String encode(Map m){
  String res="";
  if(m['mandatory']){
    res="*";
  }
  if(m['selectedType'][0]){
    res=res+"string";
  }
  if(m['selectedType'][1]){
    res=res+"bool";
  }
  if(m['selectedType'][2]){
    String options=m['optionsController'].text.replaceAll(",", ";");
    options=options.replaceAll(" ", "");
    //options=options.replaceAll(";", " ; ");
    options=options.trim();
    if(options.endsWith(";")){
      options=options.substring(0,options.length-1);
    }
    m['options']=options;
    res=res+"["+options+"]";

  }
  if(m['selectedType'][3]){
    String options=m['optionsController'].text.replaceAll(",", ";");
    options=options.replaceAll(" ", "");
    //options=options.replaceAll(";", " ; ");
    options=options.trim();
    if(options.endsWith(";")){
      options=options.substring(0,options.length-1);
    }
    m['options']=options;
    res=res+"("+options+")";
  }

  if(m['selectedType'][4]){
    res=res+"double";
  }
  if(m['selectedType'][5]){
    res=res+"positive";
  }
  if(m['selectedType'][6]){
    res=res+"int";
  }
  if(m['selectedType'][7]){
    res=res+"natural";
  }
  return res;
}

Future updateTemplate()async{

    Map m=new Map();
    List l=cardsData.keys.toList();
    for(var x in l){
      m[x]=cardsData[x]['type'];
    }
    subCats[selectedSubcategory].template=m;
  await DatabaseService().updateCategory(subCats[selectedSubcategory].id,template: m,before: original);

  original.clear();
  for(var x in m.keys.toList()){
    original[x]=m[x];
  }
}

}

