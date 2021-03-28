import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_image/barcode_image.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:convert';





class BCode extends StatefulWidget {
  String upc;
  bool edit;
  bool mobile;
  BCode({this.upc,this.edit,this.mobile});
  @override
  _BCodeState createState() => _BCodeState();
}

class _BCodeState extends State<BCode> {
  @override
  CrossAxisAlignment _crossAlignment=CrossAxisAlignment.start;
  MainAxisAlignment _mainAlignment=MainAxisAlignment.start;


  @override
  void initState() {
    super.initState();

    if(widget.mobile!=null){
      if(widget.mobile){
        _crossAlignment=CrossAxisAlignment.center;
        _mainAlignment=MainAxisAlignment.center;

      }
    }

  }
  static Future<img.BitmapFont> loadAssetFont(String asset) {
    final Completer<img.BitmapFont> completer = Completer<img.BitmapFont>();

    rootBundle.load(asset).then((ByteData bd) {
      completer.complete(img.BitmapFont.fromZip(bd.buffer.asUint8List()));
    }).catchError((dynamic exception, StackTrace stackTrace) {
      completer.complete(null);
    });

    return completer.future;
  }


  void downloadBarcode(String data,{double w,double h})async{

    final image =  img.Image(300, 200);

// Fill it with a solid color (white)
    img.fill(image, img.getColor(255, 255, 255));
// Draw the barcode

    drawBarcode(image, Barcode.ean13(), data,width: 280,x: 10,font: img.arial_14,textPadding:2 );




    if(kIsWeb){
      print("Web");
      final _base64 = base64Encode(img.encodePng(image));
      final anchor =
      html.AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
        ..target = 'blank';
      // add the name
      if ("$data.png" != null) {
        anchor.download = "$data.png";
      }
      // trigger download
      html.document.body.append(anchor);
      anchor.click();
      anchor.remove();
      return;
    }

    else{
      if(Platform.isAndroid) {
        var appDocDir = await getTemporaryDirectory();
        String savePath = appDocDir.path + "/$data.png";
        File(savePath)..writeAsBytesSync(img.encodePng(image));
        print("Android");
        final result = await ImageGallerySaver.saveFile(savePath);
      }
    }


    //File(myImagePath+'/$data.png')..writeAsBytesSync(img.encodePng(image));



  }
  void buildBarcode(
      Barcode bc,
      String data, {
        String filename,
        double width,
        double height,
        double fontHeight,
      }) {
    /// Create the Barcode
    final svg = bc.toSvg(
      data,
      width: width ?? 200,
      height: height ?? 80,
      fontHeight: fontHeight,
    );

    // Save the image
    filename ??= bc.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
    File('$filename.svg').writeAsStringSync(svg);
  }

  Widget build(BuildContext context) {
    return
      Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,20,0,0),
          child: Column(crossAxisAlignment: _crossAlignment,
            children: [
              Row(mainAxisAlignment: _mainAlignment,
                children: [
                  Text("UPC: ",style: TextStyle(fontWeight: FontWeight.bold),),
                  FlatButton(child:Text(widget.upc),onPressed: (){Clipboard.setData(new ClipboardData(text:widget.upc));},padding: EdgeInsets.zero,),
                ],
              ),
              SizedBox(height: 10,),
              widget.upc!=null?Container(width: 300,child: BarcodeWidget(data: widget.upc, barcode: Barcode.ean13())):Container(),
            kIsWeb||Platform.isAndroid?IconButton(icon:Icon(Icons.download_sharp),onPressed: ()=>downloadBarcode(widget.upc)):Container(),
            ],
          ),
        ),
      );

  }
}
