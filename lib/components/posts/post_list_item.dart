import 'package:flutter/material.dart';
import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/components/posts/image_gallery.dart';
import 'package:orange_chat/components/posts/like_button.dart';
import 'package:orange_chat/components/posts/reply_button.dart';
import 'package:orange_chat/components/posts/row_post_base.dart';
import 'package:orange_chat/models/supabase/posts.dart';
import 'package:orange_chat/views/profile/profile.dart';

import '../../tools/time_diff.dart';

class PostListItem extends StatefulWidget {
  final PostModel item;

  const PostListItem({super.key, required this.item});

  @override
  State<PostListItem> createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          leading: CircleAvatar(
            radius: 16,
            foregroundImage: widget.item.user.iconUrl == null
                ? null
                : NetworkImage(widget.item.user.iconUrl!),
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          title: RowPostBase(item: widget.item),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProfileScreen(
                          userId: widget.item.user.id,
                        )));
          },
        ),
        widget.item.imageUrls == null || widget.item.imageUrls!.isEmpty
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ImageGallery(imageUrls: widget.item.imageUrls!)),
        widget.item.message == ""
            ? const SizedBox()
            : CustomContainer(
                direction: Direction.HORIZONTAL,
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                alignment: Alignment.topLeft,
                children: [
                  Expanded(
                    child: Text(
                      widget.item.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
        CustomContainer(
          direction: Direction.HORIZONTAL,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          children: [
            ReplyButton(postModel: widget.item),
            LikeButton(item: widget.item),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          alignment: Alignment.topLeft,
          child: Text(formatTimeDiff(widget.item.createdAt),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey)),
        ),
        const SizedBox(
          height: 12,
        )
      ],
    );
  }
}
