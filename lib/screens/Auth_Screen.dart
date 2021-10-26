import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterchat/widget/auth_form.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _IsLoading = false;
  void _submitFormData(String emailId, String userId, String password,
      File image, bool IsLogin, BuildContext ctx) async {
    try {
      if (IsLogin) {
        setState(() {
          _IsLoading = true;
        });
        AuthResult authResult;
        authResult = await _auth.signInWithEmailAndPassword(
            email: emailId, password: password);
      } else {
        AuthResult authResult;
        authResult = await _auth.createUserWithEmailAndPassword(
            email: emailId, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(image).onComplete;
        final url = await ref.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'userName': userId,
          'email': emailId,
          'Image_url': url,
        });
      }
    } on PlatformException catch (err) {
      var errmessage = "An error Ocurred, Please check your credentials";
      if (err.message != null) {
        errmessage = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(errmessage),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _IsLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitFormData, _IsLoading),
    );
  }
}
