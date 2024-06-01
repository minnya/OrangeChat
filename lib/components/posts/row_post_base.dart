import 'dart:async';

import 'package:orange_chat/components/commons/photo_preview_round.dart';
import 'package:orange_chat/components/commons/bottom_report_block.dart';
import 'package:orange_chat/components/commons/photo_full_preview.dart';
import 'package:orange_chat/components/posts/like_button.dart';
import 'package:orange_chat/components/posts/reply_button.dart';
import 'package:orange_chat/helpers/supabase/post_model_helper.dart';
import 'package:orange_chat/models/supabase/posts.dart';
import 'package:orange_chat/views/posts/posts.dart';
import 'package:orange_chat/views/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../tools/time_diff.dart';

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
        Expanded(
            child: RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(children: [
            TextSpan(
              text: widget.item.user.name,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ]),
        )),
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
