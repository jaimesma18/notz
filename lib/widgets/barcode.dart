import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_image/barcode_image.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:notz/classes/Product.dart';
import 'package:notz/services/barcodeServices/barcodeAbstract.dart';
import 'package:notz/services/db.dart';



class BCode extends StatefulWidget {
  String model;
  String upc;
  bool edit;
  bool mobile;
  BCode({this.model,this.upc,this.edit,this.mobile});
  @override
  _BCodeState createState() => _BCodeState();
}

class _BCodeState extends State<BCode> {
  @override
  String upc;
  bool editing=false;
  bool downloading=false;
  TextEditingController controller=new TextEditingController();
  CrossAxisAlignment _crossAlignment=CrossAxisAlignment.start;
  MainAxisAlignment _mainAlignment=MainAxisAlignment.start;


  @override
  void initState() {
    super.initState();
    upc=widget.upc??"";
    controller.text=upc;
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

  Future<bool> upcExists(String upc)async{
    bool res=false;
    if(upc!=null&&upc.isNotEmpty) {
      Product product=await DatabaseService().productFromUPC(upc);
      if(product!=null){
        res=true;
      }
    }
    return res;
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
                  SizedBox(width: 6,),
                  !editing?FlatButton(child:Text(upc),onPressed: (){Clipboard.setData(new ClipboardData(text:upc));},padding: EdgeInsets.zero,):
                  Container(child: TextField(controller: controller,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),width: 120,),
                  SizedBox(width: 10,),
                  widget.edit?FlatButton.icon(icon:Icon(!editing?Icons.edit:Icons.check_circle_outline,color:!editing?Colors.blue:Colors.green),label: Text(!editing?"Editar":"Confirmar",style: TextStyle(color: !editing?Colors.blue:Colors.green,),),onPressed: ()async{
                    // addState();
                    print(editing);

                      if(editing) {
                        if(upc==controller.text){
                          setState(() {
                            editing = !editing;
                          });

                        }
                        else{
                          bool exists=await upcExists(controller.text);
                          if (!exists && controller.text.length == 13 && Barcode
                              .ean13().isValid(controller.text)) {
                            setState(() {
                              upc = controller.text;
                            });

                            await DatabaseService().updateProduct(widget.model,upc:upc);
                            setState(() {
                              editing = !editing;
                            });


                          }
                        }

                      }
                      else{
                        setState(() {
                          editing = !editing;
                        });

                      }

                  },):Container(),
                ],
              ),
              SizedBox(height: 10,),
              upc!=null?Container(width: 300,child: BarcodeWidget(data: upc, barcode: Barcode.ean13())):Container(),
            kIsWeb||Platform.isAndroid?IconButton(icon:Icon(downloading?Icons.download_done_outlined:Icons.download_sharp,color:downloading?Colors.green:Colors.blue ,),onPressed: ()async{
              setState(() {
               downloading=true;
              });
              downloadBarcodes(upc);
              await Future.delayed(Duration(seconds: 3));
              setState(() {
                downloading=false;
              });
            })
                :Container(),
            ],
          ),
        ),
      );

  }
}
