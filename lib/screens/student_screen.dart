import 'package:attendanceapp/database/db.dart';
import 'package:attendanceapp/widgets/add_student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentScreen extends StatefulWidget {
  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  List<Map<String, dynamic>> students = [];
  DBHelper? DBRef;

  var nameController = TextEditingController();
  var surnameController = TextEditingController();
  var dateController = TextEditingController();
  var _errors = '';

  @override
  void initState() {
    super.initState();
    DBRef = DBHelper.dbInstance;
    getStudent();
  }

  void getStudent() async {
    students = await DBRef!.getStudents();
    setState(() {});
  }

  String capitalize(String data) {
    return '${data[0].toUpperCase()}${data.substring(1)}';
  }

  void closeSheet(context) {
    nameController.clear();
    surnameController.clear();
    dateController.clear();
    Navigator.pop(context);
    _errors = "";
  }

  void saveStudent(context) async {
    if (nameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty &&
        dateController.text.isNotEmpty) {
      var check = await DBRef!.addStudent(
          name: nameController.text,
          surname: surnameController.text,
          dob: dateController.text);
      if (check) {
        closeSheet(context);
        getStudent();
      }
    } else {
      _errors = "* Please fill all the required fields";
      setState(() {});
    }
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
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: students.map((student) {
            return InkWell(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => AddStudentBottomSheet(
                    DBRef: DBRef!,
                    onClose: getStudent,
                    updateStudentData: student,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  trailing: Text(
                    '0187AS2210${student['roll_no']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  title: Text(
                    "${capitalize(student['name'])} ${capitalize(student['surname'])}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => AddStudentBottomSheet(
              DBRef: DBRef!,
              onClose: getStudent,
            ),
          );
        },
        backgroundColor: Colors.blue.shade700,
        child: const Icon(
          CupertinoIcons.plus,
          size: 35,
        ),
      ),
    );
  }
}
