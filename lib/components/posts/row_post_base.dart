import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:orange_chat/components/commons/bottom_report_block.dart';
import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/components/commons/star_rating.dart';
import 'package:orange_chat/models/supabase/posts.dart';

class RowPostBase extends StatefulWidget {
  final PostModel item;

  const RowPostBase({super.key, required this.item});

  @override
  State<RowPostBase> createState() => _RowPostBaseState();
}

class _RowPostBaseState extends State<RowPostBase> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomContainer(
          expand: true,
          alignment: Alignment.topCenter,
          direction: Direction.HORIZONTAL,
          children: [
            RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(children: [
                TextSpan(
                  text: widget.item.user.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ]),
            ),
            const SizedBox(
              width: 8,
            ),
            StarRatingWidget(
              size: Size.small,
              starCount: 5,
              rating: widget.item.user.score,
              alignment: Alignment.topLeft,
            )
          ],
        ),
        GestureDetector(
            onTap: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  expand: false,
                  builder: (BuildContext context) => ReportBlockBottomMenu(
                        userModel: widget.item.user,
                        postModel: widget.item,
                      ));
            },
            child: const Icon(
              Icons.more_vert_outlined,
              color: Colors.grey,
            )),
      ],
    );
  }
}
