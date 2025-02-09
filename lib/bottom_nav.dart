import 'package:orange_chat/services/notifications.dart';
import 'package:orange_chat/services/signalling.service.dart';
import 'package:orange_chat/tools/screen.dart';
import 'package:orange_chat/views/chats/room_list.dart';
import 'package:orange_chat/views/posts/posts.dart';
import 'package:orange_chat/views/notifications/notifications.dart';
import 'package:orange_chat/views/profile/profile.dart';

import 'package:orange_chat/views/user-list/user_list.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'components/commons/custom_container.dart';

class SimpleBottomNavigation extends StatefulWidget {
  const SimpleBottomNavigation({super.key});

  @override
  State<SimpleBottomNavigation> createState() => _SimpleBottomNavigationState();
}

class _SimpleBottomNavigationState extends State<SimpleBottomNavigation> {
  int _selectedIndex = 0;
  final BottomNavigationBarType _bottomNavType = BottomNavigationBarType.fixed;

  @override
  void initState() {
    super.initState();
    //電話受信用のリスナーをセット
    SignallingService.instance.init(context: context);

    //通知を設定
    CustomNotificationSettings.init();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.titleSmall!;
    final Size screenSize = ScreenSize.get(context: context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = screenWidth > 1200 ? 1200 : screenWidth;

    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, AsyncSnapshot<AuthState> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return Scaffold(
            body: CustomContainer(
              color: Colors.white,
              direction: Direction.HORIZONTAL,
              padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth - contentWidth) / 2),
              children: [
                screenSize == Size.small
                    ? const SizedBox(
                        width: 0,
                        height: 0,
                      )
                    : NavigationRail(
                        labelType: screenSize == Size.medium
                            ? NavigationRailLabelType.selected
                            : null,
                        leading: CustomContainer(
                          direction: Direction.HORIZONTAL,
                          alignment: Alignment.centerLeft,
                          children: [
                            SizedBox(
                                width: 36,
                                child: Image.asset(
                                    "assets/images/icon_orange.png")),
                            Text(
                              "Orange",
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                        elevation: 5,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        extended: screenSize == Size.medium ? false : true,
                        minExtendedWidth: contentWidth * 0.3,
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        destinations: _menuItems
                            .map((MenuItem item) => NavigationRailDestination(
                                icon: item.icon,
                                label: Text(
                                  item.label,
                                  style: titleStyle,
                                )))
                            .toList()),
                Expanded(
                  child: LazyLoadIndexedStack(
                    index: _selectedIndex,
                    children: _menuItems.map((e) => e.page).toList(),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: screenSize != Size.small
                ? null
                : BottomNavigationBar(
                    currentIndex: _selectedIndex,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    unselectedItemColor: Theme.of(context).colorScheme.outline,
                    selectedLabelStyle: Theme.of(context).textTheme.bodySmall,
                    unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
                    showUnselectedLabels: false,
                    type: _bottomNavType,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    items: _menuItems
                        .map((MenuItem item) => BottomNavigationBarItem(
                            icon: item.icon,
                            activeIcon: item.activeIcon,
                            label: item.label))
                        .toList(),
                  ),
          );
        });
  }
}

class MenuItem {
  Icon icon;
  Icon activeIcon;
  String label;
  Widget page;

  MenuItem(
      {required this.icon,
      required this.activeIcon,
      required this.label,
      required this.page});
}

List<MenuItem> _menuItems = [
  MenuItem(
    icon: const Icon(Icons.home_outlined),
    activeIcon: const Icon(Icons.home_rounded),
    label: 'Posts',
    page: const PostScreen(),
  ),
  MenuItem(
    icon: const Icon(Icons.search_outlined),
    activeIcon: const Icon(Icons.search_rounded),
    label: 'Users',
    page: const UserListScreen(),
  ),
  MenuItem(
    icon: const Icon(Icons.chat_outlined),
    activeIcon: const Icon(Icons.chat_rounded),
    label: 'Chats',
    page: const RoomListScreen(),
  ),
  MenuItem(
    icon: const Icon(Icons.notifications_outlined),
    activeIcon: const Icon(Icons.notifications_rounded),
    label: 'Notifications',
    page: const NotificationScreen(),
  ),
  MenuItem(
    icon: const Icon(Icons.person_outline),
    activeIcon: const Icon(Icons.person_rounded),
    label: 'Profile',
    page: const ProfileScreen(),
  )
];
