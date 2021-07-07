//import 'dart:html';

//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';

class DragAndDrop extends StatefulWidget {
  @override
  double width;
  double height;
  Function onDrop;
  Function sizeExceeds;
  Function wrongFormat;
  String instructions;
  List<String> extensions;
  int maxKb;



  DragAndDrop(
      {this.width,
     this.height,
      this.onDrop,
     this.instructions,
        this.extensions,
        this.maxKb,
        this.sizeExceeds,
        this.wrongFormat,
   });
  _DragDropState createState() => _DragDropState();
}

class _DragDropState extends State<DragAndDrop> {
  bool loaded = false;
  DropzoneViewController controller;
  Color bordercolor = Color(0xFFCBD2D6);


  void wrongFormat(dynamic val) {
    widget.wrongFormat(val);
    setState(() {
      loaded = false;
    });
  }

  void sizeExceeds(dynamic val) {
    widget.sizeExceeds(val);
    setState(() {
      //bordercolor = Colors.red;
      loaded = false;
    });
  }

  void fun(dynamic val) {
    widget.onDrop(val);
    setState(() {
      bordercolor = Colors.blue;
      loaded = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.Rect,
      radius: Radius.circular(4),
      strokeWidth: 1,
      dashPattern: [3, 3],
      color: bordercolor,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(color: Color(0xFFF9FAFC)),
        child: Stack(
          children: [
            DropzoneView(


              onCreated: (ctrl) { controller = ctrl;
             },
              onHover: (){
                setState(() {
                  bordercolor=Colors.blue;

                });

              },
              onLeave:(){
                setState(() {
                  bordercolor = Color(0xFFCBD2D6);
                });

              } ,
              onError: (ev) => setState(() => bordercolor = Colors.red),
              onDrop: (val) {
                Map m=new Map();

                if(widget.extensions!=null) {
                  if (widget.extensions.isNotEmpty) {
                   controller.getFilename(val).then((value) {
                     if(!widget.extensions.contains(value.substring(value.length-3))){
                       wrongFormat(value);
                     }
                     else{
                       controller.getFileSize(val).then((value) {
                         if (value / 1000 > widget.maxKb) {
                           sizeExceeds(val.name);
                         }
                         else {
                           controller.getFileData(val).then((value) {
                             m[val.name] = value;
                             fun(m);
                           });
                         }
                       });
                     }

                   });

                  }
                }
                //controller.getFileData(val).then((value) => fun(value));
              },
            ),
            Column(children: [
              Expanded(flex: 2, child: Container()),
              Expanded(
                  flex: 4,
                  child: Icon(Icons.camera_alt_outlined,size: 48,color: Colors.blue,)),
              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 4,
                child: Container(
                  width: 195,
                  child: Text(
                    widget.instructions,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.8,
                        color: Color(0xFFB6BFCC)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    width: 180,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(2)),
                    child: SizedBox.expand(
                        child: TextButton(
                      child: Text(
                        "Agregar desde pc",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            height: 1.1,
                            fontWeight: FontWeight.w500),
                      ),
                      onPressed: () async {
                        FilePickerResult result = await FilePicker.platform
                            .pickFiles(type: FileType.custom,
                                allowedExtensions: widget.extensions ?? ["jpg","png","gif"]);

                        if(result!=null) {
                          if (widget.extensions != null) {
                            if (widget.extensions.isNotEmpty) {
                              if (!widget.extensions.contains(
                                  result.files.single.name.substring(
                                      result.files.single.name.length - 3))) {
                                  wrongFormat(result.files.single.name);
                              }
                              else {
                                if (result.files.single.size / 1000 >
                                    widget.maxKb) {
                                    sizeExceeds(result.files.single.name);

                                  loaded = false;
                                }
                                else {
                                  final bytes = result.files.single.bytes;
                                  Map m = new Map();
                                  m[result.files.single.name] = bytes;
                                  fun(m);
                                }
                              }
                            }
                          }
                        }
                      },
                    )),
                  )),
              Expanded(flex: 1, child: Container()),

            ])
          ],
        ),
      ),
    );
  }
}
