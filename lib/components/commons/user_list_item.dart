import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/helpers/supabase/follow_model_helper.dart';
import 'package:orange_chat/helpers/supabase/user_model_helper.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:orange_chat/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../tools/time_diff.dart';

class UserListItem extends StatefulWidget {
  final List<UserModel> userList;
  final Future<void> Function()? onRefresh;
  final bool isBlockButton;

  const UserListItem({
    required this.userList,
    this.onRefresh,
    this.isBlockButton = false,
    super.key,
  });

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  late List<bool> _followStatus;

  @override
  void initState() {
    super.initState();
    _followStatus = widget.userList.map((user) => user.following).toList();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey);
    final TextStyle titleStyle = Theme.of(context).textTheme.bodyMedium!;

    return RefreshIndicator(
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView.builder(
        itemCount: widget.userList.length,
        itemBuilder: (BuildContext context, int index) {
          UserModel item = widget.userList[index];
          bool isEnabled = _followStatus[index];
          String labelText = widget.isBlockButton
              ? "Unblock"
              : isEnabled
              ? "Following"
              : "Follow";

          return ListTile(
            titleAlignment: ListTileTitleAlignment.top,
            visualDensity: const VisualDensity(vertical: 3),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: item.iconUrl == null
                  ? null
                  : NetworkImage(item.iconUrl!),
            ),
            title: Text(
              item.age != null && item.age!.isNotEmpty
                  ? "${item.name}, ${item.age}"
                  : item.name,
              style: titleStyle,
            ),
            subtitle: Text(
              "${item.prefecture}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bodyStyle,
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatTimeDiff(item.updatedAt)),
                ElevatedButton(
                  onPressed: () async {
                    if (!widget.isBlockButton) {
                      if (isEnabled) {
                        await FollowModelHelper().deleteFollow(item);
                      } else {
                        await FollowModelHelper().putFollow(item);
                      }
                      setState(() {
                        _followStatus[index] = !_followStatus[index];
                      });
                    } else {
                      final bool result = await showOKCancelDialog(
                        context: context,
                        message: "Do you want to unblock this user?",
                      );
                      if (!result) return;
                      await UserModelHelper().deleteBlock(userModel: item);
                      setState(() {
                        widget.userList.remove(item);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEnabled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onPrimary,
                    // minimumSize: Size.zero,
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    labelText,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: isEnabled
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ProfileScreen(userId: item.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
