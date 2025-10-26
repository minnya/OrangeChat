import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orange_chat/helpers/supabase/user_review_model_helper.dart';
import 'package:orange_chat/models/supabase/rooms.dart';

// アラートダイアログを表示します
// OKを押した場合trueを、cancelを押した場合falseを返します
Future<bool> showReviewDialog({
  required BuildContext context,
  required RoomModel roomModel,
}) async {
  bool result = false;

  if (context.mounted) {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text("How do you rate ${roomModel.name}?",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        result = await UserReviewModelHelper()
                            .submit(score: 1, roomModel: roomModel);
                        if (!result || !context.mounted) return;
                        Navigator.pop(context);
                      },
                      label: const Text("Good"),
                      icon: const Icon(Icons.sentiment_satisfied)),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        result = await UserReviewModelHelper()
                            .submit(score: 0, roomModel: roomModel);
                        if (!result || !context.mounted) return;
                        Navigator.pop(context);
                      },
                      label: const Text("Okay"),
                      icon: const Icon(Icons.sentiment_neutral)),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      result = await UserReviewModelHelper()
                          .submit(score: -1, roomModel: roomModel);
                      if (!result || !context.mounted) return;
                      Navigator.pop(context);
                    },
                    label: const Text("Not good"),
                    icon: const Icon(Icons.sentiment_dissatisfied),
                  ),
                ],
              ),
            ));
  }
  return result;
}
