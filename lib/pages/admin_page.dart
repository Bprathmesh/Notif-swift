import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mypushnotifications/models/user.dart';
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';
import 'package:fl_chart/fl_chart.dart';

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

  // Analytics data
  int _totalUsers = 0;
  int _activeUsers = 0;
  Map<String, int> _userInterests = {};
  List<MapEntry<DateTime, int>> _userSignups = [];
  Map<String, int> _notificationStats = {};
  Map<String, int> _userActivityStats = {};
  Map<String, int> _preferenceStats = {};

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
      if (isAdmin) {
        await _loadAnalytics();
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAnalytics() async {
  try {
    setState(() => _isLoading = true);

    QuerySnapshot userSnapshot = await _firestore.collection('users').get();
    
    _totalUsers = userSnapshot.size;
    print("Total users: $_totalUsers");

    DateTime now = DateTime.now();
    DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));

    _activeUsers = userSnapshot.docs.where((doc) {
      try {
        Timestamp? lastLogin = doc.get('lastLogin') as Timestamp?;
        return lastLogin != null && now.difference(lastLogin.toDate()).inDays <= 30;
      } catch (e) {
        print('Error processing lastLogin for user ${doc.id}: $e');
        return false;
      }
    }).length;
    print("Active users: $_activeUsers");

    _userInterests = {};
    for (var doc in userSnapshot.docs) {
      try {
        List<String> interests = List<String>.from(doc.get('interests') ?? []);
        for (var interest in interests) {
          _userInterests[interest] = (_userInterests[interest] ?? 0) + 1;
        }
      } catch (e) {
        print('Error processing interests for user ${doc.id}: $e');
      }
    }
    print("User interests: $_userInterests");

    _userSignups = List.generate(30, (index) {
      DateTime date = thirtyDaysAgo.add(Duration(days: index));
      int count = userSnapshot.docs.where((doc) {
        try {
          Timestamp? createdAt = doc.get('createdAt') as Timestamp?;
          return createdAt != null &&
                createdAt.toDate().isAfter(date) &&
                createdAt.toDate().isBefore(date.add(Duration(days: 1)));
        } catch (e) {
          print('Error processing createdAt for user ${doc.id}: $e');
          return false;
        }
      }).length;
      return MapEntry(date, count);
    });
    print("User signups: $_userSignups");

    _calculateNotificationStats(userSnapshot);
    _calculateUserActivityStats(userSnapshot);
    _calculatePreferenceStats(userSnapshot);

    setState(() => _isLoading = false);
  } catch (e) {
    print("Error loading analytics: $e");
    setState(() => _isLoading = false);
  }
}
  void _calculateNotificationStats(QuerySnapshot userSnapshot) {
  int totalNotifications = 0;
  int totalRead = 0;

  for (var doc in userSnapshot.docs) {
    try {
      List<dynamic> notifications = doc.get('notifications') as List<dynamic>? ?? [];
      totalNotifications += notifications.length;
      totalRead += notifications.where((n) => n['read'] == true).length;
    } catch (e) {
      print('Error processing notifications for user ${doc.id}: $e');
      // If 'notifications' field doesn't exist, we just continue to the next user
      continue;
    }
  }

  _notificationStats = {
    'total': totalNotifications,
    'read': totalRead,
    'unread': totalNotifications - totalRead,
  };
  print("Notification stats: $_notificationStats");
}
  
  void _calculateUserActivityStats(QuerySnapshot userSnapshot) {
  Map<String, int> activityLevels = {
    'high': 0,
    'medium': 0,
    'low': 0,
  };

  DateTime now = DateTime.now();
  for (var doc in userSnapshot.docs) {
    try {
      Timestamp? lastLogin = doc.get('lastLogin') as Timestamp?;
      if (lastLogin != null) {
        int daysSinceLastLogin = now.difference(lastLogin.toDate()).inDays;
        if (daysSinceLastLogin <= 7) {
          activityLevels['high'] = (activityLevels['high'] ?? 0) + 1;
        } else if (daysSinceLastLogin <= 30) {
          activityLevels['medium'] = (activityLevels['medium'] ?? 0) + 1;
        } else {
          activityLevels['low'] = (activityLevels['low'] ?? 0) + 1;
        }
      } else {
        activityLevels['low'] = (activityLevels['low'] ?? 0) + 1;
      }
    } catch (e) {
      print('Error processing activity for user ${doc.id}: $e');
      activityLevels['low'] = (activityLevels['low'] ?? 0) + 1;
    }
  }

  _userActivityStats = activityLevels;
  print("User activity stats: $_userActivityStats");
}
void _calculatePreferenceStats(QuerySnapshot userSnapshot) {
  int receiveNotifications = 0;
  int receivePromotions = 0;
  int receiveUpdates = 0;

  for (var doc in userSnapshot.docs) {
    try {
      if (doc.get('receiveNotifications') == true) receiveNotifications++;
      if (doc.get('receivePromotions') == true) receivePromotions++;
      if (doc.get('receiveUpdates') == true) receiveUpdates++;
    } catch (e) {
      print('Error processing preferences for user ${doc.id}: $e');
    }
  }

  _preferenceStats = {
    'receiveNotifications': receiveNotifications,
    'receivePromotions': receivePromotions,
    'receiveUpdates': receiveUpdates,
  };
  print("Preference stats: $_preferenceStats");
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
      _loadAnalytics(); // Refresh analytics after deleting a user
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
      _loadAnalytics(); // Refresh analytics after updating admin status
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

  Widget _buildAnalyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).analytics, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${S.of(context).totalUsers}: $_totalUsers'),
                Text('${S.of(context).activeUsers}: $_activeUsers'),
                const SizedBox(height: 20),
                Text(S.of(context).userInterests, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                _buildInterestsChart(),
                const SizedBox(height: 20),
                Text(S.of(context).userSignups, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                _buildSignupsChart(),
                const SizedBox(height: 20),
                Text(S.of(context).notificationStats, style: Theme.of(context).textTheme.titleMedium),
                Text('${S.of(context).totalNotifications}: ${_notificationStats['total'] ?? 0}'),
                Text('${S.of(context).readNotifications}: ${_notificationStats['read'] ?? 0}'),
                Text('${S.of(context).unreadNotifications}: ${_notificationStats['unread'] ?? 0}'),
                const SizedBox(height: 20),
                Text(S.of(context).userActivityLevels, style: Theme.of(context).textTheme.titleMedium),
                Text('${S.of(context).highActivity}: ${_userActivityStats['high'] ?? 0}'),
                Text('${S.of(context).mediumActivity}: ${_userActivityStats['medium'] ?? 0}'),
                Text('${S.of(context).lowActivity}: ${_userActivityStats['low'] ?? 0}'),
                const SizedBox(height: 20),
                Text(S.of(context).userPreferences, style: Theme.of(context).textTheme.titleMedium),
                Text('${S.of(context).receiveNotifications}: ${_preferenceStats['receiveNotifications'] ?? 0}'),
                Text('${S.of(context).receivePromotions}: ${_preferenceStats['receivePromotions'] ?? 0}'),
                Text('${S.of(context).receiveUpdates}: ${_preferenceStats['receiveUpdates'] ?? 0}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsChart() {
    return Container(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: _userInterests.entries.map((entry) {
            return PieChartSectionData(
              color: Colors.primaries[_userInterests.keys.toList().indexOf(entry.key) % Colors.primaries.length],
              value: entry.value.toDouble(),
              title: entry.key,
              radius: 100,
              titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          }).toList(),
        ),
      ),
    );
  }

Widget _buildSignupsChart() {
    if (_userSignups.isEmpty || _userSignups.every((entry) => entry.value == 0)) {
      return Container(
        height: 200,
        child: Center(
          child: Text(S.of(context).noSignupsInPeriod),
        ),
      );
    }

    double maxY = _userSignups.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: 29,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: _userSignups.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
              }).toList(),
              isCurved: true,
              color: Theme.of(context).primaryColor,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true, 
                color: Theme.of(context).primaryColor.withOpacity(0.3)
              ),
            ),
          ],
        ),
      ),
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
              : RefreshIndicator(
                  onRefresh: _loadAnalytics,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAnalyticsSection(),
                          SizedBox(height: 20),
                          Text("${S.of(context).userList} ($_totalUsers)", style: Theme.of(context).textTheme.headlineSmall),
                          SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
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

                              List<User> users = snapshot.data!.docs.map((doc) {
                                try {
                                  return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                                } catch (e) {
                                  print('Error parsing user data: $e');
                                  return User(id: doc.id, name: 'Error', email: '', receivePromotions: false, receiveUpdates: false, receiveNotifications: false, fcmToken: '', interests: [], lastLogin: DateTime.now(), createdAt: DateTime.now(), preferredLanguage: '', isAdmin: false);
                                }
                              }).toList();

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: users.length,
                                itemBuilder: (context, index) => _buildUserTile(users[index]),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}