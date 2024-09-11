import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _receivePromotions = false;
  bool _receiveUpdates = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final userId = _auth.currentUser!.uid;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final data = userDoc.data();

    setState(() {
      _receivePromotions = data?['receivePromotions'] ?? false;
      _receiveUpdates = data?['receiveUpdates'] ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final userId = _auth.currentUser!.uid;

    await _firestore.collection('users').doc(userId).update({
      'receivePromotions': _receivePromotions,
      'receiveUpdates': _receiveUpdates,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: const Text('Receive Promotions'),
              value: _receivePromotions,
              onChanged: (bool value) {
                setState(() {
                  _receivePromotions = value;
                });
                _savePreferences();
              },
            ),
            SwitchListTile(
              title: const Text('Receive Updates'),
              value: _receiveUpdates,
              onChanged: (bool value) {
                setState(() {
                  _receiveUpdates = value;
                });
                _savePreferences();
              },
            ),
          ],
        ),
      ),
    );
  }
}
