import 'dart:math';
import 'package:multi_select_flutter/multi_select_flutter.dart' as multiSelect;
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:universal_html/html.dart';

class TemplateCard extends StatefulWidget {

  Map values;

  TemplateCard({this.values});
  @override
  _TemplateCardState createState() => _TemplateCardState();
}

class _TemplateCardState extends State<TemplateCard> {

  bool mandatory=false;
  List types=[];
  List selectedType=[];


  @override
  void initState() {
    super.initState();

    types.add('Tx');
    types.add('ToF');
    types.add('[..]');
    types.add('(..)');
    types.add('1.0');
    types.add('1..N');
    types.add('-N..N');
    types.add('0..N');

    initSelectedTypes();

  }



  @override
  Widget build(BuildContext context) {
    return Container(width: 300,height: 300,
      child: Card(elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: Colors.blue,width: 2) ),
        child: Container(width: 300,
          child: viewWidget(),
        ),
      ),
    );
   // );
  }

  Widget viewWidget(){
    return Column(
        children: [
          SizedBox(height: 10,),
          Expanded(flex:2,child: Text(widget.values['field'],style: TextStyle(color: Colors.blue),)),
          Divider(color: Colors.blue,thickness: 2,),
          Expanded(flex:2,child:
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1,child: Container(),),
            Expanded(flex:2,
              child: Theme(
                child: Checkbox(value: mandatory,
                  activeColor: Colors.blue[300],
                  onChanged: (val){
                  setState(() {
                    mandatory=val;
                  });
                  },),
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

          Expanded(flex: 8,child:

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: toggleButtons(),
            )

              ),


        ]  );
  }

  void initSelectedTypes(){
    selectedType=[];
    for(int i=0;i<types.length;i++){
      selectedType.add(false);
    }
  }
  Widget toggleButtons () {
    var counter = 0;

    return GridView.count(
        crossAxisCount: 4,
        children: types.map((e) => Text(e)).map((widget) {
          final index = ++counter - 1;

          return ToggleButtons(
            color: Colors.blue[100],
            selectedColor: Colors.red,
            isSelected: [selectedType[index]],
            onPressed: (val) {
              setState(() {
                initSelectedTypes();
                selectedType[index]=true;
              });
            },
            children: [widget],
          );
        }).toList());
  }
}
