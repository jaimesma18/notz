import 'package:flutter/material.dart';

class NewTemplateButton extends StatefulWidget {
  Function callback;
  Function onCanceled;
  Function validate;
  final Map values;
  //TextEditingController controller;
  NewTemplateButton({this.values,this.callback,this.onCanceled,this.validate});
  @override
  _NewTemplateButtonState createState() => _NewTemplateButtonState();
}

class _NewTemplateButtonState extends State<NewTemplateButton> {
  bool initPhase=true;
  List types=[];
  @override
  initState(){
    types.add('Tx');
    types.add('ToF');
    types.add('[..]');
    types.add('(..)');
    types.add('1.0');
    types.add('1..N');
    types.add('-N..N');
    types.add('0..N');

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return getCard();
  }

  Widget getCard(){

    if(initPhase){
     return Container(width: 350,height: 350,
          child: Card(elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: Colors.blue,width: 2) ),
            child: SizedBox.expand(child:
            Container(
              child: SizedBox.expand(
                child: TextButton(child:
                // Text("+",style: TextStyle(fontSize: 128,color: Colors.blue),),
                Icon(Icons.add,size: 96,color: Colors.blue,),
                  onPressed: (){
                   setState(() {
                     initPhase=false;
                   });
                  },),
              ),
            ),),
          ));
    }
    else{
      return Container(width: 350,height: 350,
        child: Card(elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: Colors.blue,width: 2) ),
          child: Container(width: 350,
            child: Stack(children: [
              viewWidget(),
                Positioned(left: 150,
                child: IconButton(icon: Icon(Icons.cancel_outlined,color: Colors.red,),onPressed: (){

                  widget.onCanceled();
               setState(() {
                 initPhase=true;
               });


                },),),
              Positioned(left: 180,
                  child: IconButton(icon: Icon(Icons.check_circle_outline,color:Colors.green), onPressed: (){
                    if(widget.validate()) {
                    setState(() {
                        widget.callback();
                        initPhase = true;
                        widget.onCanceled();

                    });}
                  }))

            ]),
          ),
        ),
      );
    }
  }



  Widget viewWidget(){
    return Column(
        children: [
          SizedBox(height: 10,),
          Expanded(flex:2,child:
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 50, 0),
            child: TextField(decoration: new InputDecoration.collapsed(
                hintText: 'Nombre del Campo'
            ),
              controller: widget.values['fieldController'],style: TextStyle(fontSize: 14,color: Colors.blue),),
          )
           ),
          Divider(color: Colors.blue,thickness: 2,),
          Expanded(flex:2,child:
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1,child: Container(),),
              Expanded(flex:2,
                child: Theme(
                  child: Checkbox(value: widget.values['mandatory'],
                    activeColor: Colors.blue[300],
                    onChanged:(val){

                      setState(() {
                        widget.values['mandatory']=val;
                      });
                    }),
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
            child:Padding(
              padding: const EdgeInsets.symmetric(horizontal:6.0),
              child: TextField(decoration: new InputDecoration.collapsed(
                  hintText: 'Opciones: (separar con ";")'
              ),
                controller: widget.values['optionsController'],style: TextStyle(fontSize: 14,color: Colors.blue),),
            ),
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
            onPressed:(val) {

              setState(() {
                initSelectedTypes();
                widget.values['selectedType'][index]=true;
              });
            },
            children: [widgets],
          );
        }).toList());
  }
}
