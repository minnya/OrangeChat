import 'package:orange_chat/helpers/supabase/room_model_helper.dart';
import 'package:orange_chat/models/supabase/rooms.dart';
import 'package:orange_chat/views/chats/chat_room.dart';
import 'package:flutter/material.dart';

import '../../helpers/auth_helper.dart';
import '../../models/supabase/users.dart';
import '../commons/urge_login_dialog.dart';

class MessageButton extends StatelessWidget {
  final UserModel user;

  const MessageButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        if(AuthHelper().isSignedIn()==false){
          showUrgeLoginDialog(context);
          return;
        }
        RoomModel roomModel = await RoomModelHelper().getRoom(user);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ChatRoomScreen(
                      room: roomModel,
                    )));
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          foregroundColor: Theme.of(context).colorScheme.onTertiary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      label: Text("Message", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
      icon: const Icon(Icons.message_rounded, size: 15,),
    );
  }
}
