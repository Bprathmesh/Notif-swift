import 'package:flutter/material.dart';
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/generated/l10n.dart';

class ScheduleNotificationPage extends StatefulWidget {
  const ScheduleNotificationPage({Key? key}) : super(key: key);

  @override
  _ScheduleNotificationPageState createState() => _ScheduleNotificationPageState();
}

class _ScheduleNotificationPageState extends State<ScheduleNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now().add(const Duration(minutes: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).scheduleNotification),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: S.of(context).notificationTitle),
              validator: (value) => value!.isEmpty ? S.of(context).pleaseEnterTitle : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: S.of(context).notificationBody),
              validator: (value) => value!.isEmpty ? S.of(context).pleaseEnterBody : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(S.of(context).scheduledTime),
              subtitle: Text(_selectedDateTime.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDateTime,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: Text(S.of(context).scheduleNotification),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _scheduleNotification() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await NotificationService().scheduleNotification(
            user.uid,
            _selectedDateTime,
            _titleController.text,
            _bodyController.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).notificationScheduled)),
          );
          Navigator.pop(context);
        } else {
          throw Exception('User not logged in');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).errorSchedulingNotification)),
        );
      }
    }
  }
}