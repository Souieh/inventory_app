import 'package:flutter/material.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/screens/article_add_screen.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../services/db_helper.dart';

class ArticlesTab extends StatefulWidget {
  const ArticlesTab({super.key});

  @override
  State<ArticlesTab> createState() => _ArticlesTabState();
}

class _ArticlesTabState extends State<ArticlesTab> {
  late final session = Provider.of<SessionManager>(context, listen: false);
  List<Article> _articles = [];
  bool _loading = false;
  final int _pageSize = 40;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalCount();
    _fetchArticles(reset: true);
  }

  Future<void> _loadTotalCount() async {
    final count = await DBHelper().getArticlesCount(
      agentCode: session.user?.role == 'agent' ? session.user?.code : null,
    );
    setState(() {
      _totalCount = count;
    });
  }

  Future<void> _fetchArticles({bool reset = false}) async {
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

    final newArticles = await DBHelper().getArticles(
      agentCode: session.user?.role == 'agent' ? session.user?.code : null,
    );

    setState(() {
      _articles = newArticles;
      _loading = false;
    });
  }

  void _goToAddScreen() {
    //insertDummyArticles(); // إدراج المقالات الوهمية عند الضغط على زر المسح
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ArticleAddScreen()))
        .then((_) {
          // تحديث المقالات بعد العودة
          _loadTotalCount();
          _fetchArticles(reset: true);
        });
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _articles.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              Text(
                t.noArticlesFound,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              FilledButton.icon(
                onPressed: _goToAddScreen,
                icon: const Icon(Icons.barcode_reader),
                label: Text(t.addArticle),
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
                        '${t.articles}: $_totalCount',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // زر الريفريش   وصغير الحجم
                      TextButton.icon(
                        onPressed: () {
                          _fetchArticles(reset: true);
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(t.refresh, style: TextStyle(fontSize: 12)),
                      ),

                      // زر المسح مع نص وحجم أصغر
                      FilledButton.icon(
                        onPressed: _goToAddScreen,
                        icon: const Icon(Icons.barcode_reader, size: 18),
                        label: Text(
                          t.addArticle,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                rowsPerPage: _pageSize,
                columns: const [
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Qty')),
                  DataColumn(label: Text('Condition')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Agent Code')),
                ],
                source: _ArticleDataSource(_articles),
              ),
            ),
          );
  }
}

class _ArticleDataSource extends DataTableSource {
  final List<Article> articles;

  _ArticleDataSource(this.articles);

  @override
  DataRow getRow(int index) {
    final article = articles[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(article.code)),
        DataCell(Text(article.name)),
        DataCell(Text(article.quantity.toString())),
        DataCell(Text(article.condition ?? "-")),
        DataCell(Text(article.category ?? '-')),
        DataCell(Text(article.location ?? '-')),
        DataCell(Text(article.agentCode)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => articles.length;

  @override
  int get selectedRowCount => 0;
}
