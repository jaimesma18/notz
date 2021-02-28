import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:notz/services/auth.dart';
import 'package:notz/services/db.dart';
import 'package:notz/classes/User.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:notz/widgets/square.dart';
import 'package:notz/classes/Product.dart';
import 'package:notz/views/tester.dart';


class Home extends StatefulWidget {
  @override

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth=AuthService();
  TextEditingController search= new TextEditingController();
  //int userManagement=1;
  bool showUserManagement=false;
  //bool isOwner=false;
  int maxLevel=0;
  bool loaded=false;
  User user=new User();
  Map<String,Product> products=new Map<String,Product>();


  @override
  void initState() {
    super.initState();

  init().whenComplete(() => print(showUserManagement));


  }

  Future init()async{

    user=await DatabaseService().getUser(_auth.userInfo().email);
    Map m=user.permissions;

      for(var x in m.keys) {
        if (m[x] > maxLevel) {
          maxLevel = m[x];
        }
      }
      if(maxLevel>=3){
        showUserManagement=true;
      }
      /*  if(m[x]>=3){
          showUserManagement=true;
          if(m[x]>=4){
            isOwner=true;
          }

        }*/

      setState(() {
        loaded = true;
      });



    //userManagement=await _auth.userManagement();



  }

  Future query(String query)async{
    products.clear();
    DatabaseService().queryProducts(query.toLowerCase()).then((value){

      List<Product> prods=value;
      setState(() {
        for(var x in prods){

          products[x.model]=x;
        }

      });

    });



  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    bool isMobile;
    deviceWidth>=768?isMobile=false:isMobile=true;


 /* if(userManagement!=null){
    Future.delayed(Duration.zero, () {
      Navigator.pushNamed(context, "/productView");
    });
  }*/
    /* Future.delayed(Duration.zero, () {
      Navigator.pushNamed(context, "/productView");
    });*/




    return !loaded?Container():Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(title: TextBox(),
        actions: [

          IconButton(icon: Icon(Icons.upload_sharp,size: 26),onPressed: ()async{
           Navigator.pushNamed(context, "/tester");

          },),

          showUserManagement?IconButton(icon:Icon(Icons.supervised_user_circle_rounded,size: 26),onPressed: ()async{
            Map m=new Map();
            m['user']=user;
            //m['isOwner']=isOwner;
            m['maxLevel']=maxLevel;
          Navigator.pushNamed(context, '/userManagement',arguments:m );

          },):Container(),

          IconButton(icon: Icon(Icons.logout,size: 26),onPressed: ()async{
            await _auth.signOut();

          },),
        ],),
      body://SingleChildScrollView(
        //child:
    //  ImageUploader(),
       //
        GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 5,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(products.keys.length, (index) {

            Function f=(String val){
              if(val!=null) {
                search.text = val;
                query(val);
              }
            };
            return Center(
              child: Square(products[products.keys.toList()[index]],f: f,),
            );
          }),
        ),





      );//,// ProductView(),


   // );
  }

  Widget TextBox2(){
    return Align(alignment: Alignment.centerLeft,
      child: Container(
          decoration: new BoxDecoration(
           border: Border.all(color: Colors.white,width: 2),
              borderRadius: BorderRadius.all(Radius.circular(14))
      ),
          width: 600,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex:2,child: IconButton(icon:Icon(Icons.search),onPressed: (){
                print(search.text);
              },)),
               Expanded(flex: 20,
                 child: TextField(autofocus: true,

                     decoration: InputDecoration.collapsed(
                      hintStyle: new TextStyle(letterSpacing:.6,wordSpacing: 1,color: Colors.white,fontSize: 16),
                      hintText: "Buscar modelo, UPC o palabras clave",
                     // fillColor: Colors.white70),
                  )),
               ),

            ],
          ),
        ),
      ),
    );
  }

  Widget TextBox(){
    return Container(
        //color: bgColor,
        child: Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex:2,child: IconButton(icon:Icon(Icons.search),onPressed: (){
             // print(search.text);
            },)),
            Expanded(flex: 50,
              child: TextField(//autofocus: true,
                onSubmitted: (val)async{


                    if(val!=null) {
                      await query(val);
                    }




                },
                controller:search,cursorColor:Colors.white,style:TextStyle(color: Colors.white, fontSize: 18),onChanged: (val){
                  setState(() {

                  });
                },
                decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Buscar modelo, UPC o palabras clave',hintStyle: TextStyle(letterSpacing:.6,wordSpacing: 1,color: Colors.white,fontSize: 16)),
              ),
            ),
          ],
        )
    );
  }


}
