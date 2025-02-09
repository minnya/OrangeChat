
import 'package:orange_chat/views/notifications/mentioned.dart';
import 'package:orange_chat/views/notifications/my_footprint.dart';
import 'package:flutter/material.dart';

import 'footprint.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<TabItem> _tabs = [
    TabItem(label: "Footprints", page: const FootPrintScreen()),
    TabItem(label: "My Footprints", page: const MyFootPrintScreen()),
    TabItem(label: "Mentioned", page: const MentionedScreen())
  ];



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
            labelPadding: EdgeInsets.symmetric(vertical: 0.0),
            controller: _tabController,
            tabs: _tabs.map((e) => Tab(text: e.label)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
              children: _tabs.map((e) => e.page).toList()
            ));
  }
}

class TabItem{
  final String label;
  final Widget page;

  TabItem({required this.label, required this.page});
}
