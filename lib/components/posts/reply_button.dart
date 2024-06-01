import 'package:orange_chat/models/supabase/posts.dart';
import 'package:orange_chat/views/posts/comment_list.dart';
import 'package:orange_chat/views/posts/edit_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../helpers/auth_helper.dart';
import '../commons/urge_login_dialog.dart';

class ReplyButton extends StatelessWidget {
  final PostModel postModel;

  const ReplyButton({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(
          color: Colors.grey,
          Icons.message_outlined,
        size: 15,
      ),
      label: Text(
        postModel.commentCount.toString(),
        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey),
      ),
      onPressed: () {
        if(AuthHelper().isSignedIn()==false){
          showUrgeLoginDialog(context);
        }else {
          showCupertinoModalBottomSheet(
              context: context,
              builder: (BuildContext context) =>
                  Navigator(
                      onGenerateRoute: (context) => MaterialPageRoute<SizedBox>(
                    builder: (context)=>SizedBox(
                      height: MediaQuery.sizeOf(context).height*0.8,
                      child: CommentListScreen(
                        mentionedPost: postModel,
                      ),
                    ),)
                  ));
        }
      },
    );
  }
}
