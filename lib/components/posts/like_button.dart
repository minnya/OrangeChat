import 'package:orange_chat/helpers/supabase/post_model_helper.dart';
import 'package:orange_chat/models/supabase/posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/auth_helper.dart';
import '../commons/urge_login_dialog.dart';

class LikeButton extends StatefulWidget{
  final PostModel item;

  const LikeButton({super.key, required this.item});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        if(AuthHelper().isSignedIn()==false){
          showUrgeLoginDialog(context);
        }else {
          widget.item.liked
              ? PostModelHelper(context: context).deleteLike(widget.item.id)
              : PostModelHelper(context: context).putLike(widget.item.id);
          setState(() {
            widget.item.liked = !widget.item.liked;
            widget.item.liked
                ? widget.item.likeCount += 1
                : widget.item.likeCount -= 1;
          });
        }
      },
      icon: Icon(
          color: Colors.grey,
          widget.item.liked ? Icons.favorite_rounded: Icons.favorite_outline,
          size: 15,
      ),
      label: Text(
        widget.item.likeCount.toString(),
        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey),
      ),
    );
  }
}