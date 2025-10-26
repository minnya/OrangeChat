import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/components/commons/star_rating.dart';
import 'package:orange_chat/components/profile/pie_chart_card.dart';
import 'package:orange_chat/helpers/supabase/score_model_helper.dart';
import 'package:orange_chat/models/supabase/score.dart';
import 'package:orange_chat/models/supabase/users.dart';

class ScoreScreen extends StatefulWidget {
  final UserModel userModel;
  const ScoreScreen({super.key, required this.userModel});
  @override
  State<ScoreScreen> createState() => _ScoreScreen();
}

class _ScoreScreen extends State<ScoreScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.userModel.name}'s Score"),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        body: FutureBuilder(
          future: ScoreModelHelper().get(widget.userModel),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return const Center(
                child: Text("No contents"),
              );
            }
            ScoreModel scoreModel = snapshot.data;
            return SingleChildScrollView(
              child: CustomContainer(
                direction: Direction.VERTICAL,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(16),
                children: [
                  StarRatingWidget(
                    starCount: 5,
                    rating: scoreModel.user.score,
                    size: Size.large,
                    alignment: Alignment.topLeft,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GridView.count(
                    crossAxisCount: 2, // 列数
                    shrinkWrap: true, // スクロールさせたくない場合
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      PieChartCard(
                        title: "Profile completeness",
                        centerLabel:
                            "${(scoreModel.profileCompleteness * 100).toInt()}%",
                        sections: [
                          PieChartSectionData(
                              value: scoreModel.profileCompleteness,
                              color: Colors.green,
                              title: ""),
                          PieChartSectionData(
                              value: 1 - scoreModel.profileCompleteness,
                              color: Colors.black12,
                              title: ""),
                        ],
                      ),
                      PieChartCard(
                          title: "Chat Review",
                          centerLabel: scoreModel.chatReviewGood == 0 &&
                                  scoreModel.chatReviewOkay == 0 &&
                                  scoreModel.chatReviewBad == 0
                              ? "N/A"
                              : "",
                          sections: [
                            PieChartSectionData(
                              value: scoreModel.chatReviewGood,
                              color: Colors.green,
                              radius: 20,
                              title: '😊',
                              titleStyle: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            PieChartSectionData(
                              value: scoreModel.chatReviewOkay,
                              color: Colors.lightGreen,
                              radius: 20,
                              title: '🙂',
                            ),
                            PieChartSectionData(
                              value: scoreModel.chatReviewBad,
                              color: Colors.red,
                              radius: 20,
                              title: '☹',
                            ),
                          ]),
                      PieChartCard(
                        title: "Message Read Rate",
                        centerLabel:
                            "${(scoreModel.replayRate * 100).toInt()}%",
                        sections: [
                          PieChartSectionData(
                              value: scoreModel.replayRate,
                              color: Colors.green,
                              title: ""),
                          PieChartSectionData(
                              value: 1 - scoreModel.replayRate,
                              color: Colors.black12,
                              title: ""),
                        ],
                      ),
                      PieChartCard(
                          title: "Post Review",
                          centerLabel: (scoreModel.postReviewGood +
                                      scoreModel.postReviewBad) ==
                                  0
                              ? "N/A"
                              : "${((scoreModel.postReviewGood / (scoreModel.postReviewGood + scoreModel.postReviewBad)) * 100).toInt()}%",
                          sections: [
                            PieChartSectionData(
                              value: scoreModel.postReviewGood,
                              color: Colors.green,
                              title: '👍',
                            ),
                            PieChartSectionData(
                              value: scoreModel.postReviewBad,
                              color: Colors.red,
                              title: '👎',
                            ),
                          ]),
                      PieChartCard(
                          title: "Comment Review",
                          centerLabel: (scoreModel.commentReviewGood +
                                      scoreModel.commentReviewBad) ==
                                  0
                              ? "N/A"
                              : "${((scoreModel.commentReviewGood / (scoreModel.commentReviewGood + scoreModel.commentReviewBad)) * 100).toInt()}%",
                          sections: [
                            PieChartSectionData(
                              value: scoreModel.commentReviewGood,
                              color: Colors.green,
                              title: '👍',
                            ),
                            PieChartSectionData(
                              value: scoreModel.commentReviewBad,
                              color: Colors.red,
                              title: '👎',
                            ),
                          ]),
                      PieChartCard(
                          title: "Blocked by",
                          centerLabel: "${scoreModel.blockUsers} users",
                          sections: [
                            PieChartSectionData(
                              value: scoreModel.blockUsers.toDouble(),
                              color: scoreModel.blockUsers < 3
                                  ? Colors.orange
                                  : Colors.red,
                              title: '',
                            ),
                            PieChartSectionData(
                              value: 5 - scoreModel.blockUsers.toDouble(),
                              color: scoreModel.blockUsers != 0
                                  ? Colors.black12
                                  : Colors.green,
                              title: '',
                            ),
                          ]),
                      PieChartCard(
                          title: "Blocked Posts",
                          centerLabel: "${scoreModel.blockPosts}",
                          sections: [
                            PieChartSectionData(
                              value: scoreModel.blockPosts.toDouble(),
                              color: scoreModel.blockPosts < 10
                                  ? Colors.orange
                                  : Colors.red,
                              title: '',
                            ),
                            PieChartSectionData(
                              value: 20 - scoreModel.blockUsers.toDouble(),
                              color: scoreModel.blockPosts != 0
                                  ? Colors.black12
                                  : Colors.green,
                              title: '',
                            ),
                          ]),
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
