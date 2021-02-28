import 'package:flutter/material.dart';
import 'package:notz/services/auth.dart';
import 'package:notz/views/home.dart';
import 'package:notz/views/login.dart';
import 'package:notz/views/productView.dart';
import 'package:notz/views/passwordReset.dart';
import 'package:notz/views/uploadProduct.dart';
import 'package:notz/views/users.dart';
import 'wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notz/views/tester.dart';




void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(

  ));

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        routes:{



          '/userManagement':(context)=>Users(),
          '/home':(context)=>Home(),
          '/productView':(context)=>ProductView(),
          '/login':(context)=>Login(),
          '/resetPassword':(context)=>PasswordReset(),
          '/upload':(context)=>UploadProduct(),
          '/tester':(context)=>Tester(),


        },
        home: Wrapper(),debugShowCheckedModeBanner: false,
      ),
    );
  }


}
