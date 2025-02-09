import 'dart:io';

import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/components/commons/photo_preview_round.dart';
import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/helpers/image_picker_helper.dart';
import 'package:orange_chat/helpers/supabase/post_model_helper.dart';
import 'package:orange_chat/helpers/supabase/storage_helper.dart';
import 'package:flutter/material.dart';


class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _textEditController = TextEditingController();
  late FocusNode _focusNode;
  final List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        bool result = await showOKCancelDialog(context: context, message: "Do you really exit?");
        return result;
      },
      child: SizedBox(
        width: 600,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () async{
                if(_textEditController.text!="") {
                  bool result = await showOKCancelDialog(
                      context: context, message: "Do you really exit?");
                  if (result == false) return;
                }
                Navigator.pop(context);
              },
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if(_textEditController.text.isEmpty && _images.isEmpty) return;
                    List<String> imageUrls = [];
                    for(int i=0;i<_images.length;i++){
                      String imageUrl = await StorageHelper()
                          .uploadFile(file: _images[i], context: context);
                      imageUrls.add(imageUrl);
                    }
                    final result = await PostModelHelper(context: context).putPost(
                      message: _textEditController.text,
                      imageUrls: imageUrls,
                    );
                    if (result == true && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Post", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: _textEditController.text.isEmpty && _images.isEmpty ? Colors.grey:Theme.of(context).colorScheme.primary,),)
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          focusNode: _focusNode,
                          autofocus: true,
                          maxLines: 10,
                          minLines: 1,
                          maxLength: 400,
                          decoration: const InputDecoration(
                            hintText: "What's happening?",
                            border: InputBorder.none,
                          ),
                          controller: _textEditController,
                          onChanged: (value){
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 8,),
                        SizedBox(
                          height: 200,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                            ),
                            itemCount: _images.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  PhotoPreviewRoundedRectangle(
                                      imageProvider: FileImage(_images[index])),
                                  Positioned(
                                    top: 5,
                                      right: 5,
                                      child: IconButton(
                                    icon: const Icon(Icons.close),
                                        onPressed: () {
                                      setState(() {
                                        _images.removeAt(index);
                                      });
                                        },
                                  ))
                                ],
                              );
                            },
                          ),
                        ),
                        _images.isEmpty?SizedBox():CustomContainer(
                          alignment: Alignment.topRight,
                          children: [
                            Text("${_images.length}/5"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          if(_images.length>4) return;
                          File? image =
                              await ImagePickerHelper().getImageFromCamera();
                          setState(() {
                            if (image != null) _images.add(image);
                          });
                        },
                        icon: const Icon(Icons.camera_alt_outlined), color: _images.length>4?Colors.grey:Colors.black,),
                    IconButton(
                        onPressed: () async {
                          if(_images.length>4) return;
                          File? image =
                              await ImagePickerHelper().getImageFromGallery();
                          setState(() {
                            if (image != null) _images.add(image);
                          });
                        },
                        icon: const Icon(Icons.photo_outlined), color: _images.length>4?Colors.grey:Colors.black),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
