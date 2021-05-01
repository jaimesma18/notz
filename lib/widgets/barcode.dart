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
  String originalUpc;
  bool editing=false;
  bool downloading=false;
  TextEditingController controller=new TextEditingController();
  CrossAxisAlignment _crossAlignment=CrossAxisAlignment.start;
  MainAxisAlignment _mainAlignment=MainAxisAlignment.start;
  double _padding=40;
  String errorMessage="";


  @override
  void initState() {
    super.initState();
    upc=widget.upc??"";
    originalUpc=upc;
    controller.text=upc;
    if(widget.mobile!=null){
      if(widget.mobile){
        _crossAlignment=CrossAxisAlignment.center;
        _mainAlignment=MainAxisAlignment.center;
        _padding=10;

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
    print("Error Message:");
    print(errorMessage);
    return
      Stack(
        children: [
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
                    SizedBox(width: _padding,),
                    widget.edit?FlatButton.icon(icon:Icon(!editing?Icons.edit:Icons.check_circle_outline,color:!editing?Colors.blue:Colors.green),label: Text(!editing?"Editar":"Confirmar",style: TextStyle(color: !editing?Colors.blue:Colors.green,),),onPressed: ()async{
                      // addState();

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

                              await DatabaseService().updateProduct(widget.model,upc:upc,before:originalUpc);
                              originalUpc=upc;
                              setState(() {
                                editing = !editing;
                              });


                            }
                            else{
                              if(exists){
                                setState(() {
                                  errorMessage='UPC Ya Registrado';
                                });
                              }
                              else{
                                setState(() {
                                  errorMessage='UPC Incorrecto';
                                });

                              }
                              await Future.delayed(Duration(seconds: 3));
                              setState(() {
                                errorMessage="";
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
              kIsWeb||Platform.isAndroid?Padding(
                padding: widget.mobile?EdgeInsets.all(0): EdgeInsets.fromLTRB(130, 10, 0, 0),
                child: IconButton(icon:Icon(downloading?Icons.download_done_outlined:Icons.download_sharp,color:downloading?Colors.green:Colors.blue ,),onPressed: ()async{
                  setState(() {
                   downloading=true;
                  });
                  downloadBarcodes(upc);
                  await Future.delayed(Duration(seconds: 3));
                  setState(() {
                    downloading=false;
                  });
                }),
              )
                  :Container(),
              ],
            ),
          ),
        ),
          errorMessage!=""?
              Positioned(left:0,top: 0,child: Container(width: 300,height: 30,
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color:Color.fromRGBO(0, 0, 0, 0.36),
                      offset: Offset(0,6),blurRadius: 16,spreadRadius: 0)],
                      color: Colors.red,border: Border.all(color: Colors.red[400],),
                      borderRadius: BorderRadius.circular(8)),
                  child:Center(child: Text(errorMessage,textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 16,letterSpacing: .6),)))):
          Container(),
    ]
      );

  }
}
