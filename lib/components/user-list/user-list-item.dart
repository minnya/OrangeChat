import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/material.dart';

import '../../views/profile/profile.dart';

class UserListItem extends StatelessWidget {
  final UserModel user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white70;
    Color gradientColor;
    if(user.gender=="male"){
      gradientColor = Colors.lightBlueAccent;
    }else if(user.gender=="female"){
      gradientColor = Colors.pinkAccent;
    }else{
      gradientColor = Colors.blueGrey;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userId: user.id,
                )));
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
            children: [
              Container(
              decoration: user.iconUrl == null
                  ? null
                  : BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(user.iconUrl!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          gradientColor.withOpacity(0.0),
                          gradientColor.withOpacity(0.0),
                          gradientColor.withOpacity(0.1),
                          gradientColor.withOpacity(0.4),
                          gradientColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  DateTime.now().difference(user.updatedAt).inMinutes<5
                      ?activeLamp()
                      :const SizedBox(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.age!=null && user.age!.isNotEmpty ? "${user.name}, ${user.age}" : user.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor),
                        ),
                        Text(
                            user.prefecture??"",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor)
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ]
        ),
      ),
    );
  }

  Widget activeLamp(){
    return Positioned(
      bottom: 10,
      right: 10,
      child: CircleAvatar(
        radius: 10,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

}