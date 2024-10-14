import 'package:attendanceapp/database/db.dart';
import 'package:attendanceapp/utility/functons.dart';
import 'package:attendanceapp/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  var dateController = TextEditingController();
  List<Map>? studentList;
  var attendanceSheet = [{}];
  var readonly = false;

  void getAttendanceSheet() async {
    studentList = await DBHelper.dbInstance.getStudents();
    dateController.text = DateFormat('dd/MM/yy').format(DateTime.now());
    attendanceSheet = studentList!
        .map((student) => {
              'roll_no': student['roll_no'],
              'name': student['name'],
              'surname': student['surname'],
              'attending_status': 'a'
            })
        .toList();
    setState(() {});
  }

  void getPreviousAttendance() async {
    attendanceSheet = await DBHelper.dbInstance
        .getStudentAttendence(date: dateController.text);
    if (attendanceSheet.isNotEmpty) {
      readonly = true;
    } else {
      readonly = false;
      getAttendanceSheet();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAttendanceSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Date:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: MyAdjustableDateField(
                    controller: dateController,
                    hintText: "Choose Date",
                    current: true,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (!readonly) {
                      var inserted = await DBHelper.dbInstance
                          .markStudentAttendence(
                              attendance: attendanceSheet,
                              date: dateController.text);
                      if (inserted) {
                        var data = await DBHelper.dbInstance
                            .getStudentAttendence(date: dateController.text);
                        readonly = true;
                        setState(() {});
                      }
                    } else {
                      getPreviousAttendance();
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                      backgroundColor: !readonly
                          ? Colors.blue.shade700
                          : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: Text(
                    !readonly ? "Save" : "View",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceSheet.length,
                itemBuilder: (context, index) {
                  var student = attendanceSheet[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            student['roll_no'].toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${capitalize(student['name'])} ${capitalize(student['surname'])}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!readonly) {
                                student['attending_status'] =
                                    student['attending_status'] != 'p'
                                        ? 'p'
                                        : 'a';
                                setState(() {});
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    student['attending_status'] != 'p'
                                        ? Colors.redAccent
                                        : Colors.greenAccent.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            child: Text(
                              student['attending_status'].toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
