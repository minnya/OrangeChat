import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:orange_chat/components/commons/bottom_report_block.dart';
import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/components/commons/photo_preview_round.dart';
import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/components/commons/star_rating.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/helpers/supabase/message_model_helper.dart';
import 'package:orange_chat/models/supabase/rooms.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../components/chats/message_input_field.dart';
import '../../models/supabase/messages.dart';
import '../call/call_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  final RoomModel room;

  const ChatRoomScreen({super.key, required this.room});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  NetworkImage? icon;
  MessageModelHelper? messageModelHelper;

  @override
  void initState() {
    super.initState();
    messageModelHelper =
        MessageModelHelper(context: context, roomModel: widget.room);
    icon = widget.room.imageUrl == null
        ? null
        : NetworkImage(widget.room.imageUrl!);
    widget.room.addListener(() {
      // Delayを入れないとなぜかメッセージが2つので、暫定的にdelayを挟む
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (messageModelHelper == null) return Container();
    return Scaffold(
      appBar: AppBar(
        title: CustomContainer(
          direction: Direction.HORIZONTAL,
          alignment: Alignment.topCenter,
          children: [
            Text(widget.room.name),
            const SizedBox(
              width: 8,
            ),
            StarRatingWidget(
              starCount: 5,
              rating: widget.room.score ?? 0,
              size: Size.small,
              alignment: Alignment.topCenter,
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final bool result = await showOKCancelDialog(
                    context: context, message: "Do you want to make a call?");
                if (!result && context.mounted) return;

                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CallScreen(
                      callerId: AuthHelper().getUID(),
                      calleeId: widget.room.userId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.phone)),
          IconButton(
              onPressed: () {
                UserModel userModel = UserModel.createEmpty();
                showCupertinoModalBottomSheet(
                    context: context,
                    expand: false,
                    builder: (BuildContext context) => ReportBlockBottomMenu(
                          userModel: userModel,
                        ));
              },
              icon: const Icon(Icons.more_vert_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: widget.room.roomId == 0
                  ? null
                  : StreamBuilder<List<MessageModel>>(
                      stream: messageModelHelper?.messageStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<MessageModel> messageList = snapshot.data!;
                        messageModelHelper?.updateRead(messageList);
                        return ScrollablePositionedList.builder(
                            reverse: true,
                            itemScrollController: _itemScrollController,
                            itemCount: messageList.length,
                            initialScrollIndex: 0,
                            itemBuilder: (context, index) {
                              MessageModel item = messageList[index];
                              return Container(
                                child: item.senderId != widget.room.userId
                                    ? MessageMe(
                                        message: item,
                                      )
                                    : Message(
                                        networkImage: icon,
                                        message: item,
                                      ),
                              );
                            });
                      }),
            ),
          ),
          MessageInputField(
            roomModel: widget.room,
            messageModelHelper: messageModelHelper!,
          ),
        ],
      ),
    );
  }
}

class MessageMe extends StatelessWidget {
  final MessageModel message;

  const MessageMe({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium!;
    final TextStyle labelStyle = Theme.of(context)
        .textTheme
        .labelSmall!
        .copyWith(fontWeight: FontWeight.normal, fontSize: 10);
    return CustomContainer(
      direction: Direction.HORIZONTAL,
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.read!
                ? Text(
                    "read",
                    style: labelStyle,
                  )
                : const SizedBox(),
            Text(
              DateFormat('hh:mm').format(message.createdAt!),
              style: labelStyle,
            ),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Bubble(
            padding: const BubbleEdges.symmetric(horizontal: 12, vertical: 8),
            color: Theme.of(context).colorScheme.primary,
            radius: const Radius.circular(10),
            nip: BubbleNip.rightTop,
            child: message.imageUrl != null
                ? SizedBox(
                    width: 180,
                    height: 120,
                    child: PhotoPreviewRoundedRectangle(
                        imageProvider: NetworkImage(message.imageUrl!)),
                  )
                : Text(
                    message.content!,
                    style: bodyStyle.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                    textAlign: TextAlign.left,
                  ),
          ),
        ),
      ],
    );
  }
}

class Message extends StatelessWidget {
  final MessageModel message;
  final NetworkImage? networkImage;

  const Message({super.key, required this.networkImage, required this.message});

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium!;
    final TextStyle labelStyle = Theme.of(context)
        .textTheme
        .labelSmall!
        .copyWith(fontWeight: FontWeight.normal, fontSize: 10);
    return CustomContainer(
        direction: Direction.HORIZONTAL,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          CircleAvatar(radius: 15, backgroundImage: networkImage),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Bubble(
              padding: const BubbleEdges.symmetric(horizontal: 12, vertical: 8),
              color: Theme.of(context).colorScheme.primaryContainer,
              radius: const Radius.circular(10),
              nip: BubbleNip.leftTop,
              child: message.imageUrl != null
                  ? SizedBox(
                      width: 180,
                      height: 120,
                      child: PhotoPreviewRoundedRectangle(
                          imageProvider: NetworkImage(message.imageUrl!)))
                  : Text(
                      message.content!,
                      style: bodyStyle,
                      textAlign: TextAlign.left,
                    ),
            ),
          ),
          Text(
            DateFormat('hh:mm').format(message.createdAt!),
            style: labelStyle,
          ),
        ]);
  }
}
