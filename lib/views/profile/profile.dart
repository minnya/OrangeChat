import 'package:orange_chat/components/commons/photo_preview_round.dart';
import 'package:orange_chat/components/commons/bottom_report_block.dart';
import 'package:orange_chat/components/profile/button_follow.dart';
import 'package:orange_chat/components/profile/button_message.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/views/profile/followers.dart';
import 'package:orange_chat/views/profile/followings.dart';
import 'package:orange_chat/views/posts/posts.dart';
import 'package:orange_chat/views/settings/main.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../components/commons/urge_login_dialog.dart';
import '../../helpers/supabase/user_model_helper.dart';
import '../../models/supabase/users.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel user;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    setState(() => isLoading = true);
    user = (await UserModelHelper()
        .get(widget.userId ?? AuthHelper().getUID()));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium!;
    final TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          widget.userId == null
          ?const SizedBox()
          :IconButton(
            onPressed: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  expand: false,
                  builder: (BuildContext context) => ReportBlockBottomMenu(userModel: user,)
              );
            },
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      floatingActionButton: widget.userId != null
          ? null
          : FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: () {
                if (AuthHelper().isSignedIn() == false) {
                  showUrgeLoginDialog(context);
                } else {
                  showCupertinoModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => const SettingsPage());
                }
              },
              child: const Icon(Icons.settings_rounded),
            ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: getUser,
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Column(
                      children: [
                        Expanded(flex: 1, child: _TopPortion(user)),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                //名前・年齢
                                Text(
                                  user.age!=null && user.age!.isNotEmpty? "${user.name}, ${user.age}" : user.name,
                                  style: titleStyle,
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      user.prefecture == null?const SizedBox():Text(user.prefecture!, style: bodyStyle),
                                      user.description == null?const SizedBox():Text(user.description!, style: bodyStyle),
                                    ],
                                  ),
                                ),
                                //編集ボタン、フォローボタン、メッセージボタン
                                Container(
                                  child: widget.userId == null
                                      ? ElevatedButton.icon(
                                      onPressed: () {
                                        if (AuthHelper().isSignedIn() == false) {
                                          showUrgeLoginDialog(context);
                                          return;
                                        }
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditProfileScreen()));
                                      },
                                      icon: const Icon(Icons.edit, size: 15,),
                                      label: Text("Edit Profile", style: Theme.of(context).textTheme.labelLarge,),)
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FollowButton(userModel: user),
                                            const SizedBox(width: 16.0),
                                            MessageButton(user: user),
                                          ],
                                        ),
                                ),
                                const SizedBox(height: 16),
                                _ProfileInfoRow(
                                  user: user,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }
}

class _ProfileInfoRow extends StatefulWidget {
  final UserModel user;

  const _ProfileInfoRow({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<_ProfileInfoRow> createState() => _ProfileInfoRowState();
}

class _ProfileInfoRowState extends State<_ProfileInfoRow> {
  late List<ProfileInfoItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      ProfileInfoItem(
          "Posts",
          widget.user.postCount,
          PostScreen(
            userModel: widget.user,
          )),
      ProfileInfoItem(
          "Followers",
          widget.user.followerCount,
          FollowerScreen(
            userModel: widget.user,
          )),
      ProfileInfoItem(
          "Following",
          widget.user.followingCount,
          FollowingScreen(
            userModel: widget.user,
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) =>
      TextButton(
        onPressed: (){
          showCupertinoModalBottomSheet(
              context: context,
              builder: (BuildContext context) => item.destionationWidget);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.value.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Text(
              item.title,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  final Widget destionationWidget;

  const ProfileInfoItem(this.title, this.value, this.destionationWidget);
}

class _TopPortion extends StatelessWidget {
  UserModel user;

  _TopPortion(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.0),
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.primary.withOpacity(0.4)
                  ]),
              ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PhotoPreviewRound(imageProvider: user.iconUrl==null
                    ?null
                    :NetworkImage(user.iconUrl!)
                ),
                DateTime.now().difference(user.updatedAt).inMinutes<5
                ?activeLump()
                :SizedBox(),
              ],
            ),
          ),
        )
      ],
    );
  }
  Widget activeLump(){
    return Positioned(
      bottom: 0,
      right: 0,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
              color: Colors.green, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
