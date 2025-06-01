import 'package:flutter/material.dart';
import 'package:inventory_app/components/piechart_articles.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/services/db_helper.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

class DashboardTab extends StatefulWidget {
  final TabController tabController;

  const DashboardTab({super.key, required this.tabController});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  late final session = Provider.of<SessionManager>(context, listen: false);
  int _articleCount = 0;
  int _locationCount = 0;
  int _agentCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final articleCount = await DBHelper().getArticlesCount(
        agentCode: session.user?.role == 'agent' ? session.user?.code : null,
      );
      final locationCount = await DBHelper().getLocationsCount(
        agentCode: session.user?.role == 'agent' ? session.user?.code : null,
      );
      final agentCount = await DBHelper().getUsersCount(role: 'agent');

      if (mounted) {
        setState(() {
          _articleCount = articleCount;
          _locationCount = locationCount;
          _agentCount = agentCount;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load dashboard data: $e")),
        );
      }
    }
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              Text('$count', style: const TextStyle(fontSize: 40)),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildCard(
                            icon: Icons.location_on_outlined,
                            title: t.locations,
                            count: _locationCount,
                            onTap: () => widget.tabController.animateTo(2),
                          ),
                        ),
                        if (session.isAdmin)
                          Expanded(
                            child: _buildCard(
                              icon: Icons.person_outline,
                              title: t.agents,
                              count: _agentCount,
                              onTap: () => widget.tabController.animateTo(3),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildCard(
                    icon: Icons.article_outlined,
                    title: t.articles,
                    count: _articleCount,
                    onTap: () => widget.tabController.animateTo(1),
                  ),
                  PieChartArticles(),
                ],
              ),
            ),
          );
  }
}
