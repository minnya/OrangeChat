import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/components/commons/urge_login_dialog.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/helpers/supabase/post_model_helper.dart';
import 'package:orange_chat/helpers/supabase/user_model_helper.dart';
import 'package:orange_chat/models/supabase/comments.dart';
import 'package:orange_chat/models/supabase/posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/supabase/comment_model_helper.dart';
import '../../models/supabase/users.dart';

class ReportBlockBottomMenu extends StatelessWidget {
  final UserModel userModel;
  final PostModel? postModel;
  final CommentModel? commentModel;

  const ReportBlockBottomMenu(
      {super.key, required this.userModel, this.postModel, this.commentModel});

  @override
  Widget build(BuildContext context) {
    MenuOptions options;
    if (postModel != null) {
      options = MenuOptions(
        label: "Post",
        deleteMethod: () =>
            PostModelHelper(context: context).deletePost(postModel: postModel!),
      );
    } else if (commentModel != null) {
      options = MenuOptions(
        label: "Comment",
        deleteMethod: () => CommentModelHelper(context: context)
            .deleteComment(commentModel: commentModel!),
      );
    }else{
      options = MenuOptions(label: "", deleteMethod: ()async{});
    }
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: userModel.id == AuthHelper().getUID()
              ? [
                  ListTile(
                    leading: const Icon(Icons.delete_outlined),
                    title: Text("Delete this ${options.label}"),
                    onTap: () async {
                      final result = await showOKCancelDialog(
                          context: context,
                          message:
                              "Are you sure you want to delete this post?");
                      if (result == false) return;
                      await options.deleteMethod();
                      await showOKDialog(
                          context: context,
                          message: "The post has been deleted.");
                      Navigator.pop(context);
                    },
                  ),
                ]
              : [
                  ListTile(
                    leading: const Icon(Icons.flag_outlined),
                    title: Text("Report @${userModel.name}"),
                    onTap: () {},
                  ),
                  ListTile(
                      leading: const Icon(Icons.block_outlined),
                      title: Text("Block @${userModel.name}"),
                      onTap: () async {
                        final result = await UserModelHelper(context: context)
                            .putBlock(userModel: userModel);
                        if (result == true && context.mounted) {
                          Navigator.pop(context);
                        }
                      }),
                ],
        ),
      ),
    );
  }
}

class MenuOptions {
  final String label;
  final Future<void> Function() deleteMethod;

  MenuOptions({required this.label, required this.deleteMethod});
}
