import 'package:orange_chat/components/commons/user_list_item.dart';
import 'package:orange_chat/helpers/supabase/footprint_model_helper.dart';
import 'package:orange_chat/models/supabase/footprints.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/material.dart';


class FootPrintScreen extends StatefulWidget {
  const FootPrintScreen({super.key});
  @override
  State<FootPrintScreen> createState() => _FootPrintScreenState();
}

class _FootPrintScreenState extends State<FootPrintScreen> with AutomaticKeepAliveClientMixin{
  late List<FootprintModel> footprintList;
  late List<UserModel> userList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAllFootprints();
  }

  Future<void> getAllFootprints() async {
    setState(() {
      isLoading = true;
    });
    footprintList = await FootprintModelHelper().getAllFootprints(context);
    userList = footprintList.map((map) => map.user).toList();
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
    ?const Center(
      child: CircularProgressIndicator(),
    )
    :Scaffold(
      body: userList.isEmpty?
      const Center(child: Text("No contents"))
          :UserListItem(
        userList: userList,
        onRefresh: getAllFootprints,)
    );
  }

  @override
  bool get wantKeepAlive => true;
}