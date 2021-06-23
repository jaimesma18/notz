import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:notz/services/storageManager.dart';


class Carousel extends StatefulWidget {
  List images;
  String model;

  Carousel({this.images,this.model});
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _current = 0;
  List imgSlider;
  final CarouselController _controller = CarouselController();
  //List<Uint8List>bytes=[];
  List<Uint8List> bytes=[];
  bool imageLoaded=false;

 // List<String> urls=[];

  @override
  void initState() {
    super.initState();

    init().whenComplete(() {
      if(this.mounted) {
        setState(() {
          imageLoaded = bytes.isNotEmpty;
        });
      }
    });
   // urls=widget.images;
   // init(urls);


  }

  Future init()async{



   // urls=await getFirebaseUrls(model);
   // imgSlider=mapImagesFromUrl(urls);

    //Si se activa esto, cambiar urls por bytes en Scaffold
   // List<Uint8List> 
    
    bytes=await getFirebaseImages();

    imgSlider=mapImagesFromBytes(bytes);

  
   /* if(this.mounted) {
      setState(() {
        imageLoaded = true;
      });
    }*/



  }


  List mapImagesFromBytes(List<Uint8List> imgList){
    //print("Image from bytes");
    final List<Widget> imageSliders = imgList.map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.memory(item, fit: BoxFit.cover, width: 1000.0),

              ],
            )
        ),
      ),
    )).toList();
    return imageSliders;
  }
 /* List mapImagesFromUrl(List imgList){
    final List<Widget> imageSliders = imgList.map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item, fit: BoxFit.cover, width: 1000.0),

              ],
            )
        ),
      ),
    )).toList();
    return imageSliders;
  }*/

  Future<List<String>> getFirebaseUrls(String model) async{
    List<String> urls=[];
    final firebase_storage.Reference storageRef = await
    firebase_storage.FirebaseStorage.instance.ref("productos/$model");


    await storageRef.listAll().then((result)async {
      for(var x in result.items){

         urls.add(await x.getDownloadURL());
      }

    });

    return urls;
  }



  Future<List<Uint8List>> getFirebaseImages() async{

    Uint8List byte;

    List<Uint8List> l=[];
    print(widget.images);
    for(var x in widget.images){
      if(widget.images!=null&&x!=null) {
        byte = await StorageManager().downloadFile(
            "productos/${widget.model}/$x");
      }
     /* else{
        byte=(await rootBundle.load('assets/images/logo_Lloyds.jpg'))
            .buffer
            .asUint8List();
      }
      if(byte==null){
        (await rootBundle.load('assets/images/logo_Lloyds.jpg'))
            .buffer
            .asUint8List();
      }*/

      l.add(byte);
     // l.add(await StorageManager().downloadFile("productos/${widget.model}/$x"));
    }

    return l;
  }


  @override
  Widget build(BuildContext context) {



    return Container(height: 400,

      child: imageLoaded?Stack(
          children: [
            CarouselSlider(
              items: imgSlider,carouselController: _controller,
              options: CarouselOptions(viewportFraction: .9,
                // enlargeCenterPage: true,
                  aspectRatio: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }
              ),
            ),
            Positioned.fill(bottom: 16,
              child: Align(alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(flex: 1,child: SizedBox(),),
                    Expanded(flex:2,
                      child: FlatButton(
                        onPressed: () => _controller.previousPage(),
                        child: Text('←'),
                      ),
                    ),
                    Expanded(flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children:
                        bytes.map((x) {
                          int index = bytes.indexOf(x);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.fromLTRB(2, 0, 2, 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(flex: 2,
                      child: FlatButton(
                        onPressed: () => _controller.nextPage(),
                        child: Text('→'),
                      ),
                    ),
                    Expanded(flex: 1,child: SizedBox(),),
                  ],
                ),
              ),
            ),
          ]
      ):Container(
        child: Image.asset('assets/images/logo_Lloyds.jpg'),
      ),
    );



  }
}
