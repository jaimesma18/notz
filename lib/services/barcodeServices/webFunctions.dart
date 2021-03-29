//import 'package:universal_html/controller.dart';
import 'package:notz/services/barcodeServices/barcodeAbstract.dart';
import 'package:universal_html/html.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_image/barcode_image.dart';

class WebFunctions extends BarcodeAbs{

  //WebFunctions();



//void downlooadBarcode(String data,{double w,double h})=>downloadBarcodeWeb(data,w:w,h:h);
@override
void downloadBarcode(String data,{double w,double h})async{

  final image =  img.Image(300, 200);

// Fill it with a solid color (white)
  img.fill(image, img.getColor(255, 255, 255));
// Draw the barcode

  drawBarcode(image, Barcode.ean13(), data,width: 280,x: 10,font: img.arial_14,textPadding:2 );


    print("Web");
    final _base64 = base64Encode(img.encodePng(image));
    final anchor =
    AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
      ..target = 'blank';
    // add the name
    if ("$data.png" != null) {
      anchor.download = "$data.png";
    }
    // trigger download
    document.body.append(anchor);
    anchor.click();
    anchor.remove();
    return;



  }





}

BarcodeAbs getBarcodeAbs()=>WebFunctions();