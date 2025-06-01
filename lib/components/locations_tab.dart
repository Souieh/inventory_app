import 'package:flutter/material.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/screens/location_add_screen.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../services/db_helper.dart';

class LocationsTab extends StatefulWidget {
  const LocationsTab({super.key});

  @override
  State<LocationsTab> createState() => _LocationsTabState();
}

class _LocationsTabState extends State<LocationsTab> {
  late final session = Provider.of<SessionManager>(context, listen: false);
  List<Location> _locations = [];
  bool _loading = false;
  final int _pageSize = 20;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalCount();
    _fetchLocations(reset: true);
  }

  Future<void> _loadTotalCount() async {
    final count = await DBHelper().getLocationsCount(
      agentCode: session.user?.role == 'agent' ? session.user?.code : null,
    );
    setState(() {
      _totalCount = count;
    });
  }

  Future<void> _fetchLocations({bool reset = false}) async {
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

    final newLocations = await DBHelper().getLocations(
      agentCode: session.user?.role == 'agent' ? session.user?.code : null,
    );

    setState(() {
      _locations = newLocations;
      _loading = false;
    });
  }

  void _goToAddScreen() {
    //insertDummyLocations(); // إدراج المقالات الوهمية عند الضغط على زر المسح
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LocationAddScreen()))
        .then((_) {
          // تحديث المقالات بعد العودة
          _loadTotalCount();
          _fetchLocations(reset: true);
        });
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _locations.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                t.noLocationsFound,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _goToAddScreen,
                icon: const Icon(Icons.barcode_reader),
                label: Text(t.addLocation),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        '${t.locations}: $_totalCount',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _fetchLocations(reset: true);
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(t.refresh),
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
                        icon: const Icon(Icons.barcode_reader, size: 18),
                        label: Text(t.addLocation),
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
                  DataColumn(label: Text('Occupation')),
                  DataColumn(label: Text('Agent Code')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Created At')),
                ],
                source: _LocationDataSource(_locations),
              ),
            ),
          );
  }
}

class _LocationDataSource extends DataTableSource {
  final List<Location> locations;

  _LocationDataSource(this.locations);

  @override
  DataRow getRow(int index) {
    final location = locations[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(location.code)),
        DataCell(Text(location.name)),
        DataCell(Text(location.occupation ?? '')),
        DataCell(Text(location.agentCode)),
        DataCell(Text(location.description ?? '')),
        DataCell(Text(location.createdAt ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => locations.length;

  @override
  int get selectedRowCount => 0;
}
