import 'package:flutter/material.dart';
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/language_provider.dart';
import 'package:mypushnotifications/generated/l10n.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String _selectedLanguage = 'en';

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // Set the user's preferred language
        Provider.of<LanguageProvider>(context, listen: false).setLocale(Locale(_selectedLanguage));
        
        // Navigate to HomePage if sign-in is successful
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // Handle sign-in errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in error: $e'),  
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signIn),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 177, 68, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).welcomeBack,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: S.of(context).email,
                prefixIcon: const Icon(Icons.email),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: S.of(context).password,
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xD2FF4444), width: 2.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
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
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 177, 68, 255),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      S.of(context).signIn,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 177, 68, 255),
              ),
              child: Text(S.of(context).createAccount),
            ),
          ],
        ),
      ),
    );
  }
}