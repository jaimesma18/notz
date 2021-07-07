import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:notz/services/storageManager.dart';
import 'package:notz/services/db.dart';
import 'package:notz/widgets/dragAndDrop.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter/foundation.dart' show kIsWeb;





class ImageUploader extends StatefulWidget {
  @override
  String model;
  Map<String,Uint8List>bytes;
  List photos;
  ImageUploader({this.model,this.bytes,this.photos});

  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String model;
  List photos=[];
  Map<String,Uint8List>bytes;
  List initPhotos=[];
  Map<String,Uint8List>initBytes= new  Map<String,Uint8List>();
  Map<String,Uint8List> bytesBuffer=new Map<String,Uint8List>();
  List<String> newPhotos=[];
  List<String> existingPhotos=[];
  List<String> oversizedPhotos=[];
  List<String> wrongFormat=[];


  FilePickerResult filePickerResult;
  double height=16;
  final double _iconSize = 90;
  List<Widget> _tiles=[];
  bool attaching=false;
  String ordenar="Ordenar";
  bool enableAttachButton=false;
  bool enableCancelButton=false;
  int maxKb=500;
  List<String> ext=["jpg","png","gif"];



  @override
  void initState() {
    super.initState();


    model=widget.model;
    for(var x in widget.photos){
      initPhotos.add(x);
    }
    for(var x in widget.bytes.keys){
      initBytes[x]=widget.bytes[x];
    }

    photos=widget.photos;
    bytes=widget.bytes;


    buildTiles();
    //init();


  }

  void buildTiles(){

    _tiles.clear();
    for(var x in photos){
      _tiles.add(buildTile(x));
    }
  }

