import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _receivePromotions = false;
  bool _receiveUpdates = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final userId = _auth.currentUser!.uid;
    final userDoc = await _firestore.collection('users').doc(userId).get();

    setState(() {
      _receivePromotions = userDoc['receivePromotions'] ?? false;
      _receiveUpdates = userDoc['receiveUpdates'] ?? false;
    });
  }

  Future<void> _saveUserPreferences() async {
    final userId = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(userId).update({
      'receivePromotions': _receivePromotions,
      'receiveUpdates': _receiveUpdates,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Receive Promotions'),
              value: _receivePromotions,
              onChanged: (value) {
                setState(() {
                  _receivePromotions = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Receive Updates'),
              value: _receiveUpdates,
              onChanged: (value) {
                setState(() {
                  _receiveUpdates = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserPreferences,
              child: const Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
