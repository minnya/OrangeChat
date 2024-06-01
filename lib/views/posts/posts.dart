import 'package:orange_chat/components/commons/urge_login_dialog.dart';
import 'package:orange_chat/components/posts/post_list_item.dart';
import 'package:orange_chat/components/posts/search-bar.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/helpers/supabase/post_model_helper.dart';
import 'package:orange_chat/models/supabase/posts.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:orange_chat/tools/screen.dart';
import 'package:orange_chat/views/posts/edit_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PostScreen extends StatefulWidget {
  final UserModel? userModel;
  final PostModel? parentPost;

  const PostScreen({super.key, this.userModel, this.parentPost});

  @override
  State<PostScreen> createState() => _PostScreenState();
}
class TabClass{
  String title;
  String tableName;
  TabClass({required this.title, required this.tableName});
}
class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<TabClass> _tabs = [
    TabClass(title: 'Trending', tableName: "view_post_list_trending"),
    TabClass(title: 'Latest', tableName: "view_post_list"),
    TabClass(title: 'Following', tableName: "view_post_list_following"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () {
          if (AuthHelper().isSignedIn() == false) {
            showUrgeLoginDialog(context);
          } else {
            if(ScreenSize.get(context: context)==Size.small) {
              showCupertinoModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => const EditPostScreen());
            }else{
              showDialog(context: context, builder: (context)=>AlertDialog(content: EditPostScreen())
              );
            }
          }
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).colorScheme.surface),
              floating: true,
              snap: true,
              title: SearchAppBar(
                onSubmitted: (String argument)async{},
              ),
              bottom: TabBar(
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
                labelPadding: EdgeInsets.symmetric(vertical: 0.0),
                controller: _tabController,
                tabs: _tabs.map((e) => Tab(text: e.title)).toList(),
              ),
              expandedHeight: 50,
              leading: widget.userModel == null && widget.parentPost == null
                  ? null // userModelが空の場合はホーム画面と判断
                  : IconButton(
                      // そうでない場合はprofile画面からの遷移と判断
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((e) => PostListPage(userModel: widget.userModel, parentPost: widget.parentPost, tableName: e.tableName,)).toList()
        ),
      ),
    );
  }
}

class PostListPage extends StatefulWidget{
  final UserModel? userModel;
  final PostModel? parentPost;
  final String tableName;

  const PostListPage({super.key, this.userModel, this.parentPost, required this.tableName});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  late Future<List<PostModel>> _postListFuture;

  Future<void> getAllPosts({String keyword = ""}) async {
    _postListFuture = PostModelHelper(context: context).getAll(
        userModel: widget.userModel,
        postModel: widget.parentPost,
        keyword: keyword,
        tableName: widget.tableName);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
        onRefresh: () => getAllPosts(),
        child: FutureBuilder<List<PostModel>>(
            future: _postListFuture,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              List<PostModel> posts = snapshot.data ?? [];
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  PostModel item = posts[index];
                  return PostListItem(item: item);
                },
              );
            }));
  }
}
