import 'package:cloud_functions/cloud_functions.dart';

Future<bool> sendPersonalizedNotification(String userId) async {
  try {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'sendPersonalizedNotification',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 30),
      ),
    );
    final result = await callable.call(<String, dynamic>{
      'userId': userId,
    });
    print('Notification sent successfully: ${result.data}');
    return true;
  } catch (e) {
    print('Error sending personalized notification: $e');
    return false;
  }
}