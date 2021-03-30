import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseAuth _auth2=FirebaseAuth.instance;



  Stream<User> get user{
    return _auth.authStateChanges();

  }


  User userInfo(){
    return _auth.currentUser;
  }

  Future<Map>permissions()async{
    Map res;
    await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser.email)
        .get().then((value)
    {
      res= value.data()['permissions'];
    });


    return res;

  }


 /* Future<int>userManagement()async{
    int res=-1;
    await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser.email)
    .get().then((value)
    {
      res= value.data()['userManagement'];
    });



    return res;

  }*/

  Future signIn (String email,String password)async{

    try{
      UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user=result.user;
      print(user);

      return user;

    }
    catch(e){
      print(e.toString());
      return null;
    }

  }



  Future signUp(String username,String pass)async{
    try{


      UserCredential result=await _auth2.createUserWithEmailAndPassword(email: username, password: pass);
      User user=result.user;
      user.sendEmailVerification();
      _auth2.signOut();

      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }


  }
  Future resetPassword(String username)async{
    try{

      print(username);
      await _auth.sendPasswordResetEmail(email: username);
      return 1;
    }
    catch(e){
      print(e.toString());
      return null;
    }

  }

  Future signOut ()async {

    try {
      return await _auth.signOut();
    }


    catch (e) {
      print(e.toString());
      return null;
    }


  }

  Future sendVerificationEmail()async{
    try{
      _auth.currentUser.sendEmailVerification();

      //return 1;
    }
    catch(e){
      print(e.toString());
      return null;
    }

  }





}



