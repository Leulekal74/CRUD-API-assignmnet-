import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/assignment_provider.dart';
import 'screens/assignment_dashboard_screen.dart';

void main() {
  runApp(const AAiTTrackerApp());
}

class AAiTTrackerApp extends StatelessWidget {
  const AAiTTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssignmentProvider()..loadTasks(),
      child: MaterialApp(
        title: 'AAiT Task Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blueGrey, // Sleek, institutional engineering theme
        ),
        home: const AssignmentDashboardScreen(),
      ),
    );
  }
}