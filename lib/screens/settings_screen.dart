import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/components/theme_provider.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/main.dart';
import 'package:inventory_app/providers/dev_mode_provider.dart';
import 'package:inventory_app/services/db_helper.dart';
import 'package:inventory_app/services/export_data_as_excel.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<DateTime> _tapTimes = [];
  Future<void> _changePasswordDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final t = S.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.change_password),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: t.password_label,
              border: const OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) => (value == null || value.length < 4)
                ? t.password_validation
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                final session = context.read<SessionManager>();
                final user = session.user;
                if (user != null) {
                  user.password = passwordController.text.trim();
                  await DBHelper().updateUser(user);
                  if (context.mounted) {
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(t.password_updated)));
                  }
                }
              }
            },
            child: Text(t.save),
          ),
        ],
      ),
    );

    if (result == null || !result) return;
  }

  Future<void> _confirmResetDB(BuildContext context) async {
    final t = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.reset_database),
        content: Text(t.reset_db_confirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(t.reset),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DBHelper().clearDatabase();
      if (context.mounted) {
        await context.read<SessionManager>().logout();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.reset_database} successfully')),
        );
      }
    }
  }

  Future<void> useDummyData(BuildContext context) async {
    final t = S.of(context);
    try {
      await DBHelper().generateDummyData();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.dummy_data_added)));
        await context.read<SessionManager>().logout();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.failed_to_add_dummy_data)));
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    final t = S.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.confirm_logout),
        content: Text(t.logout_question),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.logout),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (context.mounted) {
        await context.read<SessionManager>().logout();
      }
    }
  }

  void _changeLanguage(Locale newLocale) {
    context.read<LocaleProvider>().setLocale(newLocale);
  }

  Locale _getEffectiveLocale(Locale locale) {
    const supported = ['en', 'ar'];
    if (!supported.contains(locale.languageCode)) {
      return const Locale('system');
    }
    return locale;
  }

  void handleDevTap(BuildContext context) {
    final now = DateTime.now();
    _tapTimes.add(now);

    // احتفظ فقط بالنقرات خلال آخر 10 ثواني
    _tapTimes = _tapTimes
        .where((t) => now.difference(t).inSeconds < 10)
        .toList();

    if (_tapTimes.length >= 7) {
      _tapTimes.clear();
      _showPasskeyDialog(context);
    }
  }

  Future<void> _showChangePasskeyDialog(BuildContext context) async {
    final t = S.of(context);
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.change_dev_passkey),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: t.new_passkey,
              border: const OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (val) =>
                (val == null || val.length < 4) ? t.passkey_validation : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context, true);
              }
            },
            child: Text(t.save),
          ),
        ],
      ),
    );

    if (changed == true) {
      await context.read<DevModeProvider>().changePasskey(
        controller.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.passkey_changed_success)));
    }
  }

  Future<void> _confirmDisableDevMode(BuildContext context) async {
    final t = S.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.disable_dev_mode),
        content: Text(t.disable_dev_mode_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.disable),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await context.read<DevModeProvider>().disable();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.dev_mode_disabled)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final session = context.watch<SessionManager>();
    final userCode = session.user?.code ?? 'Unknown';
    final themeProvider = context.watch<ThemeProvider>();
    final currentTheme = themeProvider.themeMode;
    final currentLocale = Localizations.localeOf(context);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // لون الخلفية من الثيم
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(t.settings),
              background: const SizedBox.shrink(),
            ),
            //   backgroundColor: Colors.transparent,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                _buildSectionCard(
                  title: t.user,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text('${t.logged_in_as} $userCode'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock_reset),
                      title: Text(t.change_password),
                      onTap: () => _changePasswordDialog(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text(t.logout),
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: t.appearance,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: Text(t.theme),
                      trailing: DropdownButton<ThemeMode>(
                        value: currentTheme,
                        onChanged: (newMode) {
                          if (newMode != null) {
                            themeProvider.setThemeMode(newMode);
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text(t.system_default),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text(t.light),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text(t.dark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: t.language,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(t.language),
                      trailing: DropdownButton<Locale>(
                        value: _getEffectiveLocale(currentLocale),
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            if (newLocale.languageCode == 'system') {
                              final systemLocale = WidgetsBinding
                                  .instance
                                  .platformDispatcher
                                  .locale;
                              final supported = ['en', 'ar'];
                              final finalLocale =
                                  supported.contains(systemLocale.languageCode)
                                  ? systemLocale
                                  : const Locale('en');
                              _changeLanguage(finalLocale);
                            } else {
                              _changeLanguage(newLocale);
                            }
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: const Locale('system'),
                            child: Text(t.system_default),
                          ),
                          DropdownMenuItem(
                            value: const Locale('en'),
                            child: Text(t.english),
                          ),
                          DropdownMenuItem(
                            value: const Locale('ar'),
                            child: Text(t.arabic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: t.data,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.file_download),
                      title: Text(t.export_excel),
                      onTap: () => exportDataAsExcel(context),
                    ),
                  ],
                ),
                if (session.isAdmin)
                  _buildSectionCard(
                    title: t.admin,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        title: Text(t.reset_database),
                        onTap: () => _confirmResetDB(context),
                      ),
                      if (kDebugMode ||
                          context.watch<DevModeProvider>().enabled)
                        ListTile(
                          leading: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.green,
                          ),
                          title: Text(t.useDummyData),
                          onTap: () => useDummyData(context),
                        ),
                    ],
                  ),
                _buildSectionCard(
                  title: t.about,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(t.app_name),
                      subtitle: const Text('Inventory Tracker'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: Text(t.version),
                      subtitle: const Text('v1.0.0'),
                      onTap: () => handleDevTap(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: Text(t.developed_by),
                      subtitle: const Text('Souieh'),
                      onTap: _openGitHub,
                    ),
                  ],
                ),
                if (context.watch<DevModeProvider>().enabled)
                  _buildSectionCard(
                    title: t.dev_mode, // أضف في ملف الترجمة "وضع المطور"
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: Text(t.change_dev_passkey),
                        onTap: () => _showChangePasskeyDialog(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.toggle_off),
                        title: Text(t.disable_dev_mode),
                        onTap: () => _confirmDisableDevMode(context),
                      ),
                    ],
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 3,
      //shadowColor: Colors.grey.withOpacity(0.2),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  void _showPasskeyDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تفعيل وضع المطور'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'رمز الدخول',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              context.read<DevModeProvider>().enable(controller.text);
              Navigator.pop(context);
            },
            child: const Text('تفعيل'),
          ),
        ],
      ),
    );
  }

  Future<void> _openGitHub() async {
    final url = Uri.parse('https://github.com/souieh');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
