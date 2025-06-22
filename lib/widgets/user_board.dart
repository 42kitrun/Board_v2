import 'package:amine_graph/widgets/user_comments.dart';
import 'package:amine_graph/widgets/user_fatigue_graph.dart';
import 'package:amine_graph/widgets/user_goal_graph.dart';
import 'package:amine_graph/widgets/user_health_report.dart';
import 'package:amine_graph/widgets/user_survey_graph.dart';
import 'package:flutter/material.dart';

class UserBoard extends StatelessWidget {
  const UserBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: UserComments(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                  flex: 10,
                  child: UserFatigueGraph(),
                ),
                Divider(
                  height: 10,
                ),
                Expanded(
                  flex: 7,
                  child: UserGoalGraph(), //UserGoalGraph1():도넛그래프
                ),
                Divider(
                  height: 10,
                ),
                Expanded(
                  flex: 10,
                  child: UserSurveyGraph(),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: UserHealthReport(),
            ),
          ),
        ],
      ),
    );
  }
}
