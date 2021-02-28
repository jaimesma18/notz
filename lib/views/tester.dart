import 'package:flutter/material.dart';
import 'package:notz/widgets/imageUploader.dart';


class Tester extends StatefulWidget {
  @override
  _TesterState createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(title: Text("Tester"),),
      body: ImageUploader(),


    );
  }
}
