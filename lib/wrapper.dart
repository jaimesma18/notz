import 'package:flutter/material.dart';
import 'package:notz/views/home.dart';
import 'package:notz/views/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notz/views/productView.dart';

class Wrapper extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);

    print(user);
    return user==null?Login():Home();//ProductView();
  }


}

