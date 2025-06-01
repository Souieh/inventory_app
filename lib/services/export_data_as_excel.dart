import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/services/db_helper.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

Future<void> exportDataAsExcel(BuildContext context) async {
  final session = context.read<SessionManager>();
  final user = session.user;
  final isAdmin = user?.role == 'admin';
  final userCode = user?.code;

  final excel = Excel.createExcel();

  // 1. تجميع البيانات من DB
  final articles = await DBHelper().getArticles(
    agentCode: isAdmin ? null : userCode,
  );

  final locations = await DBHelper().getLocations(
    agentCode: isAdmin ? null : userCode,
  );

  final agents = isAdmin ? await DBHelper().getUsers() : [];

  // 2. إنشاء ورقة Articles
  final articlesSheet = excel['Articles'];
  articlesSheet.appendRow([
    TextCellValue("Code"),
    TextCellValue('Name'),
    TextCellValue('Condition'),
    TextCellValue('Location'),
    TextCellValue('Category'),
    TextCellValue("Qte"),
    TextCellValue('Description'),
    TextCellValue('AgentCode'),
    TextCellValue('CreatedAt'),
  ]);
  for (var article in articles) {
    articlesSheet.appendRow([
      TextCellValue(article.code),
      TextCellValue(article.name),
      TextCellValue(article.condition ?? ''),
      TextCellValue(article.location ?? ''),
      TextCellValue(article.category ?? ''),
      IntCellValue(article.quantity),
      TextCellValue(article.description ?? ''),
      TextCellValue(article.agentCode),
      TextCellValue(article.createdAt.toString()),
      // أضف هنا باقي الحقول التي تريد تصديرها
    ]);
  }

  // 3. إنشاء ورقة Locations
  final locationsSheet = excel['Locations'];
  locationsSheet.appendRow([
    TextCellValue("Code"),
    TextCellValue('Name'),
    TextCellValue('Description'),
    TextCellValue('AgentCode'),
    TextCellValue('CreatedAt'),
  ]);
  for (var location in locations) {
    locationsSheet.appendRow([
      TextCellValue(location.code),
      TextCellValue(location.name),
      TextCellValue(location.description ?? ''),
      TextCellValue(location.agentCode),
      TextCellValue(location.createdAt.toString()),
      // أضف هنا باقي الحقول التي تريد تصديرها
    ]);
  }

  // 4. إنشاء ورقة Agents فقط لو أدمين
  if (isAdmin) {
    final agentsSheet = excel['Agents'];
    agentsSheet.appendRow([
      TextCellValue("Code"),
      TextCellValue('Name'),
      TextCellValue('Role'),
      TextCellValue('Description'),
      TextCellValue('CreatedAt'),
    ]);
    for (var agent in agents) {
      agentsSheet.appendRow([
        TextCellValue(agent.code),
        TextCellValue(agent.name),
        TextCellValue(agent.description ?? ''),
        TextCellValue(agent.role ?? ''),
        TextCellValue(agent.createdAt.toString()),
      ]);
    }
  }

  // 5. حفظ الملف في مجلد التنزيلات أو ملفات التطبيق
  final bytes = (excel.encode());
  if (bytes == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate Excel file')),
      );
    }
    return;
  }

  String? outputPath = await FilePicker.platform.saveFile(
    dialogTitle: 'Save Excel File',
    fileName: 'inventory_data.xlsx',
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
    bytes: Uint8List.fromList(bytes),
  );

  if (outputPath != null) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('File saved successfully')));
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('File saving cancelled')));
    }
  }
  // يمكن هنا إضافة كود لمشاركة الملف أو فتحه باستخدام مكتبة مثل open_file
}
