import 'package:flutter/material.dart';

import '../commons/custom_container.dart';

class UnreadComponent extends StatelessWidget{
  final int count;

  const UnreadComponent({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return count==0
        ?const SizedBox()
        :CircleAvatar(
      radius: 12,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(count.toString(),
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,)),
        );
  }
}