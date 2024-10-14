import 'package:attendanceapp/database/db.dart';
import 'package:attendanceapp/screens/attendance_screen.dart';
import 'package:attendanceapp/screens/student_screen.dart';
import 'package:attendanceapp/widgets/icon_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? DBRef;

  @override
  void initState() {
    super.initState();
    DBRef = DBHelper.dbInstance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance App",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/banner.png',
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // GridView for buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                padding: const EdgeInsets.all(8),
                children: [
                  NavIconButton(
                    title: "Students",
                    next: StudentScreen(),
                    icon: Icon(
                      Icons.school,
                      color: Colors.blue.shade700,
                      size: 32,
                    ),
                  ),
                  NavIconButton(
                    title: "Groups",
                    next: const AttendanceScreen(),
                    icon: Icon(
                      Icons.group,
                      color: Colors.blue.shade700,
                      size: 32,
                    ),
                  ),
                  NavIconButton(
                    title: "Attendance",
                    next: const AttendanceScreen(),
                    icon: Icon(
                      Icons.contacts_outlined,
                      color: Colors.blue.shade700,
                      size: 32,
                    ),
                  ),
                  NavIconButton(
                    title: "Export",
                    next: const AttendanceScreen(),
                    icon: Icon(
                      CupertinoIcons.share_solid,
                      color: Colors.blue.shade700,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
