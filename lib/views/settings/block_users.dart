import 'package:orange_chat/components/commons/user_list_item.dart';
import 'package:orange_chat/helpers/supabase/follow_model_helper.dart';
import 'package:orange_chat/helpers/supabase/user_model_helper.dart';
import 'package:orange_chat/models/supabase/follows.dart';
import 'package:orange_chat/models/supabase/users.dart';



import 'package:flutter/material.dart';

class BlockUsersScreen extends StatefulWidget{
  const BlockUsersScreen({super.key});
  @override
  State<BlockUsersScreen> createState() => _BlockUsersScreenState();
}

class _BlockUsersScreenState extends State<BlockUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blocked users"),
      ),
      body:FutureBuilder(
        future: UserModelHelper().getBlockedUsers(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          List<UserModel> userList = snapshot.data??[];
          return UserListItem(userList: userList,onRefresh: UserModelHelper().getBlockedUsers, isBlockButton: true,);
        }
      ),
    );
  }
}