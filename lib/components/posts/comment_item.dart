import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../const/variables.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/supabase/comment_model_helper.dart';
import '../../models/supabase/comments.dart';
import '../../models/supabase/posts.dart';
import '../../tools/time_diff.dart';
import '../commons/bottom_report_block.dart';
import '../commons/urge_login_dialog.dart';

class CommentListItem extends StatefulWidget {
  final CommentModel commentModel;
  final PostModel mentionedPost;
  final Function(
      {required CommentModel commentModel,
      required PostModel mentionedPost}) onReplyCallback;

  const CommentListItem(
      {super.key,
      required this.commentModel,
      required this.mentionedPost,
      required this.onReplyCallback});

  @override
  State<CommentListItem> createState() => _CommentListItemState();
}

class _CommentListItemState extends State<CommentListItem> {
  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle =
        Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey);
    return CustomContainer(
        direction: Direction.HORIZONTAL,
        alignment: Alignment.topLeft,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.topLeft,
            child: CircleAvatar(
                radius: 16,
                backgroundImage: widget.commentModel.ownerIconUrl == null
                    ? null
                    : NetworkImage(
                        "${ConstVariables.SUPABASE_HOSTNAME}${widget.commentModel.ownerIconUrl!}")),
          ),
          Expanded(
            child: CustomContainer(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              children: [
                Row(
                  children: [
                    Text(
                      widget.commentModel.ownerName,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black54),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      formatTimeDiff(widget.commentModel.createdAt),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black54),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.commentModel.mentionedUserName != null &&
                                widget
                                    .commentModel.mentionedUserName!.isNotEmpty
                            ? "@${widget.commentModel.mentionedUserName} "
                            : "",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      TextSpan(text: widget.commentModel.message)
                    ],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                CustomContainer(
                  alignment: Alignment.topLeft,
                  direction: Direction.HORIZONTAL,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        if (AuthHelper().isSignedIn() == false) {
                          showUrgeLoginDialog(context);
                        } else {
                          widget.commentModel.liked
                              ? CommentModelHelper(context: context)
                                  .deleteLike(widget.commentModel.id)
                              : CommentModelHelper(context: context)
                                  .putLike(widget.commentModel.id);
                          setState(() {
                            widget.commentModel.liked =
                                !widget.commentModel.liked;
                            widget.commentModel.liked
                                ? widget.commentModel.likeCount += 1
                                : widget.commentModel.likeCount -= 1;
                          });
                        }
                      },
                      icon: Icon(
                        widget.commentModel.liked
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_up_alt_outlined,
                        color: Colors.grey,
                        size: 15,
                      ),
                      label: Text(
                        widget.commentModel.likeCount.toString(),
                        style: labelStyle,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        if (AuthHelper().isSignedIn() == false) {
                          showUrgeLoginDialog(context);
                        } else {
                          widget.commentModel.disliked
                              ? CommentModelHelper(context: context)
                                  .deleteDislike(widget.commentModel.id)
                              : CommentModelHelper(context: context)
                                  .putDislike(widget.commentModel.id);
                          setState(() {
                            widget.commentModel.disliked =
                                !widget.commentModel.disliked;
                            widget.commentModel.disliked
                                ? widget.commentModel.dislikeCount += 1
                                : widget.commentModel.dislikeCount -= 1;
                          });
                        }
                      },
                      icon: Icon(
                        widget.commentModel.disliked
                            ? Icons.thumb_down_rounded
                            : Icons.thumb_down_alt_outlined,
                        color: Colors.grey,
                        size: 15,
                      ),
                      label: Text(
                        widget.commentModel.dislikeCount.toString(),
                        style: labelStyle,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        widget.onReplyCallback(
                            commentModel: widget.commentModel,
                            mentionedPost: widget.mentionedPost);
                      },
                      icon: const Icon(
                        Icons.message_outlined,
                        color: Colors.grey,
                        size: 15,
                      ),
                      label: Text(
                        widget.commentModel.mentionedCommentId == null
                            ? widget.commentModel.replyCount.toString()
                            : "",
                        style: labelStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 8),
              onTap: () {
                showCupertinoModalBottomSheet(
                    context: context,
                    expand: false,
                    builder: (BuildContext context) => ReportBlockBottomMenu(
                          userModel: UserModel.createEmpty(),
                          commentModel: widget.commentModel,
                        ));
              },
              children: [
                const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.grey,
                )
              ]),
        ]);
  }
}
