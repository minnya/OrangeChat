import 'package:orange_chat/views/user-list/user_filter.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../components/user-list/user-list-item.dart';
import '../../helpers/supabase/user_model_helper.dart';
import '../../models/supabase/users.dart';


class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late List<UserModel> userList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    setState(() {
      isLoading = true;
    });
    userList = await UserModelHelper().getAll();
    setState(() {
      isLoading = false;
    });
  }

  // UserFilter画面から戻ってきた際に再描画
  void pushWithReloadByReturn(BuildContext context) async {
    final result = await showCupertinoModalBottomSheet(
        context: context,
        builder: (BuildContext context) => UserFilterScreen()
    );
    // UserFilter画面からの戻り値がtrueの場合は再ロード
    if (result==true) {
      getAllUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () {
          // UserFilterScreenに移動
          pushWithReloadByReturn(context);
        },
        child: const Icon(Icons.search_rounded),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                  onRefresh: getAllUsers,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (constraints.maxWidth/200)>2?(constraints.maxWidth/200).toInt():2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return UserListItem(user: userList[index]);
                    },
                  ),
                );
            }
          ),
    );
  }
}
