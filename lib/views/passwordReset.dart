import 'package:flutter/material.dart';
import 'package:notz/services/auth.dart';


class PasswordReset extends StatefulWidget {
 

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _formKey=GlobalKey<FormState>();
  final AuthService _auth=AuthService();
  String email="";
  bool validEmail=false;



  @override
  void initState() {
    super.initState();

   // trans['confirmPassword']=new Map<String,String>();
    //trans['confirmPassword']['en']="Confirm Password";
   // trans['confirmPassword']['sp']="Reingresa Contraseña";
  }

    @override
  Widget build(BuildContext context) {

      _showMaterialDialog(String message) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
             // title: new Text("Material Dialog"),
              content: new Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
      }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OLVIDE MI CONTRASENA", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(children:[
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                    helperMaxLines: 3,
                    helperText: "El link para restablecer tu contraseña se enviará a la dirección de correo electrónico"
                    //hintText: "Correo"
                  ),
                  validator: (val)=>val.isEmpty||!val.contains('@')?'Ingresa un correo valido':null,
                  onChanged: (val){
                    setState(() {
                      if(val.isEmpty||!val.contains('@')){
                        validEmail=false;
                      }
                      else{
                        validEmail=true;
                      }
                      email=val;
                    });

                  },
                ),

                SizedBox(height: 20,),
                Opacity(opacity: validEmail?1:.3,
                  child: RaisedButton(color:Colors.blue,child: Text("ENVIAR",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),onPressed: ()async{
                    print(validEmail);
                    if(validEmail){
                    if(_formKey.currentState.validate()) {
                      dynamic res = await _auth.resetPassword(email);
                      String message="";
                      if (res == null) {
                      //  setState(() {
                          message="Ingresa un correo valido";
                      //  });

                        print("sign in failed");
                      }
                      else {
                     //   setState(() {
                        message="Correo enviado a $email. Si no encuentra el correo, revise su bandeja de Spam";
                       // });
                        print(res);

                      }
                     _showMaterialDialog(message);
                    }}
                  },),
                ),



              ]),
            ),

            ),
          ),
      ),
      );
  }


}
