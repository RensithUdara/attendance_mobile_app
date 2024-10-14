import 'package:attendanceapp/database/db.dart';
import 'package:attendanceapp/widgets/button.dart';
import 'package:attendanceapp/widgets/textfield.dart';
import 'package:flutter/material.dart';

class AddStudentBottomSheet extends StatefulWidget {
  final VoidCallback onClose;
  final DBHelper DBRef;
  final Map updateStudentData;

  AddStudentBottomSheet({
    super.key,
    required this.DBRef,
    required this.onClose,
    Map? updateStudentData,
  }) : updateStudentData = updateStudentData ?? {'update': false};

  @override
  State<AddStudentBottomSheet> createState() => _AddStudentBottomSheetState();
}

class _AddStudentBottomSheetState extends State<AddStudentBottomSheet> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final dateController = TextEditingController();
  var _errors = '';
  int? rollno;

  @override
  void initState() {
    super.initState();
    if (widget.updateStudentData['update'] != false) {
      nameController.text = widget.updateStudentData['name'] ?? '';
      surnameController.text = widget.updateStudentData['surname'] ?? '';
      dateController.text = widget.updateStudentData['dob'] ?? '';
      rollno = widget.updateStudentData['roll_no'];
    }
  }

  void closeSheet(BuildContext context) {
    nameController.clear();
    surnameController.clear();
    dateController.clear();
    Navigator.pop(context);
    setState(() {
      _errors = "";
    });
  }

  void saveStudent(BuildContext context) async {
    if (_validateForm()) {
      var result = await widget.DBRef.addStudent(
        name: nameController.text,
        surname: surnameController.text,
        dob: dateController.text,
      );
      if (result) {
        closeSheet(context);
        widget.onClose();
      }
    }
  }

  void updateStudent(BuildContext context) async {
    if (_validateForm() && rollno != null) {
      var result = await widget.DBRef.updateStudent(
        name: nameController.text,
        surname: surnameController.text,
        dob: dateController.text,
        rollno: rollno!,
      );
      if (result) {
        closeSheet(context);
        widget.onClose();
      }
    }
  }

  bool _validateForm() {
    if (nameController.text.isEmpty ||
        surnameController.text.isEmpty ||
        dateController.text.isEmpty) {
      setState(() {
        _errors = "* Please fill all the required fields";
      });
      return false;
    }
    setState(() {
      _errors = '';
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${rollno != null ? 'Update' : 'Add'} Student",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          MyTextField(controller: nameController, hintText: "Student Name"),
          const SizedBox(height: 12),
          MyTextField(controller: surnameController, hintText: "Student Surname"),
          const SizedBox(height: 12),
          MyDateField(controller: dateController, hintText: "Date of Birth"),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SaveButton(
                  callback: () => rollno != null
                      ? updateStudent(context)
                      : saveStudent(context),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CancelButton(
                  callback: () => closeSheet(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_errors.isNotEmpty)
            Text(
              _errors,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
