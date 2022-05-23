import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static const route = '/dashboard';
  final VoidCallback onSignOut;

  DashboardScreen({
    required this.onSignOut,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Dashboard: Not yet implemented!'));
  }
}
