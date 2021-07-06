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


  FilePickerResult filePickerResult;
  double height=16;
  final double _iconSize = 90;
  List<Widget> _tiles=[];
  bool attaching=false;
  String ordenar="Ordenar";
  bool enabledButton=false;
  String attached="";





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

  /*Future<bool> getFirebaseImages() async{

    Uint8List byte;

    // List<Uint8List> l=[];
    if(photos!=null&&photos.isNotEmpty)
      for(var x in photos){
        if(photos!=null&&x!=null) {
          byte = await StorageManager().downloadFile(
              "productos/${widget.model}/$x");
        }
        bytes[x]=byte;
        // l.add(byte);
      }
    return bytes.isNotEmpty;
    //  return l;
  }*/
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

                await DatabaseService().updateProduct(
                    model, photos: photos);
                setState(() {
                  buildTiles();
                //  init();
                });

              },)
        ),

      ],),
    );
  }
 /* Future init()async{
    photos.clear();
    bytes.clear();
    _tiles.clear();
    await DatabaseService().getProducto(model).then((value) {
      photos=value.photos;
      //photosNames=value.photosName;

    });

    await getFirebaseImages();

    if(photos!=null&&photos.isNotEmpty) {
      for (var x in photos) {
        _tiles.add( Image.network(x
        ,height: 100,),)  ;

        _tiles.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Stack(children: [
                Image.memory(bytes[x]
                  // Image.network(x
                  , height: 100,),
                Positioned(top: 0, right: -10,
                    child: IconButton(
                      icon: Icon(Icons.clear, color: Colors.blue, size: 16,),
                      onPressed: () async {
                        print(x);
                        await StorageManager().deleteCloudFile(
                            "productos/$model/$x");


                        photos.remove(x);

                        await DatabaseService().updateProduct(
                            model, photos: photos);
                        setState(() {
                          init();
                        });

                      },)
                ),

              ],),
            ));
      }
    }
    setState(() {

    });

    return true;
  }*/




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
        enabledButton = true;
      });
    }


    return


      SingleChildScrollView(
        child: Container(
          child: Column(children: [

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
              padding: EdgeInsets.fromLTRB(0, 10, 0, 16),
              child: RaisedButton(color: Colors.blue,
                child: Text("Adjuntar", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  filePickerResult = await FilePicker.platform.pickFiles(
                      withData: true);
                  if (filePickerResult.files.isNotEmpty) {
                    setState(() {
                      attaching = true;
                      ordenar = "Subir";
                      height = 8;
                      if (!bytes.containsKey(filePickerResult.files[0].name)) {
                        attached = "Se adjunto ${filePickerResult.files[0].name}";
                      }
                      else{
                        attached = "${filePickerResult.files[0].name} ya existe";
                      }
                      enabledButton = true;
                    });
                  }
                  else {
                    attaching = false;
                    ordenar = "Ordenar";
                    height = 0;
                    setState(() {
                      attached = "";
                    });
                  }
                },),
            ),
            attached == "" ? Container() : Text(attached, style: TextStyle(color: Colors.blue),),

            Padding(
              padding: EdgeInsets.fromLTRB(0, height, 0, 0),
              child: Opacity(opacity: enabledButton ? 1 : 0.3,
                child: RaisedButton(color: enabledButton?Colors.blue:Colors.grey,
                  child: Text(ordenar, style: TextStyle(color: Colors.white),),
                  onPressed: !enabledButton ? null : () async {
                    setState(() {
                      enabledButton=false;
                    });
                    if (attaching) {
                      if (bytesBuffer.isNotEmpty) {
                        for (var x in bytesBuffer.keys) {
                          String name = x;
                         // int size = filePickerResult.files[0].size;
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
                          enabledButton = false;
                          newPhotos.clear();
                          existingPhotos.clear();
                          oversizedPhotos.clear();
                          attached="";
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
                 //   setState(() {
                  //    enabledButton=true;
                  //  });
                  },),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0, height, 0, 0),
              child: Opacity(opacity: enabledButton ? 1 : 0.3,
                child: RaisedButton(color: enabledButton?Colors.blue:Colors.grey,
                  child: Text("Cancelar", style: TextStyle(color: Colors.white),),
                  onPressed: !enabledButton ? null : () async {
                    setState(() {
                      enabledButton=false;
                      newPhotos.clear();
                      existingPhotos.clear();
                      oversizedPhotos.clear();
                      attached="";
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

                   // attached = "Se adjunto $name \n$attached";
                  }
                  else{
                    if(!existingPhotos.contains(name)&&!newPhotos.contains(name))
                    existingPhotos.add(name);
                    //attached = "$name ya existe \n";
                  }
                  if(newPhotos.isNotEmpty){
                    attached="Se adjunto:\n";
                    for(var x in newPhotos){
                      attached='$attached$x\n';
                    }
                  }
                  if(existingPhotos.isNotEmpty){
                    attached="$attached\n\nYa existe:\n";
                    for(var x in existingPhotos){
                      attached='$attached$x\n';
                    }
                  }

                  if(oversizedPhotos.isNotEmpty){

                    if (oversizedPhotos.isNotEmpty) {
                      attached =
                      "$attached\n\nFotos no adjuntadas (mayor que 400 kb):\n";
                      for (var x in oversizedPhotos) {
                        attached = '$attached$x\n';
                      }

                  }
                  }

                  enabledButton = true;
                });
              }
              else {
                attaching = false;
                ordenar = "Ordenar";
                height = 0;
                setState(() {
                  attached = "";
                });
              }

          },
            sizeExceeds: (val){
            setState(() {
              enabledButton = true;
              if(!oversizedPhotos.contains(val)) {
                oversizedPhotos.add(val);
                if (oversizedPhotos.isNotEmpty) {
                  attached =
                  "$attached\n\nFotos no adjuntadas (mayor que 400 kb):\n";
                  for (var x in oversizedPhotos) {
                    attached = '$attached$x\n';
                  }
                }
              }
            });

            },
            maxKb: 400,
            instructions: "Arrastra varias fotos",):Container()

          //  kIsWeb?DragAndDrop():Container(),

          ],),

        ),
      ); //,// ProductView(),

  }

// );




}