  Widget buildTile(String photoName){
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Stack(children: [
        Image.memory(bytes[photoName]
          // Image.network(x
          , height: 100,),
        Positioned(top: 0, right: -10,
            child: IconButton(
              icon: Icon(Icons.clear, color: Colors.blue, size: 16,),
              onPressed: () async {

                await StorageManager().deleteCloudFile(
                    "productos/$model/$photoName");


                photos.remove(photoName);
                bytes.remove(photoName);

                initPhotos.clear();
                initBytes.clear();
                for(var x in photos){
                  initPhotos.add(x);
                }
                for(var x in bytes.keys){
                  initBytes[x]=widget.bytes[x];
                }

                await DatabaseService().updateProduct(
                    model, photos: photos);
                setState(() {
                  enableCancelButton=false;
                  buildTiles();
                //  init();
                });


              },)
        ),

      ],),
    );
  }



  @override
  Widget build(BuildContext context)

  {


    final double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    bool isMobile;
    deviceWidth >= 768 ? isMobile = false : isMobile = true;


    void _onReorder(int oldIndex, int newIndex) async{
      dynamic old = photos.removeAt(oldIndex);
      photos.insert(newIndex, old);

      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
        enableAttachButton = true;
        enableCancelButton=true;
      });
    }


    return


      SingleChildScrollView(
        child: Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            _tiles.isEmpty?Container():
            ReorderableWrap(
                needsLongPressDraggable: false,
                spacing: 8.0,
                runSpacing: 4.0,
                padding: const EdgeInsets.all(8),
                maxMainAxisCount: 3,
                children: _tiles,
                onReorder: _onReorder,
                onNoReorder: (int index) {
                  print(index);
                  //this callback is optional
                  debugPrint('${DateTime.now().toString().substring(
                      5, 22)} reorder cancelled. index:$index');
                },
                onReorderStarted: (int index) {
                  //this callback is optional
                  debugPrint('${DateTime.now().toString().substring(
                      5, 22)} reorder started: index:$index');
                }
            ),





            Padding(
              padding:  EdgeInsets.fromLTRB(0,height,0,height),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Opacity(opacity: enableAttachButton ? 1 : 0.3,
                      child: RaisedButton(color: enableAttachButton?Colors.blue:Colors.grey,
                        child: Text(ordenar, style: TextStyle(color: Colors.white),),
                        onPressed: !enableAttachButton ? null : () async {
                          setState(() {
                            enableAttachButton=false;
                            enableCancelButton=false;
                          });
                          if (attaching) {
                            if (bytesBuffer.isNotEmpty) {
                              for (var x in bytesBuffer.keys) {
                                String name = x;
                                if (!bytes.containsKey(name)) {
                                  bytes[name] = bytesBuffer[x];
                                  photos.add(name);
                                  setState(() {
                                    buildTiles();
                                  });

                                }
                                else {
                                  print("existe");
                                }
                              }
                              for (var x in bytesBuffer.keys) {
                                StorageManager sm = new StorageManager();
                                Map<String, String> m = new Map();
                                m['contentType'] = "image/jpeg";
                                TaskSnapshot res = await sm.uploadRaw(
                                    bytesBuffer[x],
                                    "/productos/$model/$x",
                                    contentType: "image/jpeg");
                              }
                              await DatabaseService().updateProduct(model,
                                  photos: photos);

                              setState(() {
                                attaching = false;
                                ordenar = "Ordenar";
                                enableAttachButton = false;
                                enableCancelButton=false;
                                newPhotos.clear();
                                existingPhotos.clear();
                                oversizedPhotos.clear();
                                wrongFormat.clear();
                                bytesBuffer.clear();


                              });
                            }
                          }
                          else {
                            await DatabaseService().updateProduct(model, photos: photos, );
                            setState(() {
                              buildTiles();
                            });


                          }
                          initPhotos.clear();
                          initBytes.clear();
                          for(var x in photos){
                            initPhotos.add(x);
                          }
                          for(var x in bytes.keys){
                            initBytes[x]=widget.bytes[x];
                          }
                        },),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Opacity(opacity: enableCancelButton ? 1 : 0.3,
                      child: RaisedButton(color: enableCancelButton?Colors.blue:Colors.grey,
                        child: Text("Cancelar", style: TextStyle(color: Colors.white),),
                        onPressed: !enableCancelButton ? null : () async {
                          setState(() {
                            enableAttachButton=false;
                            enableCancelButton=false;
                            newPhotos.clear();
                            existingPhotos.clear();
                            oversizedPhotos.clear();
                            wrongFormat.clear();
                            attaching=false;
                            ordenar = "Ordenar";
                            widget.photos.clear();
                            widget.bytes.clear();
                            bytesBuffer.clear();
                            for(var x in initPhotos){
                              widget.photos.add(x);
                            }
                            for(var x in initBytes.keys){
                              widget.bytes[x]=initBytes[x];
                            }
                            photos=widget.photos;
                            bytes=widget.bytes;
                            buildTiles();
                          });


                        },),
                    ),
                  ),
                ],
              ),
            ),

          kIsWeb?
          DragAndDrop(width: 400,height:300 ,

            onDrop: (val){
            Map m=new Map();
              if (val!=null&&val.length>0) {
                setState(() {
                  attaching = true;
                  ordenar = "Subir";
                  height = 8;
                  String name=val.keys.toList()[0];
                  Uint8List byte=val.values.toList()[0];
                  if (!bytes.containsKey(name)&&!newPhotos.contains(name)) {
                    newPhotos.add(name);
                    bytesBuffer[name]=byte;
                    setState(() {
                      enableAttachButton=true;
                      enableCancelButton=true;
                    });

                  }
                  else{
                    if(!existingPhotos.contains(name)&&!newPhotos.contains(name))
                    existingPhotos.add(name);
                    setState(() {
                      enableCancelButton=true;
                    });
                  }




                });
              }
              else {
                attaching = false;
                ordenar = "Ordenar";
                height = 0;

              }

          },
            wrongFormat: (val){
            if(!wrongFormat.contains(val)){
              setState(() {
                enableCancelButton=true;
                wrongFormat.add(val);
                
              });

            }
            },
            sizeExceeds: (val){

              if(!oversizedPhotos.contains(val)) {
                setState(() {
                  enableCancelButton=true;
                  oversizedPhotos.add(val);
                });

              }

            },
            maxKb: maxKb,
            extensions: ext,
            instructions: "Arrastra varias fotos",):
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 16),
            child: RaisedButton(color: Colors.blue,
              child: Text("Adjuntar", style: TextStyle(color: Colors.white)),
              onPressed: () async {

                FilePickerResult result = await FilePicker.platform
                    .pickFiles(type: FileType.custom,
                    allowedExtensions: ext);

                if(result!=null) {
                  if (ext != null) {
                    if (ext.isNotEmpty) {
                      if (!ext.contains(
                          result.files.single.name.substring(
                              result.files.single.name.length - 3))) {
                        if(!wrongFormat.contains(result.files.single.name)){
                          setState(() {
                            enableCancelButton=true;
                            wrongFormat.add(result.files.single.name);

                          });

                        }
                      }
                      else {
                        if (result.files.single.size / 1000 >
                            maxKb) {

                          if(!oversizedPhotos.contains(result.files.single.name)) {
                            setState(() {
                              enableCancelButton=true;
                              oversizedPhotos.add(result.files.single.name);
                            });
                          }
                        }
                        else {
                          String name=result.files.single.name;
                          final byte = result.files.single.bytes;
                          setState(() {
                            attaching = true;
                            ordenar = "Subir";
                            height = 8;
                            if (!bytes.containsKey(name)&&!newPhotos.contains(name)) {
                              newPhotos.add(name);
                              bytesBuffer[name]=byte;
                              setState(() {
                                enableAttachButton=true;
                                enableCancelButton=true;
                              });

                            }
                            else{
                              if(!existingPhotos.contains(name)&&!newPhotos.contains(name))
                                existingPhotos.add(name);
                              setState(() {
                                enableCancelButton=true;
                              });
                            }
                          });
                        }
                      }
                    }
                  }
                }

              },),
          ),

          newPhotos.isNotEmpty||existingPhotos.isNotEmpty||oversizedPhotos.isNotEmpty||wrongFormat.isNotEmpty?
          DataTable(headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
            columns: [
              DataColumn(label: Text("Imagen")),
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Detalle")),
            ],
            rows: prepareRows(),
          ):Container(),

          ],),

        ),
      ); //,// ProductView(),

  }



  List<DataRow> prepareRows(){
   List<DataRow> rows=[];
   String formats=ext.join(", ");

   for(var x in newPhotos){
     rows.add(DataRow(
       cells: [DataCell(Text(x)),DataCell(Icon(Icons.check_circle_outline,color: Colors.green,)),DataCell(Text("OK"))]
     ));
   }

   for(var x in existingPhotos){
     rows.add(DataRow(
         cells: [DataCell(Text(x)),DataCell(Icon(Icons.cancel_outlined,color: Colors.red,)),DataCell(Text("Imagen ya existe"))]
     ));
   }

   for(var x in wrongFormat){
     rows.add(DataRow(
         cells: [DataCell(Text(x)),DataCell(Icon(Icons.cancel_outlined,color: Colors.red,)),DataCell(Text("Archivo no es de tipo $formats"))]
     ));
   }

   for(var x in oversizedPhotos){
     rows.add(DataRow(
         cells: [DataCell(Text(x)),DataCell(Icon(Icons.cancel_outlined,color: Colors.red,)),DataCell(Text("Imagen es mayor que $maxKb kB"))]
     ));
   }


   return rows;
  }





}
