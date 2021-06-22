import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notz/classes/change.dart';
import 'package:notz/services/db.dart';
import 'package:reorderables/reorderables.dart';
import 'package:notz/classes/stack.dart' as stk;



class Bullets extends StatefulWidget {
  List bullets;
  bool edit;
  String model;
  bool mobile;
  Function f;
  Bullets({this.bullets,this.edit,this.model,this.mobile});
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
  String editingBullet="";
  int editingBulletIndex=-1;
  ScrollController scroller=new ScrollController();
  ScrollController scroller2=new ScrollController();
  bool isMobile;//=false;

  //List<bool> focuses=[];

  List<Change> changes=[];
  Change change;
  int changesIndex=-1;
  stk.Stack<Change> redoChanges=stk.Stack();







  @override
  void initState() {
bullets=widget.bullets??[];
//resetFocuses();
 initChange();
for(var x in bullets){
  initialState.add(x);
}

if(widget.mobile!=null){
  isMobile=widget.mobile;
}

//addState();
    super.initState();
  }

  /*void resetFocuses({bool addingNew}){
    focuses=[];
    focuses=new List.filled(bullets.length, false,growable: true);
    if(addingNew!=null&&addingNew){
      focuses[focuses.length-1]=true;
    }
    print("Focuses: (${focuses.length})");
    print(focuses);
  }*/

  void initChange(){
    change  =new Change(field: "Bullets",collection: "Products",id:widget.model);
  }

void beforeChange(){
  if(undo.isEmpty){
    change.snapshotBefore=initialState;
  }
  else{
    change.snapshotBefore=undo.peek();
  }


  //print(change.snapshotBefore);

}

void afterChange(){

    change.snapshotAfter=undo.peek();
    bool res=true;
    while(res){
      res=change.snapshotAfter.remove("");
    }
    if(change.snapshotAfter.length>change.snapshotBefore.length){
      print(changesIndex);
      print(change.snapshotAfter);
      change.type="add";
      change.before=null;
      change.after=change.snapshotAfter[changesIndex];
    }
    if(change.snapshotAfter.length<change.snapshotBefore.length){
      change.type="delete";
      change.before=change.snapshotBefore[changesIndex];
      change.after=null;
    }
    if(change.snapshotAfter.length==change.snapshotBefore.length){
      change.type="update";
      change.before=change.snapshotBefore[changesIndex];
      change.after=change.snapshotAfter[changesIndex];
    }
  }

  void printChanges(){
    print('PRINTING CHANGES (${changes.length})');
    for(var change in changes) {
      print(change.type);
      print('Before: ${change.before}');
      print('After: ${change.after}');
      print(change.snapshotBefore);
      print(change.snapshotAfter);
      print("Notes: ${change.notes}");
      print("\n");
    }
  }
  void addState({bool fromReorder}){
//fromReorder es para no guardar el Change aqui y si guardarlo desde onReorder por el tema de los 2 indices

   // if(fromReorder==null||!fromReorder) {
      beforeChange();
   // }
  List temp=[];
    for(var x in bullets){
      temp.add(x);
    }
  undo.push(temp);

  //print("add State...");

    if(fromReorder==null||!fromReorder) {
      afterChange();
      change.timestamp=DateTime.now();
      changes.add(change);
      initChange();

    }


  }

  void doneEditing(){
    if(editingBulletIndex>=0) {
      bullets[editingBulletIndex] = editingBullet;
      addState();
      editingBulletIndex=-1;
      changesIndex=-1;
    }
  }


