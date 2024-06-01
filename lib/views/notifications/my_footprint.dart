import 'package:orange_chat/components/commons/user_list_item.dart';
import 'package:orange_chat/helpers/supabase/footprint_model_helper.dart';
import 'package:orange_chat/models/supabase/footprints.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/material.dart';


class MyFootPrintScreen extends StatefulWidget{
  const MyFootPrintScreen({super.key});


  @override
  State<MyFootPrintScreen> createState() => _MyFootPrintScreenState();
}

class _MyFootPrintScreenState extends State<MyFootPrintScreen> with AutomaticKeepAliveClientMixin{
  late List<FootprintModel> myFootprintList;
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
    myFootprintList = await FootprintModelHelper().getAllMyFootprints(context);
    userList = myFootprintList.map((post) => post.user!).toList();
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
        onRefresh: getAllFootprints,
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}