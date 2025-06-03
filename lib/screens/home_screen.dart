import 'package:flutter/material.dart';
import 'package:inventory_app/components/agent_tab.dart';
import 'package:inventory_app/components/articles_tab.dart';
import 'package:inventory_app/components/dashboard_tab.dart';
import 'package:inventory_app/components/locations_tab.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/screens/settings_screen.dart';
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

  Future<void> _onWillPop(bool didPop, Object? result) async {
    if (didPop) {
      return;
    }
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
    ) ?? false;
    if(shouldExit){
        if(context.mounted && mounted){
      Navigator.pop(context);}
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: session.isAdmin ? 4 : 3,
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onWillPop,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // AppBar العلوي القابل للإخفاء
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 12,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        Text(userCode),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // TabBar المثبت دائمًا
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(24),

                    ),
                     indicatorPadding: EdgeInsets.only(bottom: 20),
                    unselectedLabelColor: Colors.grey,
                    padding: EdgeInsets.only(top: 24),
                    controller: _tabController,
                    textScaler: TextScaler.linear(0.8),

                    tabs: [
                      Tab(text: t.dashboard, icon: Icon(Icons.dashboard)),
                      Tab(text: t.articles, icon: Icon(Icons.inventory)),
                      Tab(text: t.locations, icon: Icon(Icons.location_on)),
                      if (session.isAdmin)
                        Tab(text: t.agents, icon: Icon(Icons.group)),
                    ],
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return false;
  }
}