  void buildTiles({bool onSave,double width}){

    double w=780;
    int exp=2;
    int dif=0;

    if(isMobile){
      w=width;
      exp=3;
      dif=20;
    }
    _tiles.clear();
    controllers.clear();
    for(int i=0;i<bullets.length;i++){
     FocusNode focusNode = FocusNode();
     focusNode.addListener(() {
       //resetFocuses();
       if(!focusNode.hasFocus) {

         if(editingBulletIndex>=0) {
           setState(() {
             bullets[i] = editingBullet;
             addState();
             editingBulletIndex = -1;
           });
         }
       }
       else{
        editingBullet="";
       // setState(() {


         // focuses[i]=true;

      //  });
       }
      // print("FL");
      // print(focuses);
     });
     // for(var x in bullets){
        TextEditingController tc =new TextEditingController(text:bullets[i]);
        controllers.add(tc);




        _tiles.add(

            Container(width: w-dif,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(flex:exp,child: IconButton(icon: Icon(Icons.drag_handle,),onPressed: (){


                    },)),
                    Expanded(flex:exp,child: IconButton(icon: Icon(Icons.delete,),onPressed: (){
                      doneEditing();

                      changesIndex=i;

                      setState(() {

                        dynamic x=bullets.removeAt(i);
                       // resetFocuses();
                       if(x!="")
                       addState();
                      });
                    },)),
                    Expanded(flex:1,child: Container()),
                    Expanded(flex:28,child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,4,0,0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: new TextField(

                              //showCursor: focuses[i],
                              keyboardType: TextInputType.multiline,focusNode:focusNode,maxLines:null,style:TextStyle(fontSize: 14),controller: tc,onChanged: (val){
                            //bullets[i]=val;
                              editingBulletIndex=i;
                              changesIndex=i;
                         editingBullet=val;

                            },
                        ),
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
    final double deviceWidth = MediaQuery.of(context).size.width;
   // bool isMobile;
    deviceWidth>=768?isMobile=false:isMobile=true;

    void _onReorder(int oldIndex, int newIndex) {
      //changesIndex=oldIndex;

      doneEditing();
      //resetFocuses();
      if(bullets[oldIndex]!=""){
      dynamic old=bullets.removeAt(oldIndex);

      bullets.insert(newIndex, old);

      setState(() {
        buildTiles(width: deviceWidth);
      });


        addState(fromReorder: true);
        change.before = oldIndex;
        change.type = "reorder";
        change.after = newIndex;
        change.snapshotAfter = undo.peek();
        change.notes = change.snapshotBefore[oldIndex];
        change.timestamp = DateTime.now();
        changes.add(change);
        initChange();
      }
      //changesIndex=-1;


    }

    if(editing) {
      buildTiles(width: deviceWidth);
    }



    return
      Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.edit?!editing?FlatButton.icon(icon:Icon(Icons.edit,color:Colors.blue),label: Text("Editar (${bullets.length} características)",style: TextStyle(color: Colors.blue,),),onPressed: (){
            bulletsTemp.clear();
            changes.clear();
            for(var x in bullets){
              bulletsTemp.add(x);
            }
           // addState();
            setState(() {
              editing=!editing;
            });
          },):
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Row(mainAxisAlignment: isMobile?MainAxisAlignment.spaceEvenly:MainAxisAlignment.center,
                  children: [
                   !isMobile? FlatButton.icon(icon:Icon(Icons.check_circle,color:Colors.green),label: Text("Guardar",style: TextStyle(color: Colors.green,),),onPressed: ()async{
                      doneEditing();
                      undo.clear();
                      redo.clear();
                    while(bullets.contains("")) {
                      bullets.remove("");
                    }
                     // resetFocuses();


                      setState(() {
                        editing=!editing;
                      });
                   // printChanges();
                    await updateBullets();
                   // await DatabaseService().updateProduct(widget.model,bullets: bullets,before: initialState);
                     // initialState=bullets;
                    },):IconButton(icon:Icon(Icons.check_circle,color:Colors.green,size: 36,),onPressed: ()async{
                     doneEditing();
                     undo.clear();
                     redo.clear();
                     while(bullets.contains("")) {
                       bullets.remove("");
                     }
                    // resetFocuses();


                     setState(() {
                       editing=!editing;
                     });
                   //  printChanges();
                     await updateBullets();
                    // await DatabaseService().updateProduct(widget.model,bullets: bullets,before: initialState);
                    // initialState=bullets;
                   },),



                    SizedBox(width: isMobile?12:4,),

                   !isMobile? FlatButton.icon(icon:Icon(Icons.cancel,color:Colors.red),label: Text("Cancelar",style: TextStyle(color: Colors.red,),),onPressed: (){
                      bullets.clear();
                      //resetFocuses();
                      undo.clear();
                      redo.clear();
                      changes.clear();
                      initChange();

                      for(var x in bulletsTemp){
                        bullets.add(x);
                      }

                      setState(() {
                        editing=!editing;
                      });
                    },):IconButton(icon:Icon(Icons.cancel,color:Colors.red,size:36 ,),onPressed: (){
                     bullets.clear();
                     //resetFocuses();
                     undo.clear();
                     redo.clear();
                     changes.clear();
                     initChange();
                     for(var x in bulletsTemp){
                       bullets.add(x);
                     }
                     setState(() {
                       editing=!editing;
                     });
                   },),
                    SizedBox(width: isMobile?12:4,),

                    !isMobile?FlatButton.icon(icon:Icon(Icons.add_circle,color:Colors.blue),label: Text("Agregar Bullet",style: TextStyle(color: Colors.blue,),),onPressed: (){

                        doneEditing();
                        if(!bullets.contains("")) {
                        setState(() {
                          bullets.add("");
                          //resetFocuses(addingNew: true);
                          scroller.jumpTo(scroller.position.maxScrollExtent +
                              120);
                          // _tiles.add(addSingleTile(controller:new TextEditingController(text: ""),index:_tiles.length));
                        });
                      }
                      else{
                        print(bullets);
                      }

                    },):IconButton(icon:Icon(Icons.add_circle,color:Colors.blue,size: 36,),onPressed: (){
                      doneEditing();
                      if(!bullets.contains("")) {
                      setState(() {
                        bullets.add("");
                        //resetFocuses(addingNew: true);
                        // _tiles.add(addSingleTile(controller:new TextEditingController(text: ""),index:_tiles.length));
                      });}
                    },),
                    SizedBox(width: isMobile?12:4,),
                    IconButton(icon:Icon(Icons.undo,color:undo.isEmpty?Colors.grey[400]:Colors.blue,size:isMobile?36:24),onPressed:undo.isEmpty?null:(){
                      doneEditing();
                      bullets.clear();
                      setState(() {
                        if(changes.isNotEmpty){
                          redoChanges.push(changes.removeLast());
                        }
                        if(!undo.isEmpty){

                          redo.push( undo.pop());

                        }
                        if(undo.isEmpty){
                          for(var x in bulletsTemp){
                            bullets.add(x);
                          }
                        }
                        else{
                          for(var x in undo.peek()){
                            bullets.add(x);
                          }
                        }
                        //resetFocuses();
                      });

                    },),
                    SizedBox(width: isMobile?12:4,),
                    IconButton(icon:Icon(Icons.redo,color:redo.isEmpty?Colors.grey[400]:Colors.blue,size:isMobile?36:24),onPressed:redo.isEmpty?null:(){
                     doneEditing();
                      bullets.clear();
                      setState(() {
                        if(!redoChanges.isEmpty){
                          changes.add(redoChanges.pop());
                        }
                        if(!redo.isEmpty){

                          undo.push( redo.pop());

                        }
                        if(undo.isEmpty){
                          for(var x in bulletsTemp){
                            bullets.add(x);
                          }
                        }
                        else{
                          for(var x in undo.peek()){
                            bullets.add(x);
                          }
                        }
                        //resetFocuses();
                      /*  if(redo.isEmpty){
                          for(var x in bulletsTemp){
                            bullets.add(x);
                          }
                        }
                        else{
                          for(var x in undo.peek()){
                            bullets.add(x);
                          }
                        }*/

                      });
                    },),
                  ],
                ),
              ):

          Container(),

          /* widget.edit? FlatButton.icon(label: !editing?Text("Editar",style: TextStyle(color: Colors.blue,),):Text("Guardar",style: TextStyle(color: Colors.green,),),icon: !editing?Icon(Icons.edit,color: Colors.blue,):Icon(Icons.check,color: Colors.green,),onPressed: (){
       setState(() {
         editing=!editing;
       });
     },):Container(),*/
    widget.edit?SizedBox(height: 10,):Container(),
          !editing?Container(width: 800,
            child: ListView.builder(controller: scroller2,
                itemCount:bullets.length,shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [Expanded(flex:3,child: FlatButton(
                        child: Text("\u2022",style: TextStyle(fontSize: 24),),onPressed: (){Clipboard.setData(new ClipboardData(text:bullets[index]));},)),
                        Expanded(flex:1,child: Container()),
                        Expanded(flex:33,child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,4,0,0),
                          child: new SelectableText(bullets[index]),
                        )),
                      ],
                    ),
                  );
                }),
          ):

          Container(width: 800, child:
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

            ReorderableWrap(controller: scroller,
              direction:Axis.vertical ,
                needsLongPressDraggable:isMobile,
                spacing: 8.0,
                runSpacing: 4.0,
                padding: const EdgeInsets.all(0),
               // maxMainAxisCount: 1,
                children: _tiles,
                onReorder: _onReorder,
                onNoReorder: (int index) {
                  doneEditing();
                  setState(() {

                  });
                 // print(index);
                  //this callback is optional
                  debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
                },
                onReorderStarted: (int index) {
                  //this callback is optional
                  debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
                }
            ),
          ),
        ],
      )

    ;

  }

  Future updateBullets()async{
    await DatabaseService().updateProduct(widget.model,bullets: bullets,change: changes);//,before: initialState);
    initialState.clear();
    for(var x in bullets){
      initialState.add(x);
    }
  }

}
