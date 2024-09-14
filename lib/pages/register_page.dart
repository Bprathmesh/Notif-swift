import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/language_provider.dart';
import 'package:mypushnotifications/generated/l10n.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _receivePromotions = false;
  bool _receiveUpdates = false;
  bool _receiveNotifications = false;
  String _selectedLanguage = 'en';

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        final fcmToken = await FirebaseMessaging.instance.getToken();

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'name': _nameController.text,
          'fcmToken': fcmToken,
          'receivePromotions': _receivePromotions,
          'receiveUpdates': _receiveUpdates,
          'receiveNotifications': _receiveNotifications,
          'createdAt': FieldValue.serverTimestamp(),
          'preferredLanguage': _selectedLanguage,
          'interests': [], // Initialize with an empty list
        });

        // Set the user's preferred language
        Provider.of<LanguageProvider>(context, listen: false).setLocale(Locale(_selectedLanguage));

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).registrationFailed(e.toString()))),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).register)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: S.of(context).name),
                validator: (value) => value!.isEmpty ? S.of(context).pleaseEnterName : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: S.of(context).email),
                validator: (value) => value!.isEmpty ? S.of(context).pleaseEnterEmail : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: S.of(context).password),
                obscureText: true,
                validator: (value) => value!.length < 6 ? S.of(context).passwordMustBe6Chars : null,
              ),
              SwitchListTile(
                title: Text(S.of(context).receiveNotifications),
                value: _receiveNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _receiveNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text(S.of(context).receivePromotions),
                value: _receivePromotions,
                onChanged: (bool value) {
                  setState(() {
                    _receivePromotions = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text(S.of(context).receiveUpdates),
                value: _receiveUpdates,
                onChanged: (bool value) {
                  setState(() {
                    _receiveUpdates = value;
                  });
                },
              ),
              DropdownButton<String>(
                value: _selectedLanguage,
                items: [
                  DropdownMenuItem(value: 'en', child: Text(S.of(context).english)),
                  DropdownMenuItem(value: 'es', child: Text(S.of(context).spanish)),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: Text(S.of(context).register),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}