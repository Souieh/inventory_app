import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/db_helper.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isFirstUser = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    checkIfFirstUser();
  }

  Future<void> checkIfFirstUser() async {
    final count = await DBHelper().getUsersCount(role: "admin");
    if (kDebugMode) {
      print("Users count: $count");
    }
    setState(() {
      _isFirstUser = count == 0;
      _loading = false;
    });
  }

  void onSignUpComplete() {
    setState(() {
      _isFirstUser = false;
    });
  }

  void onClear() {
    setState(() {
      _isFirstUser = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _isFirstUser
          ? SignUpWidget(onSignUpComplete: onSignUpComplete)
          : LoginWidget(onClear: onClear),
    );
  }
}

class SignUpWidget extends StatefulWidget {
  final VoidCallback onSignUpComplete;

  const SignUpWidget({required this.onSignUpComplete, super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  void _showMessage(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _trySignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    final code = _codeController.text.trim();
    final password = _passwordController.text.trim();

    final newUser = User(
      code: code,
      password: password,
      name: 'Administrator',
      role: 'admin',
    );
    try {
      await DBHelper().insertUser(newUser);
      _showMessage(S.of(context).user_created_success);
      widget.onSignUpComplete();
    } catch (e) {
      _showMessage(S.of(context).error_creating_user(e.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            Text(
              t.create_first_user,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(labelText: t.user_code),
              validator: (val) =>
                  val == null || val.isEmpty ? t.please_enter_user_code : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: t.password),
              obscureText: true,
            ),
            _loading
                ? const CircularProgressIndicator()
                : FilledButton(
                    onPressed: _trySignUp,
                    child: Text(t.create_user),
                  ),
          ],
        ),
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  final VoidCallback onClear;

  const LoginWidget({required this.onClear, super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  void _showMessage(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _tryLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    final code = _codeController.text.trim();
    final password = _passwordController.text.trim();

    User? user = await DBHelper().getUserByCode(code);

    setState(() {
      _loading = false;
    });

    if (!context.mounted) return;

    final t = S.of(context);

    if (user == null) {
      _showMessage(t.user_not_found);
      return;
    }

    if (user.password != null && user.password!.isNotEmpty) {
      if (user.password != password) {
        _showMessage(t.incorrect_password);
        return;
      }
    }

    _showMessage(t.welcome_user(user.code));
    Provider.of<SessionManager>(context, listen: false).login(user);
  }

  Future<void> _confirmResetDB(BuildContext context) async {
    final t = S.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.reset_db),
        content: Text(t.reset_db_confirm),
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
      widget.onClear();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.db_reset_success)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/logo.png'),
              ),
              Text(
                t.user_auth,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: t.user_code),
                validator: (value) => value == null || value.isEmpty
                    ? t.please_enter_your_code
                    : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: t.password_optional),
                obscureText: true,
              ),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _tryLogin,
                        icon: const Icon(Icons.login),
                        label: Text(t.login),
                      ),
                    ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(t.reset_db),
                onTap: () => _confirmResetDB(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
