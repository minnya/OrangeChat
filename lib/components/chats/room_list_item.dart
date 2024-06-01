import 'package:orange_chat/components/chats/unread.dart';
import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/models/supabase/rooms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../tools/time_diff.dart';
import '../../views/chats/chat_room.dart';
import '../../views/profile/profile.dart';

class RoomListItem extends StatelessWidget {
  final RoomModel item;

  const RoomListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium!;
    final TextStyle titleStyle = Theme.of(context).textTheme.bodyMedium!;

    return CustomContainer(
      direction: Direction.HORIZONTAL,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
      CustomContainer(
          padding: const EdgeInsets.symmetric(horizontal: 8),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: item.userId)));
        },
        children: [CircleAvatar(
          radius: 30,
          backgroundImage:
              item.imageUrl == null ? null : NetworkImage(item.imageUrl!),
        ),
    ]
      ),
      Expanded(
        child: CustomContainer(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatRoomScreen(room: item)));
          },
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          alignment: Alignment.centerLeft,
          children: [
            Text(item.name,style: titleStyle,),
            Text(
              item.lastMessage ?? "${item.name} sent a photo",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bodyStyle.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
      CustomContainer(
        width: 50,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 8, top: 8),
        children: [
          Text(
            formatTimeDiff(item.createdAt),
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Colors.black45),
          ),
          UnreadComponent(count: item.countUnread)
        ],
      ),
    ]);
  }
}
