import 'package:flutter/material.dart';
import 'package:notz/widgets/imageUploader2.dart';


class ImageEditor extends StatefulWidget {
  @override
  _ImageEditorState createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  Map data=new Map();
  @override
  Widget build(BuildContext context) {
    if(data!=null) {
      data = ModalRoute
          .of(context)
          .settings
          .arguments;
    }
    else{
      Navigator.pop(context);
    }
    return Scaffold(

      appBar: AppBar(title: Text("Modificar Imagenes"),),
      body: Center(child: ImageUploader(model: data['model'],)),


    );
  }
}
