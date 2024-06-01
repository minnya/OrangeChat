import 'package:orange_chat/components/commons/user_list_item.dart';
import 'package:orange_chat/helpers/supabase/follow_model_helper.dart';
import 'package:orange_chat/models/supabase/follows.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget{
  final UserModel userModel;
  const FollowingScreen({super.key, required this.userModel});
  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  late List<FollowModel> followingList;
  late List<UserModel> userList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getFollowings();
  }

  Future<void> getFollowings() async{
    setState(() {
      isLoading = true;
    });
    followingList = await FollowModelHelper().getAllFollowings(widget.userModel.id);
    userList = followingList.map((follower) => follower.user).toList();
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Followings"),
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: Icon(Icons.close_rounded),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : UserListItem(userList: userList, onRefresh: getFollowings,),
    );
  }
}