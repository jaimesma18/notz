import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_image/barcode_image.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
//import 'package:path_provider/path_provider.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:notz/services/barcodeServices/androidFunctions.dart';
import 'package:notz/services/barcodeServices/barcodeStub.dart';
import 'package:notz/services/barcodeServices/barcodeAbstract.dart';
//import 'package:notz/services/webFunctions.dart';
//import 'package:notz/services/androidFunctions.dart';
//import 'package:notz/services/webFunctions.dart' as webServices if (dart.library.js) 'package:notz/services/androidFunctions.dart';
//import 'package:notz/services/barcodeStub.dart' if (dart.library.js)'package:notz/services/webFunctions.dart' as webServices;




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
  String upc;
  CrossAxisAlignment _crossAlignment=CrossAxisAlignment.start;
  MainAxisAlignment _mainAlignment=MainAxisAlignment.start;


  @override
  void initState() {
    super.initState();
    upc=widget.upc;

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


  void downloadBarcodes(String data,{double w,double h})async{

   BarcodeAbs.instance.downloadBarcode(data);
  
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
                  FlatButton(child:Text(upc),onPressed: (){Clipboard.setData(new ClipboardData(text:upc));},padding: EdgeInsets.zero,),
                ],
              ),
              SizedBox(height: 10,),
              upc!=null?Container(width: 300,child: BarcodeWidget(data: upc, barcode: Barcode.ean13())):Container(),
            kIsWeb||Platform.isAndroid?IconButton(icon:Icon(Icons.download_sharp),onPressed: ()=>downloadBarcodes(upc)):Container(),
            ],
          ),
        ),
      );

  }
}
