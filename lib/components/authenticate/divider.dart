import 'package:flutter/material.dart';
import 'package:orange_chat/components/commons/custom_container.dart';

class TextDivider extends StatelessWidget {
  final String text;
  final Alignment? alignment;
  const TextDivider(
      {super.key, required this.text, this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        alignment == Alignment.centerLeft
            ? Container()
            : const CustomContainer(
                expand: true,
                padding: EdgeInsets.only(right: 8),
                children: [
                  Divider(
                    thickness: 1, // 線の太さ
                    color: Colors.grey, // 線の色
                  )
                ],
              ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        alignment == Alignment.centerRight
            ? Container()
            : CustomContainer(
                expand: true,
                padding: const EdgeInsets.only(left: 8),
                children: [
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
      ],
    );
  }
}
