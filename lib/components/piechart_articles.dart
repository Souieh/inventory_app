import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/services/db_helper.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

enum LegendShape { circle, rectangle }

class PieChartArticles extends StatefulWidget {
  const PieChartArticles({Key? key}) : super(key: key);

  @override
  PieChartArticlesState createState() => PieChartArticlesState();
}

class PieChartArticlesState extends State<PieChartArticles> {
  late final session = Provider.of<SessionManager>(context, listen: false);
  var _counts = <String, double>{
    'New': 0,
    'Good': 0,
    'Working': 0,
    'Needs Repair': 0,
    'Broken': 0,
    'Unknown': 0,
  };

  final colorList = <Color>[
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.amber,
    Colors.red,
    Colors.grey,
  ];

  Future<void> getConditionCounts() async {
    final articles = await DBHelper().getArticles(
      agentCode: session.user?.role == 'agent' ? session.user?.code : null,
    );
    final counts = <String, double>{
      'New': 0,
      'Good': 0,
      'Working': 0,
      'Needs Repair': 0,
      'Broken': 0,
      'Unknown': 0,
    };

    for (final article in articles) {
      final String? condition = article.condition;
      if (condition != null && counts.containsKey(condition)) {
        counts[condition] = counts[condition]! + 1;
      } else {
        counts['Unknown'] = counts['Unknown']! + 1;
      }
    }
    setState(() {
      _counts = counts;
    });
  }

  @override
  void initState() {
    super.initState();
    getConditionCounts();
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final chart = PieChart(
      dataMap: _counts,
      animationDuration: const Duration(milliseconds: 800),
      chartRadius: math.min(MediaQuery.of(context).size.width / 3.2, 300),
      colorList: colorList,
      emptyColor: Colors.grey,
      emptyColorGradient: const [Color(0xff6c5ce7), Colors.blue],
      baseChartColor: Colors.transparent,
    );
    return Column(children: [Text(t.articlesStatus), chart]);
  }
}
