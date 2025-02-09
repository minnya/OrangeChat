
import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/components/posts/comment_item.dart';
import 'package:orange_chat/helpers/supabase/comment_model_helper.dart';
import 'package:orange_chat/models/supabase/comments.dart';
import 'package:orange_chat/models/supabase/posts.dart';
import 'package:flutter/material.dart';

class CommentListScreen extends StatefulWidget {
  final PostModel mentionedPost;
  final CommentModel? mentionedComment;

  const CommentListScreen(
      {super.key, required this.mentionedPost, this.mentionedComment});

  @override
  State<CommentListScreen> createState() => _CommentListScreenState();
}

class _CommentListScreenState extends State<CommentListScreen> {
  late Future<List<CommentModel>> _commentFuture;
  late FocusNode _focusNode;
  final _textEditController = TextEditingController();
  bool buttonEnabled = false;
  CommentModel? toReplyComment;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
    getComments();
  }

  Future<void> getComments() async {
    if (widget.mentionedComment == null) {
      _commentFuture = CommentModelHelper(context: context)
          .getAll(postModel: widget.mentionedPost);
    } else {
      _commentFuture = CommentModelHelper(context: context)
          .getAllReplies(commentModel: widget.mentionedComment!);
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  void _updateButtonState() {
    setState(() {
      buttonEnabled = _textEditController.text.isNotEmpty;
    });
  }

  void onReplyButtonPressed(
      {required CommentModel commentModel, required PostModel mentionedPost}) {
    if (widget.mentionedComment == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CommentListScreen(
                    mentionedPost: mentionedPost,
                    mentionedComment: commentModel,
                  )));
    } else {
      toReplyComment = commentModel;
      FocusScope.of(context).requestFocus(_focusNode);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mentionedComment == null ? "Comments" : "Replies",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: IconButton(
          icon: Icon(widget.mentionedComment == null
              ? Icons.close_rounded
              : Icons.arrow_back_rounded),
          onPressed: () {
            if (widget.mentionedComment != null) {
              Navigator.pop(context);
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getComments,
        child: FutureBuilder(
          future: _commentFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<CommentModel> commentList = snapshot.data ?? [];
            return Column(
              children: [
                widget.mentionedComment == null
                    ? SizedBox()
                    : Container(
                        color: Colors.grey.withAlpha(25),
                        child: CommentListItem(
                          commentModel: widget.mentionedComment!,
                          mentionedPost: widget.mentionedPost,
                          onReplyCallback: onReplyButtonPressed,
                        ),
                      ),
                Expanded(
                  child: commentList.isEmpty
                      ? const Center(child: Text("No comments"))
                      : Container(
                          padding: EdgeInsets.only(
                              left: widget.mentionedComment == null ? 0 : 40),
                          child: ListView.builder(
                            itemCount: commentList.length,
                            itemBuilder: (context, int index) {
                              CommentModel commentModel = commentList[index];
                              return CommentListItem(
                                commentModel: commentModel,
                                mentionedPost: widget.mentionedPost,
                                onReplyCallback: onReplyButtonPressed,
                              );
                            },
                          ),
                        ),
                ),
                // Divider(height: 0, color: Colors.grey,),
                toReplyComment != null
                    ? CustomContainer(
                        alignment: Alignment.topLeft,
                        color: Colors.grey.withAlpha(10),
                        direction: Direction.HORIZONTAL,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: RichText(
                                  text: TextSpan(
                                      children: [
                                    const TextSpan(text: "Replying to "),
                                    TextSpan(
                                        text: "@${toReplyComment!.ownerName}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                color:
                                                    Theme.of(context).primaryColor))
                                  ],
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.grey))),
                            ),
                          ),
                          CustomContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            alignment: Alignment.center,
                            onTap: (){
                              toReplyComment=null;
                              setState(() {});
                            },
                            children: [Text("×", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),), ],
                          )
                        ],
                      )
                    : const SizedBox(),
                CustomContainer(
                  direction: Direction.HORIZONTAL,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  color: Colors.grey.withAlpha(10),
                  children: [
                    const CircleAvatar(
                      radius: 15,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Form(
                          autovalidateMode: AutovalidateMode.always,
                          child: TextFormField(
                            controller: _textEditController,
                            focusNode: _focusNode,
                            maxLines: 5,
                            minLines: 1,
                            maxLength: 400,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: widget.mentionedComment == null
                                  ? "Add a comment..."
                                  : "Add a reply...",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              _updateButtonState();
                            },
                          ),
                        ),
                      ),
                    ),
                    !_focusNode.hasFocus
                        ? const SizedBox()
                        : IconButton(
                            onPressed: buttonEnabled
                                ? () {
                                    CommentModelHelper(context: context)
                                        .putComment(
                                      message: _textEditController.text,
                                      mentionedPostId: widget.mentionedPost.id,
                                      mentionedCommentId: widget.mentionedComment?.id,
                                      mentionedUserId: toReplyComment?.ownerId,
                                    );
                                    _textEditController.text = "";
                                    toReplyComment=null;
                                    FocusScope.of(context).unfocus();
                                    setState(() {});
                                  }
                                : null,
                            icon: Icon(
                              Icons.send_rounded,
                              color: buttonEnabled
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
