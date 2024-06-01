import 'package:orange_chat/helpers/image_picker_helper.dart';
import 'package:orange_chat/helpers/supabase/message_model_helper.dart';
import 'package:orange_chat/helpers/supabase/storage_helper.dart';
import 'package:orange_chat/models/supabase/rooms.dart';
import 'package:flutter/material.dart';


class MessageInputField extends StatefulWidget{
  final RoomModel roomModel;
  const MessageInputField({super.key, required this.roomModel});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final _textEditController = TextEditingController();
  late FocusNode _focusNode;


  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener((){setState(() {});});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
        children: [
          _focusNode.hasFocus
              ?const SizedBox()
              :Row(
            children: [
              IconButton(
                  onPressed: ()async{
                    final image = await ImagePickerHelper().getImageFromCamera();
                    if(image!=null){
                      String imageUrl = await StorageHelper().uploadFile(file: image);
                      MessageModelHelper().submit(roomModel: widget.roomModel, imageUrl: imageUrl);
                    }
                  },
                  icon: const Icon(Icons.camera_alt_outlined)
              ),
              IconButton(
                  onPressed: () async{
                    final image = await ImagePickerHelper().getImageFromGallery();
                    if(image!=null){
                      String imageUrl = await StorageHelper().uploadFile(file: image, context: context);
                      MessageModelHelper().submit(roomModel: widget.roomModel, imageUrl: imageUrl);
                    }
                  },
                  icon: const Icon(Icons.photo_outlined)
              ),
            ],
          ),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              maxLines: 4,
              minLines: 1,
              maxLength: 400,
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: Theme.of(context).colorScheme.onTertiary,
              ),
              controller: _textEditController,

            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded),
            onPressed: () {
              MessageModelHelper().submit(roomModel: widget.roomModel, message: _textEditController.text);
              _textEditController.clear();
              // キーボードを閉じる
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )
        ],
      ),
    );
  }
}