import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/models/user.dart' as AppUser;
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/generated/l10n.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).adminPanel),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              try {
                AppUser.User user = AppUser.User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        Text('${S.of(context).interests}: ${user.interests.join(', ')}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteUser(user.id),
                    ),
                  ),
                );
              } catch (e) {
                print('Error parsing user data: $e');
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Error loading user'),
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

  Future<void> _deleteUser(String userId) async {
    try {
      // Delete user from Firebase Authentication
      await _authService.deleteUser(userId);

      // Delete user document from Firestore
      await _firestore.collection('users').doc(userId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).userDeletedSuccessfully)),
      );
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).errorDeletingUser)),
      );
    }
  }
}