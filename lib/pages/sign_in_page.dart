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
        Provider.of<LanguageProvider>(context, listen: false).setLocale(Locale(_selectedLanguage));
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.of(context).signIn),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 154, 27, 227), // Deep Purple
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  S.of(context).welcomeBack,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 163, 45, 227), // Purple
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: S.of(context).email,
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 141, 45, 232)),
                    prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 138, 36, 233)),
                    filled: true,
                    fillColor: Colors.purple[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Color.fromARGB(255, 150, 37, 231)),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: S.of(context).password,
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 152, 42, 241)),
                    prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 159, 34, 236)),
                    filled: true,
                    fillColor: Colors.purple[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Color.fromARGB(255, 145, 21, 217)),
                ),
                const SizedBox(height: 30),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  dropdownColor: Colors.purple[50],
                  items: [
                    DropdownMenuItem(value: 'en', child: Text(S.of(context).english)),
                    DropdownMenuItem(value: 'es', child: Text(S.of(context).spanish)),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                  style: const TextStyle(color: Color.fromARGB(255, 174, 44, 244)),
                  icon: const Icon(Icons.language, color: Color.fromARGB(255, 151, 32, 236)),
                ),
                const SizedBox(height: 30),
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 158, 41, 242), // Purple
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          S.of(context).signIn,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 171, 0, 238),
                  ),
                  child: Text(S.of(context).createAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
