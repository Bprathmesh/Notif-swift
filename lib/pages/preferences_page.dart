import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final _firestore = FirebaseFirestore.instance;
  bool _receivePromotions = false;

  Future<void> _savePreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'receivePromotions': _receivePromotions,
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification Preferences')),
      body: Column(
        children: <Widget>[
          SwitchListTile(
            title: Text('Receive Promotions'),
            value: _receivePromotions,
            onChanged: (bool value) {
              setState(() {
                _receivePromotions = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: _savePreferences,
            child: Text('Save Preferences'),
          ),
        ],
      ),
    );
  }
}
