import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_image/barcode_image.dart';
import 'dart:io';
import 'package:image/image.dart' as img;




class BCode extends StatefulWidget {
  String upc;
  bool edit;
  BCode({this.upc,this.edit});
  @override
  _BCodeState createState() => _BCodeState();
}

class _BCodeState extends State<BCode> {
  @override

  void downloadBarcode(String data,double w,double h){


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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("UPC",style: TextStyle(fontWeight: FontWeight.bold),),
                  FlatButton(child:Text(widget.upc),onPressed: (){Clipboard.setData(new ClipboardData(text:widget.upc));},),
                ],
              ),
              SizedBox(height: 10,),
              widget.upc!=null?Container(width: 300,child: BarcodeWidget(data: widget.upc, barcode: Barcode.ean13())):Container(),
            ],
          ),
        ),
      );

  }
}
