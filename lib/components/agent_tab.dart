import 'package:flutter/material.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/models/user.dart';
import 'package:inventory_app/screens/agent_add_screen.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

import '../services/db_helper.dart';

class AgentsTab extends StatefulWidget {
  const AgentsTab({super.key});

  @override
  State<AgentsTab> createState() => _AgentsTabState();
}

class _AgentsTabState extends State<AgentsTab> {
  late final session = Provider.of<SessionManager>(context, listen: false);
  List<User> _agents = [];
  bool _loading = false;
  final int _pageSize = 10;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAgents(reset: true);
  }

  Future<void> _fetchAgents({bool reset = false}) async {
    if (_loading) return;

    if (reset) {
      setState(() {
        _loading = true;
      });
    } else {
      setState(() {
        _loading = true;
      });
    }

    final newAgents = await DBHelper().getUsers(role: 'agent');

    setState(() {
      _agents = newAgents;
      _loading = false;
      _totalCount = newAgents.length;
    });
  }

  void _goToAddScreen() {
    //insertDummyAgents(); // إدراج المقالات الوهمية عند الضغط على زر المسح
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AgentAddScreen())).then((_) {
      // تحديث المقالات بعد العودة
      _fetchAgents(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _agents.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                t.noAgentsFound,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _goToAddScreen,
                icon: const Icon(Icons.person_add_alt),
                label: Text(t.addAgent),
              ),
            ],
          )
        : SingleChildScrollView(
            child: SizedBox(
              width: 800, // أو أي عرض تراه مناسب
              child: PaginatedDataTable(
                header: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8,
                    children: [
                      Text(
                        '${t.agents}: $_totalCount',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // زر الريفريش   وصغير الحجم
                      ElevatedButton.icon(
                        onPressed: () {
                          _fetchAgents(reset: true);
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(t.refresh, style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero, // يقلل الحجم الافتراضي
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),

                      // زر المسح مع نص وحجم أصغر
                      ElevatedButton.icon(
                        onPressed: _goToAddScreen,
                        icon: const Icon(Icons.person_add_alt, size: 18),
                        label: Text(t.addAgent, style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero, // يقلل الحجم الافتراضي
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                rowsPerPage: _pageSize,
                columns: const [
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Password')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Created At')),
                ],
                source: _AgentDataSource(_agents),
              ),
            ),
          );
  }
}

class _AgentDataSource extends DataTableSource {
  final List<User> agents;

  _AgentDataSource(this.agents);

  @override
  DataRow getRow(int index) {
    final agent = agents[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(agent.code)),
        DataCell(Text(agent.name)),
        DataCell(Text(agent.role ?? '(not set)')),
        DataCell(Text(agent.password ?? '(not set)')),
        DataCell(Text(agent.description ?? '(no description)')),
        DataCell(Text(agent.createdAt ?? '(not set)')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => agents.length;

  @override
  int get selectedRowCount => 0;
}
