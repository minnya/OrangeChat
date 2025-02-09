import 'dart:io';

import 'package:orange_chat/components/commons/photo_preview_round.dart';
import 'package:flutter/material.dart';

import '../../helpers/image_picker_helper.dart';
import '../../models/supabase/edit_users.dart';


class InputImage extends StatefulWidget {
  final EditUserModel editUserModel;

  const InputImage({super.key, required this.editUserModel});

  @override
  State<InputImage> createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {

  @override
  Widget build(BuildContext context) {

    Future<void> setImage() async{
      File? uploadFile = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return InputImageSource();
          });
      setState(() {
        widget.editUserModel.uploadFile = uploadFile;
      });
    }

    return Column(
      children: [
        SizedBox(
          width: 100,
            height: 100,
            child: PhotoPreviewRound(imageProvider: widget.editUserModel.getImage())
        ),
        TextButton(
            onPressed: () {
              setImage();
            },
            child: Text("Edit profile picture")),
      ],
    );
  }
}

class InputImageSource extends StatelessWidget {
  const InputImageSource({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () async {
            File? image = await ImagePickerHelper().getImageFromCamera();
            Navigator.pop(context, image);
          },
          child: const Text('Take photo'),
        ),
        SimpleDialogOption(
          onPressed: () async {
            File? image = await ImagePickerHelper().getImageFromGallery();
            Navigator.pop(context, image);
          },
          child: const Text('Choose existing photo'),
        ),
      ],
    );
  }
}
