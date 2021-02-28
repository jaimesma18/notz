import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notz/services/db.dart';
import 'package:reorderables/reorderables.dart';
import 'package:notz/classes/stack.dart' as stk;



class Bullets extends StatefulWidget {
  List bullets;
  bool edit;
  String model;
  Bullets({this.bullets,this.edit,this.model});
  @override
  _BulletsState createState() => _BulletsState();
}

class _BulletsState extends State<Bullets> {
  bool editing=false;
  List bullets;
  List<Widget> _tiles=[];
  List bulletsTemp=[];
  List<TextEditingController>controllers=[];
  List initialState=[];
  stk.Stack<List> undo=stk.Stack();
  stk.Stack<List> redo=stk.Stack();
  final _focusNode = FocusNode();






  @override
  void initState() {
bullets=widget.bullets;

for(var x in bullets){
  initialState.add(x);
}

//addState();
    super.initState();
  }


  void _onReorder(int oldIndex, int newIndex) {
    dynamic old=bullets.removeAt(oldIndex);
    bullets.insert(newIndex, old);
    setState(() {
      buildTiles();
    });
    addState();

  }

  void addState(){
    List temp=[];
    for(var x in bullets){
      temp.add(x);
    }
    undo.push(temp);
    print("added");
    print(temp);
  }


  void buildTiles({bool onSave}){

    _tiles.clear();
    controllers.clear();
    for(int i=0;i<bullets.length;i++){

     // for(var x in bullets){
        TextEditingController tc =new TextEditingController(text:bullets[i]);
        controllers.add(tc);




        _tiles.add(

            Container(width: 780,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(flex:2,child: IconButton(icon: Icon(Icons.drag_handle,),onPressed: (){},)),
                    Expanded(flex:2,child: IconButton(icon: Icon(Icons.delete,),onPressed: (){
                      setState(() {
                        bullets.removeAt(i);
                       addState();
                      });
                    },)),
                    Expanded(flex:1,child: Container()),
                    Expanded(flex:28,child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,4,0,0),
                      child: SingleChildScrollView(scrollDirection: Axis.horizontal ,
                        child: Container(width: 770,
                          child: new TextField(maxLines:null,style:TextStyle(fontSize: 14),controller: tc,onChanged: (val){
                          bullets[i]=val;
                         // setState(() {
                            addState();
                        //  });

                          },
                        ),
                      ),
                    )),),
                  ],
                ),
              ),
            )
        );
      }

  }

  @override
  Widget build(BuildContext context) {


    if(editing) {
      buildTiles();
    }



    return
      Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.edit?!editing?FlatButton.icon(icon:Icon(Icons.edit,color:Colors.blue),label: Text("Editar",style: TextStyle(color: Colors.blue,),),onPressed: (){
            bulletsTemp.clear();
            for(var x in bullets){
              bulletsTemp.add(x);
            }
            addState();
            setState(() {
              editing=!editing;
            });
          },):
              Row(
                children: [
                  FlatButton.icon(icon:Icon(Icons.check_circle,color:Colors.green),label: Text("Guardar",style: TextStyle(color: Colors.green,),),onPressed: ()async{

                    undo.clear();
                    redo.clear();
                  while(bullets.contains("")) {
                    bullets.remove("");
                  }


                    setState(() {
                      editing=!editing;
                    });
                  await DatabaseService().updateProduct(widget.model,bullets: bullets);
                  },),
                  SizedBox(width: 4,),
                  FlatButton.icon(icon:Icon(Icons.cancel,color:Colors.red),label: Text("Cancelar",style: TextStyle(color: Colors.red,),),onPressed: (){
                    bullets.clear();
                    undo.clear();
                    redo.clear();
                    for(var x in bulletsTemp){
                      bullets.add(x);
                    }
                    setState(() {
                      editing=!editing;
                    });
                  },),
                  FlatButton.icon(icon:Icon(Icons.add_circle,color:Colors.blue),label: Text("Agregar Bullet",style: TextStyle(color: Colors.blue,),),onPressed: (){
                    setState(() {
                      bullets.add("");
                   // _tiles.add(addSingleTile(controller:new TextEditingController(text: ""),index:_tiles.length));
                    });
                  },),
                  IconButton(icon:Icon(Icons.undo,color:Colors.blue),onPressed: (){

                    setState(() {
                      if(undo.moreThanOneRemaining()){
                        List l=undo.pop();
                        redo.push(l);
                        bullets=l;
                      }

                    });

                  },),
                  IconButton(icon:Icon(Icons.redo,color:Colors.blue),onPressed:(){

                    setState(() {
                      if(redo.moreThanOneRemaining()){
                        List l=redo.pop();
                        undo.push(l);
                        bullets=l;
                      }

                    });

                  },),
                ],
              ):

          Container(),

          /* widget.edit? FlatButton.icon(label: !editing?Text("Editar",style: TextStyle(color: Colors.blue,),):Text("Guardar",style: TextStyle(color: Colors.green,),),icon: !editing?Icon(Icons.edit,color: Colors.blue,):Icon(Icons.check,color: Colors.green,),onPressed: (){
       setState(() {
         editing=!editing;
       });
     },):Container(),*/
    widget.edit?SizedBox(height: 10,):Container(),
          SingleChildScrollView(
            child: !editing?Container(height: 400,width: 800,
              child: ListView.builder(itemCount:bullets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [Expanded(flex:2,child: FlatButton(child: Text("\u2022",style: TextStyle(fontSize: 24),),onPressed: (){Clipboard.setData(new ClipboardData(text:bullets[index]));},)),
                          Expanded(flex:1,child: Container()),
                          Expanded(flex:28,child: Padding(
                            padding: const EdgeInsets.fromLTRB(0,4,0,0),
                            child: new SelectableText(bullets[index]),
                          )),
                        ],
                      ),
                    );
                  }),
            ):

            Container(height: 400,width: 800, child:
            /*ListView.builder(itemCount:bullets.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(flex:2,child: IconButton(icon: Icon(Icons.drag_handle,),onPressed: (){},)),
                        Expanded(flex:2,child: IconButton(icon: Icon(Icons.delete,),onPressed: (){},)),
                        Expanded(flex:1,child: Container()),
                        Expanded(flex:28,child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,4,0,0),
                          child: new TextField(style:TextStyle(fontSize: 14),controller: new TextEditingController(text: bullets[index]),),
                        )),
                      ],
                    ),
                  );
                }),*/

              ReorderableWrap(
                direction:Axis.vertical ,
                  needsLongPressDraggable: false,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  padding: const EdgeInsets.all(0),
                 // maxMainAxisCount: 1,
                  children: _tiles,
                  onReorder: _onReorder,
                  onNoReorder: (int index) {
                    print(index);
                    //this callback is optional
                    debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
                  },
                  onReorderStarted: (int index) {
                    //this callback is optional
                    debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
                  }
              ),
            )

            ,
          ),
        ],
      )

    ;

  }
}
