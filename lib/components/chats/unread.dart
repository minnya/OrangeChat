import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnreadComponent extends StatelessWidget{
  final int count;

  const UnreadComponent({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return count==0
        ?const SizedBox()
        :Expanded(child:Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Center(child: Text(count.toString(),
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,))),
    ));
  }
}