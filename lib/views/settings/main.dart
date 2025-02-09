import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/main.dart';
import 'package:orange_chat/views/profile/edit_profile.dart';
import 'package:orange_chat/views/settings/block_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../billing/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            children: [
              _SingleSection(
                title: "Your Account",
                children: [
                  _CustomListTile(
                    title: "Profile",
                    icon: Icons.person_outline_rounded,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()));
                    },
                  ),
                  _CustomListTile(
                    title: "Payment",
                    icon: Icons.payment,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InAppPurchaseExample()));
                    },
                  ),
                ],
              ),
              _SingleSection(
                title: "General",
                children: [
                  _CustomListTile(
                      title: "Notifications",
                      icon: Icons.notifications_none_rounded,
                    onTap: (){
                        openAppSettings();
                    },
                  ),
                  const _CustomListTile(
                      title: "Security Status",
                      icon: CupertinoIcons.lock_shield),
                ],
              ),
              const Divider(),
              _SingleSection(
                title: "Organization",
                children: [
                  _CustomListTile(
                      title: "Messaging", icon: Icons.message_outlined),
                  _CustomListTile(title: "Calling", icon: Icons.phone_outlined),
                  _CustomListTile(
                      title: "Blocked users", icon: Icons.block_rounded,
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> BlockUsersScreen())),
                  )
                ],
              ),
              const Divider(),
              _SingleSection(
                children: [
                  const _CustomListTile(
                      title: "Help & Feedback",
                      icon: Icons.help_outline_rounded),
                  const _CustomListTile(
                      title: "About", icon: Icons.info_outline_rounded),
                  _CustomListTile(
                    title: "Sign out",
                    icon: Icons.exit_to_app_rounded,
                    onTap: () {
                      AuthHelper(context: context).logout();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const MyApp()));
                    },
                  ),
                  _CustomListTile(
                    title: "Delete account",
                    icon: Icons.delete_outlined,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    onTap: () async{
                      final bool result = await AuthHelper(context: context).delete(context: context);
                      if(result == false) return;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const MyApp()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final TextStyle? style;

  const _CustomListTile({
    required this.title,
    required this.icon,
    this.onTap,
    this.style,
    this.trailing
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: style,),
      leading: Icon(icon, color: style?.color),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
