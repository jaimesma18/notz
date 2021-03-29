import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_image/barcode_image.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:notz/services/barcodeServices/barcodeAbstract.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class AndroidFunctions extends BarcodeAbs{

 // AndroidFunctions();



@override
void downloadBarcode(String data,{double w,double h})async{

final image =  img.Image(300, 200);

// Fill it with a solid color (white)
img.fill(image, img.getColor(255, 255, 255));
// Draw the barcode

drawBarcode(image, Barcode.ean13(), data,width: 280,x: 10,font: img.arial_14,textPadding:2 );

var appDocDir = await getTemporaryDirectory();
String savePath = appDocDir.path + "/$data.png";
File(savePath)..writeAsBytesSync(img.encodePng(image));
print("Android");
final result = await ImageGallerySaver.saveFile(savePath);

}





}

BarcodeAbs getBarcodeAbs()=>AndroidFunctions();