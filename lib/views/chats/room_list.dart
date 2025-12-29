import 'package:flutter/material.dart';
import 'package:orange_chat/components/chats/room_list_item.dart';
import 'package:orange_chat/helpers/supabase/room_model_helper.dart';
import 'package:orange_chat/models/supabase/rooms.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  Future<List<RoomModel>> getAllRooms() async {
    List<RoomModel> roomModelList = await RoomModelHelper().getRoomList();
    return roomModelList;
  }

  @override
  void dispose() {
    super.dispose();
    RoomModelHelper().unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    RoomModelHelper().subscribeMessageChange((p0) {
      getAllRooms();
      setState(() {});
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              getAllRooms;
            });
          },
          child: FutureBuilder<List<RoomModel>>(
              future: getAllRooms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<RoomModel>? chatroomList = snapshot.data;
                return chatroomList == null || chatroomList.isEmpty
                    ? const Center(child: Text("No Contents"))
                    : ListView.builder(
                        itemCount: chatroomList.length,
                        itemBuilder: (BuildContext context, int index) {
                          RoomModel item = chatroomList[index];
                          return RoomListItem(
                            item: item,
                          );
                        });
              }),
        ));
  }
}
