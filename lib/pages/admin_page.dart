import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mypushnotifications/models/user.dart';
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  bool _isAdmin = false;
  bool _isLoading = true;
  final String _adminPassword = 'prathmesh';

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    setState(() => _isLoading = true);
    auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      bool isAdmin = await _authService.isUserAdmin(currentUser.uid);
      setState(() {
        _isAdmin = isAdmin;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(String userId) async {
    if (!_isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).adminPrivilegesRequired)),
      );
      return;
    }

    try {
      await _authService.deleteUser(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).userDeletedSuccessfully)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).errorDeletingUser(e.toString()))),
      );
    }
  }

  Future<void> _updateAdminStatus(User user, bool newAdminStatus) async {
    try {
      await _authService.updateAdminStatus(user.id, newAdminStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).adminStatusUpdated)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).errorUpdatingAdminStatus(e.toString()))),
      );
    }
  }

   Future<void> _requestAdminPrivileges() async {
    String enteredPassword = await _showAdminPasswordDialog();
    if (enteredPassword == _adminPassword) {
      auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await _updateAdminStatus(User(id: currentUser.uid, name: '', email: '', receivePromotions: false, receiveUpdates: false, receiveNotifications: false, fcmToken: '', interests: [], lastLogin: DateTime.now(), createdAt: DateTime.now(), preferredLanguage: '', isAdmin: true), true);
        await _checkAdminStatus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).adminPrivilegesGranted)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).incorrectAdminPassword)),
      );
    }
  }

  Future<String> _showAdminPasswordDialog() async {
    String password = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).enterAdminPassword),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            decoration: InputDecoration(hintText: S.of(context).adminPassword),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(S.of(context).submit),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
    return password;
  }

  Widget _buildUserTile(User user) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text('${S.of(context).interests}: ${user.interests.join(', ')}'),
            Text('${S.of(context).admin}: ${user.isAdmin ? S.of(context).yes : S.of(context).no}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: user.isAdmin,
              onChanged: (bool value) => _updateAdminStatus(user, value),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmationDialog(user),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).confirmDeletion),
          content: Text(S.of(context).areYouSureDeleteUser(user.name)),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(S.of(context).delete),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser(user.id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).adminPanel),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: S.of(context).changeTheme,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : !_isAdmin
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).noAdminPrivileges),
                      ElevatedButton(
                        onPressed: _requestAdminPrivileges,
                        child: Text(S.of(context).becomeAdmin),
                      ),
                    ],
                  ),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text(S.of(context).noUsersFound));
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        try {
                          User user = User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                          return _buildUserTile(user);
                        } catch (e) {
                          print('Error parsing user data: $e');
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(S.of(context).errorLoadingUser),
                              subtitle: Text('ID: ${doc.id}'),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  },
                ),
    );
  }
}