import 'package:orange_chat/components/user-filter/age.dart';
import 'package:orange_chat/components/user-filter/gender.dart';
import 'package:orange_chat/models/supabase/place.dart';
import 'package:orange_chat/models/supabase/filter.dart';
import 'package:orange_chat/views/user-list/user_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/commons/input_place.dart';

class UserFilterScreen extends StatefulWidget {
  const UserFilterScreen({super.key});

  @override
  State<UserFilterScreen> createState() => _UserFilterScreenState();
}

class _UserFilterScreenState extends State<UserFilterScreen> {
  late Future<FilterModel> _filterModel; // これをしないとFutureBuilderが何度も呼ばれる

  @override
  void initState() {
    super.initState();
    _filterModel = FilterModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FilterModel>(
        future: _filterModel,
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          FilterModel userFilter = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text("User Filter"),
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context, true,);
                },
                icon: const Icon(Icons.close_rounded),
              ),
              actions: [
                TextButton(
                  child: const Text("Search"),
                  onPressed: () {
                    // フィルター条件を保存して前の画面に戻る
                    userFilter.save();
                    Navigator.pop(context, true); // 引数のtrueは再描画に必要
                  },
                ),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16,),
              constraints: const BoxConstraints(maxWidth: 400),
              child: ListView(
                children: [
                  _SingleSection(
                    title: "Gender",
                    children: [
                      GenderList(userFilter: userFilter,),
                    ],
                  ),
                  _SingleSection(
                    title: "Age",
                    children: [
                      AgeFilter(userFilter: userFilter,),
                    ],
                  ),
                  _SingleSection(
                    title: "Place",
                    children: [
                      InputPlace(isState: false, placeModel: userFilter.placeModel,),
                      InputPlace(isState: true, placeModel: userFilter.placeModel,),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class _SingleSection extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const _SingleSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  State<_SingleSection> createState() => _SingleSectionState();
}

class _SingleSectionState extends State<_SingleSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
