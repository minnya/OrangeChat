import 'package:flutter/material.dart';
import 'package:orange_chat/helpers/supabase/post_model_helper.dart';
import 'package:orange_chat/models/supabase/posts.dart';

import '../../helpers/auth_helper.dart';
import '../commons/urge_login_dialog.dart';

class DislikeButton extends StatefulWidget {
  final PostModel item;

  const DislikeButton({super.key, required this.item});

  @override
  State<DislikeButton> createState() => _DislikeButtonState();
}

class _DislikeButtonState extends State<DislikeButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        if (AuthHelper().isSignedIn() == false) {
          showUrgeLoginDialog(context);
        } else {
          widget.item.disliked
              ? PostModelHelper(context: context).deleteDislike(widget.item.id)
              : PostModelHelper(context: context).putDislike(widget.item.id);
          setState(() {
            widget.item.disliked = !widget.item.disliked;
            widget.item.disliked
                ? widget.item.dislikeCount += 1
                : widget.item.dislikeCount -= 1;
          });
        }
      },
      icon: Icon(
        color: Colors.grey,
        widget.item.disliked
            ? Icons.thumb_down_rounded
            : Icons.thumb_down_alt_outlined,
        size: 15,
      ),
      label: Text(
        widget.item.dislikeCount.toString(),
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Colors.grey),
      ),
    );
  }
}
