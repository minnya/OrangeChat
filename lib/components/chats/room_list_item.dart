import 'package:flutter/material.dart';
import 'package:orange_chat/components/chats/unread.dart';
import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/components/commons/star_rating.dart';
import 'package:orange_chat/models/supabase/rooms.dart';

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

    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      visualDensity: const VisualDensity(vertical: 3),
      leading: CustomContainer(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: item.userId)));
          },
          children: [
            CircleAvatar(
              radius: 30,
              foregroundImage:
                  item.imageUrl == null ? null : NetworkImage(item.imageUrl!),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ]),
      title: CustomContainer(
        direction: Direction.HORIZONTAL,
        alignment: Alignment.topCenter,
        children: [
          Text(
            item.name,
            style: titleStyle,
          ),
          const SizedBox(
            width: 8,
          ),
          StarRatingWidget(
            starCount: 5,
            rating: item.score ?? 0,
            size: Size.small,
          ),
        ],
      ),
      subtitle: Text(
        item.lastMessage ?? "${item.name} sent a photo",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: bodyStyle.copyWith(color: Colors.grey),
      ),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 100.0,
        ),
        child: CustomContainer(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.only(top: 8),
          children: [
            Text(
              formatTimeDiff(item.updatedAt),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.black45),
            ),
            const CustomContainer(
              height: 10,
            ),
            UnreadComponent(count: item.countUnread)
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoomScreen(room: item)));
      },
    );
  }
}
