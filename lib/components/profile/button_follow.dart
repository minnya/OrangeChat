

import 'package:orange_chat/components/commons/urge_login_dialog.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/helpers/supabase/follow_model_helper.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget{
  final UserModel userModel;
  const FollowButton({super.key, required this.userModel});


  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.labelMedium!;

    return ElevatedButton.icon(
      onPressed: () {
        if(AuthHelper().isSignedIn()==false){
          showUrgeLoginDialog(context);
          return;
        }
        if (widget.userModel.following) {
          FollowModelHelper().deleteFollow(widget.userModel);
        } else {
          FollowModelHelper().putFollow(widget.userModel);
        }
        setState(() {
          widget.userModel.following = !widget.userModel.following;
        });
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: widget.userModel.following
              ? Theme.of(context)
              .colorScheme
              .primary
              : Theme.of(context)
              .colorScheme
              .onPrimary,
          foregroundColor: widget.userModel.following
              ? Theme.of(context)
              .colorScheme
              .onPrimary
              : Theme.of(context)
              .colorScheme
              .primary,
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(16))),
      label: widget.userModel.following
          ? Text("Following", style: titleStyle.copyWith(color: Theme.of(context).colorScheme.onPrimary,))
          : Text("Follow", style: titleStyle.copyWith(color: Theme.of(context).colorScheme.primary,)),
      icon: widget.userModel.following
          ? const Icon(Icons.person_rounded, size: 15,)
          : const Icon(Icons.person_add_alt_1, size: 15,),
    );
  }
}