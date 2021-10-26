import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickfn;
  UserImagePicker(this.imagePickfn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File PickedImage;
  void _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 50,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      PickedImage = imageFile;
    });
    widget.imagePickfn(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: PickedImage == null ? null : FileImage(PickedImage),
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text(
            'Camera',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: _takePicture,
        ),
      ],
    );
  }
}
