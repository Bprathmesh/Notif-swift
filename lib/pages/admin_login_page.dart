// lib/pages/admin_login_page.dart

import 'package:flutter/material.dart';
import 'package:mypushnotifications/services/admin_auth_service.dart';
import 'package:mypushnotifications/pages/admin_page.dart';
import 'package:mypushnotifications/generated/l10n.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (AdminAuthService.verifyAdminPassword(_passwordController.text)) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).invalidAdminPassword)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).adminLogin),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.of(context).adminPassword,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).pleaseEnterPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text(S.of(context).login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}