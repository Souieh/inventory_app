import 'package:flutter/material.dart';
import 'package:inventory_app/components/agent_tab.dart';
import 'package:inventory_app/components/articles_tab.dart';
import 'package:inventory_app/components/dashboard_tab.dart';
import 'package:inventory_app/components/locations_tab.dart';
import 'package:inventory_app/components/settings_tab.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final session = Provider.of<SessionManager>(context, listen: false);
  late final String userCode = session.user?.code ?? 'Unknown User';
  late TabController _tabController;

  Future<bool> _onWillPop(BuildContext context) async {
    final t = S.of(context);
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.exitApp),
        content: Text(t.exit_confirmation),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.stay),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.yes),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: session.isAdmin ? 5 : 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200,
                floating: true,
                pinned: true,
                snap: true,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 80, top: 60),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      CircleAvatar(
                        maxRadius: 12,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                      Text(' $userCode'),
                    ],
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
                bottom: TabBar(
                  controller: _tabController,
                  textScaler: TextScaler.linear(0.8),
                  tabs: [
                    Tab(text: t.dashboard, icon: Icon(Icons.dashboard)),
                    Tab(text: t.articles, icon: Icon(Icons.inventory)),
                    Tab(text: t.locations, icon: Icon(Icons.location_on)),
                    if (session.isAdmin)
                      Tab(text: t.agents, icon: Icon(Icons.group)),
                    Tab(text: t.settings, icon: Icon(Icons.settings)),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              DashboardTab(tabController: _tabController),
              ArticlesTab(),
              LocationsTab(),
              if (session.isAdmin) AgentsTab(),
              SettingsTab(),
            ],
          ),
        ),
      ),
    );
  }
}
