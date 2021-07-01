/*
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:notz/services/storageManager.dart';
import 'package:notz/services/db.dart';
import 'package:reorderables/reorderables.dart';





class ImageUploader extends StatefulWidget {
  @override
  String model;
  ImageUploader({this.model});

  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
String model;
String attached="";
List photos=[];
//Map photosNames=new Map();
FilePickerResult filePickerResult;
double height=16;
final double _iconSize = 90;
List<Widget> _tiles=[];
bool attaching=false;
String ordenar="Ordenar";
bool enabledButton=false;
Map<String,Uint8List>bytes=new Map<String,Uint8List>();


  @override
  void initState() {
    super.initState();

    model=widget.model;
    init();


  }

  Future<bool> getFirebaseImages() async{

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
  }

  Future init()async{
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
        */
/*_tiles.add( Image.network(x
        ,height: 100,),)  ;*//*


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
  }

  Future deleteImage (String name)async{

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


    void _onReorder(int oldIndex, int newIndex) {
      dynamic old = photos.removeAt(oldIndex);
      photos.insert(newIndex, old);
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
        enabledButton = true;
      });
    }


    return
      _tiles.isEmpty ? Container(child:
        Column(children: [

          Padding(
            padding: EdgeInsets.fromLTRB(0, 60, 0, 16),
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
                    attached = "Se adjunto ${filePickerResult.files[0].name}";
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
          attached == "" ? Container() : Text(attached),

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
                    if (filePickerResult.files.isNotEmpty) {
                      String name = filePickerResult.files[0].name;
                      int size = filePickerResult.files[0].size;
                      print(size);
                      if (!bytes.containsKey(name)) {
                        StorageManager sm = new StorageManager();
                        Map<String, String> m = new Map();
                        m['contentType'] = "image/jpeg";
                        TaskSnapshot res = await sm.uploadRaw(
                            filePickerResult.files[0].bytes,
                            "/productos/$model/$name",
                            contentType: "image/jpeg");

                    */
/*    Reference storageRef = FirebaseStorage.instance.ref(
                            res.metadata.fullPath);*//*

                        if(photos==null){
                          photos=[];
                        }
                        photos.add(name);
                        await DatabaseService().updateProduct(model,
                            photos: photos);
                        await init();
                        */
/*  storageRef.getDownloadURL().then((value) async {
                       photos.add(value);
                       photosNames[value] = name;
                       await DatabaseService().updateProduct(model,
                           photos: photos, photosNames: photosNames);
                       await init();
                     });*//*

                        setState(() {
                          attaching = false;
                          ordenar = "Ordenar";
                          enabledButton = false;
                        });
                      }
                      else {
                        print("existe");
                      }
                    }
                  }
                  else {
                    await DatabaseService().updateProduct(model, photos: photos,
                      //    photosNames: photosNames
                    );

                    await init();
                  }
                  setState(() {
                    enabledButton=true;
                  });
                },),
            ),
          ),

        ],),
      ) :


      Container(
        child: Column(children: [
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
                    attached = "Se adjunto ${filePickerResult.files[0].name}";
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
          attached == "" ? Container() : Text(attached),

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
                    if (filePickerResult.files.isNotEmpty) {
                      String name = filePickerResult.files[0].name;
                      int size = filePickerResult.files[0].size;
                      print(size);
                      if (!bytes.containsKey(name)) {
                        StorageManager sm = new StorageManager();
                        Map<String, String> m = new Map();
                        m['contentType'] = "image/jpeg";
                        TaskSnapshot res = await sm.uploadRaw(
                            filePickerResult.files[0].bytes,
                            "/productos/$model/$name",
                            contentType: "image/jpeg");


                        photos.add(name);
                        await DatabaseService().updateProduct(model,
                            photos: photos);
                        await init();
                      */
/*  Reference storageRef = FirebaseStorage.instance.ref(
                            res.metadata.fullPath);*//*

                        */
/*  storageRef.getDownloadURL().then((value) async {
                       photos.add(value);
                       photosNames[value] = name;
                       await DatabaseService().updateProduct(model,
                           photos: photos, photosNames: photosNames);
                       await init();
                     });*//*

                        setState(() {
                          attaching = false;
                          ordenar = "Ordenar";
                          enabledButton = false;
                        });
                      }
                      else {
                        print("existe");
                      }
                    }
                  }
                  else {
                    await DatabaseService().updateProduct(model, photos: photos,
                      //    photosNames: photosNames
                    );

                    await init();
                  }
                setState(() {
                  enabledButton=true;
                });
                },),
            ),
          ),

        ],),

      ); //,// ProductView(),

  }

   // );




}
*/


import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:notz/services/storageManager.dart';
import 'package:notz/services/db.dart';
import 'package:reorderables/reorderables.dart';





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


      Container(
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
                    attached = "Se adjunto ${filePickerResult.files[0].name}";
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
          attached == "" ? Container() : Text(attached),

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
                    if (filePickerResult.files.isNotEmpty) {
                      String name = filePickerResult.files[0].name;
                      int size = filePickerResult.files[0].size;
                      print(size);
                      if (!bytes.containsKey(name)) {
                        bytes[name]= filePickerResult.files[0].bytes;
                        photos.add(name);
                        setState(() {
                          buildTiles();
                        });


                        StorageManager sm = new StorageManager();
                        Map<String, String> m = new Map();
                        m['contentType'] = "image/jpeg";
                        TaskSnapshot res = await sm.uploadRaw(
                            filePickerResult.files[0].bytes,
                            "/productos/$model/$name",
                            contentType: "image/jpeg");

                        await DatabaseService().updateProduct(model,
                            photos: photos);

                       // await init();
                        /*  Reference storageRef = FirebaseStorage.instance.ref(
                            res.metadata.fullPath);*/
                        /*  storageRef.getDownloadURL().then((value) async {
                       photos.add(value);
                       photosNames[value] = name;
                       await DatabaseService().updateProduct(model,
                           photos: photos, photosNames: photosNames);
                       await init();
                     });*/
                        setState(() {
                          attaching = false;
                          ordenar = "Ordenar";
                          enabledButton = false;
                        });
                      }
                      else {
                        print("existe");
                      }
                    }
                  }
                  else {
                    await DatabaseService().updateProduct(model, photos: photos, );
                    setState(() {
                      buildTiles();
                    });


                  }
                  setState(() {
                    enabledButton=true;
                  });
                },),
            ),
          ),

        ],),

      ); //,// ProductView(),

  }

// );




}
