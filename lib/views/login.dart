import 'package:flutter/material.dart';
import 'package:notz/services/auth.dart';



class Login extends StatefulWidget {


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  String email="";
  String password="";
  String error='';
  bool passwordVisible=false;

  @override
  void initState() {

    email='jaime.saad@lloydselectronica.com';
    password="test1234";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "INGRESA", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(children:[
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Correo",

                ),
                validator: (val)=>val.isEmpty||!val.contains('@')?'Ingresa un correo valido':null,
                onChanged: (val){
                  setState(() {
                    email=val;
                  });

                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Contraseña",
                    suffixIcon: IconButton(icon: passwordVisible?Icon(Icons.visibility_off,color: Colors.grey[600],):Icon(Icons.visibility,color: Colors.grey[600]),onPressed: (){
                      setState(() {
                        passwordVisible=!passwordVisible;
                      });
                    },)
                ),
                validator: (val)=>val.length<6?'Contrasena tiene 6 o mas caracteres':null,
                obscureText: !passwordVisible,
                onChanged: (val){
                  setState(() {
                    password=val;
                  });

                },
              ),
              SizedBox(height: 20,),
              FlatButton(child: Text("Ingresar",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),onPressed: ()async{
             //   if(_formKey.currentState.validate()) {
                  dynamic res = await _auth.signIn(email, password);
                  if (res == null) {
                    setState(() {
                      error="Correo y/o contrasena incorrectas";
                    });

                    print("sign in failed");
                  }
                  else {

                    error='';
                    print(res);
                  }
             //   }
              },),

              FlatButton(child: Text("Olvide mi contraseña",style: TextStyle(color: Colors.blue,fontSize: 14)),onPressed:(){
                Navigator.pushNamed(context, "/resetPassword");

              }),
              SizedBox(height: 14,),
              Text(error,style: TextStyle(color: Colors.red,fontSize: 14),),
              error==""?Container():SizedBox(height: 14,),
              



            ]),

          ),
        ),
      ),
    );
  }


}
