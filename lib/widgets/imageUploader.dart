import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:notz/services/storageManager.dart';
import 'package:notz/services/db.dart';
import 'package:reorderables/reorderables.dart';





class ImageUploader extends StatefulWidget {
  @override

  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
String model;
String attached="";
List photos=[];
Map photosNames=new Map();
FilePickerResult filePickerResult;
double height=16;
final double _iconSize = 90;
List<Widget> _tiles=[];
bool attaching=false;
String ordenar="Ordenar";

  @override
  void initState() {
    super.initState();

    model="LC-1192";
    init();


  }

  Future init()async{
    photos.clear();
    _tiles.clear();
    await DatabaseService().getProducto(model).then((value) {
      photos=value.photos;
      photosNames=value.photosName;

    });

    for(var x in photos){
      /*_tiles.add( Image.network(x
        ,height: 100,),)  ;*/

      _tiles.add(
        Stack(children: [
          Image.network(x
          ,height: 100,),
          Positioned(top: 0,right: 0,
            child: IconButton(icon: Icon(Icons.clear),iconSize: 10,onPressed: ()async{
              print(photosNames[x]);
              await StorageManager().deleteCloudFile("productos/$model/${photosNames[x]}");


                photosNames.remove(x);
                photos.remove(x);


              await DatabaseService().updateProduct(model,photos: photos, photosNames: photosNames);
              init();


            },)
          ),

        ],));


    }
    setState(() {

    });

  }

  Future deleteImage (String name)async{

  }


  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    bool isMobile;
    deviceWidth>=768?isMobile=false:isMobile= true;




    void _onReorder(int oldIndex, int newIndex) {
      dynamic old=photos.removeAt(oldIndex);
      photos.insert(newIndex, old);
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
    }


    return
       _tiles.isEmpty?Container():Container(
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
               debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
             },
             onReorderStarted: (int index) {
               //this callback is optional
               debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
             }
         ),
           Padding(
             padding:  EdgeInsets.fromLTRB(0, 10, 0, 16),
             child: RaisedButton(color:Colors.blue,child: Text("Adjuntar",style: TextStyle(color: Colors.white)),onPressed: ()async{
                filePickerResult = await FilePicker.platform.pickFiles(
                   withData: true);
                if(filePickerResult.files.isNotEmpty) {

                  setState(() {
                    attaching=true;
                    ordenar="Subir";
                    height=8;
                    attached = "Se adjunto ${filePickerResult.files[0].name}";
                  });
                }
                else{
                  attaching=false;
                  ordenar="Ordenar";
                  height=0;
                  setState(() {
                    attached="";
                  });
                }
             },),
           ),
           attached==""?Container():Text(attached),

           Padding(
             padding:  EdgeInsets.fromLTRB(0, height, 0, 0),
             child: RaisedButton(color:Colors.blue,child: Text(ordenar,style: TextStyle(color: Colors.white),),onPressed: ()async{


               if(attaching){
               if(filePickerResult.files.isNotEmpty){
                 String name=filePickerResult.files[0].name;
                 int size=filePickerResult.files[0].size;
                 print(size);
                 if(!photosNames.containsValue(name)) {
                   StorageManager sm = new StorageManager();
                   Map<String, String> m = new Map();
                   m['contentType'] = "image/jpeg";
                   TaskSnapshot res = await sm.uploadRaw(
                       filePickerResult.files[0].bytes,
                       "/productos/$model/$name", contentType: "image/jpeg");

                   Reference storageRef = FirebaseStorage.instance.ref(
                       res.metadata.fullPath);
                   storageRef.getDownloadURL().then((value) async {
                     photos.add(value);
                     photosNames[value] = name;
                     await DatabaseService().updateProduct(model,
                         photos: photos, photosNames: photosNames);
                     await init();
                   });
                   setState(() {
                     attaching = false;
                     ordenar = "Ordenar";
                   });
                 }
                 else{
                   print("existe");
                 }



               }}
               else{
                 await DatabaseService().updateProduct(model,photos: photos, photosNames: photosNames);

                   await init();

               }

             },),
           ),

         ],),

      );//,// ProductView(),


   // );
  }



}
