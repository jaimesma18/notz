import 'package:flutter/material.dart';
//import 'package:universal_html/html.dart';
//import 'package:multi_select_flutter/multi_select_flutter.dart' as multiSelect;
//import 'package:multi_select_flutter/util/multi_select_item.dart';

class ViewWidget extends StatefulWidget {

  String field;
  dynamic value;
  int valid;
  String type;
 
  ViewWidget({this.field,this.value,this.valid,this.type});
  @override
  _ViewWidgetState createState() => _ViewWidgetState();
}

class _ViewWidgetState extends State<ViewWidget> {

  Icon icon;
  String string;
  Color c;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {

    return wrapCard();

  }

  Widget wrapCard(){
    return Container(width: 100,height: 80,
      child: Card(elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side:BorderSide(color: widget.valid==1?Colors.blue:widget.valid==0?Colors.amber[600]:Colors.red,width: 2) ),
        child: Container(width: 240,
          child: Stack(
            children: [
              Padding(
                padding:  EdgeInsets.fromLTRB(0,15,0,0),
                child: createCard(),
              ),
              Positioned(left:10,top: 4,child: FittedBox(  fit: BoxFit.fitWidth,child: Text(widget.field,style: TextStyle(fontSize: 12,color: Colors.blue),))),
            ],
          ),
        ),
      ),
    );
  }

  Widget createCard(){

    dynamic val=widget.value;
    if (val==null){
      val="";
    }
    if(val==true){
      val="Sí";
    }
    if(val==false){
      val="No";
    }

    val='$val';

    /*if( widget.type.endsWith("]")) {
      List<multiSelect.MultiSelectItem> l=[];
      List temp=widget.value.split(';');
      for(var x in temp){
        l.add(MultiSelectItem(x,x));
      }

      return Container(
        child: Center(
          child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 26),
            child: (
                multiSelect.MultiSelectChipDisplay(
                  alignment: Alignment.center,
                  textStyle: TextStyle(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.bold),

                  //decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                  //chipColor: Colors.green,
                  colorator: (index){
                      return Colors.lightBlue[50];

                  },
                  scroll: true,
                  onTap: (val){
                    print(val);
                  },
                  items:l,// widget.value.split(";").map((e) => MultiSelectItem(e, e)).toList(),

                )),
          ),
        ),
      );
    }*/
   // else{
      return (
          Center(child: SelectableText(val.replaceAll(";"," ; "),style: TextStyle(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)));
    //}

    }
  }


