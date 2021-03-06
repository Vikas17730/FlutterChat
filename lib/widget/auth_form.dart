import 'package:flutter/material.dart';
import 'package:flutterchat/widget/pickers/ImagePreview.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitfn, this._IsLoading);

  final void Function(String emailId, String userId, String password,
      File image, bool IsLogin, BuildContext context) submitfn;
  final bool _IsLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _IsLogin = true;
  String emailId = '';
  String userId = '';
  String password = '';
  File _userImage;
  void _pickedImage(File Image) {
    _userImage = Image;
  }

  void _submit() {
    final isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImage == null && !_IsLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please Pick an image."),
          backgroundColor: Theme.of(context).errorColor));
      return;
    }
    if (isValid) {
      _formkey.currentState.save();
      widget.submitfn(emailId.trim(), userId.trim(), password.trim(),
          _userImage, _IsLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.orange.shade100,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_IsLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey("Email"),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return "Please Enter a valid Email Address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(label: Text("Email address")),
                    onSaved: (value) {
                      emailId = value;
                    },
                  ),
                  if (!_IsLogin)
                    TextFormField(
                      key: ValueKey('userId'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return "User Name must Contains 4 characters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "User Name"),
                      onSaved: (value) {
                        userId = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return "Password Must atleast 6 characters Long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget._IsLoading) CircularProgressIndicator(),
                  if (!widget._IsLoading)
                    RaisedButton(
                      onPressed: _submit,
                      child: Text(_IsLogin ? "Login" : "SignUp"),
                    ),
                  if (!widget._IsLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _IsLogin = !_IsLogin;
                        });
                      },
                      child: Text(_IsLogin
                          ? "Create New Account"
                          : "I already have a account"),
                      textColor: Theme.of(context).primaryColor,
                    ),
                ],
              )),
        )),
      ),
    );
  }
}
