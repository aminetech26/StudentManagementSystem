import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madrasati_el_quraniyah/model/StudentManagement.dart';
import 'package:madrasati_el_quraniyah/screens/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:madrasati_el_quraniyah/model/Student.dart';
import 'package:intl/intl.dart';

class EditStudent extends StatefulWidget {
  int id;
  String fullName;
  String dateOfBirth;
  String phoneNumber;
  EditStudent({Key? key,required this.id,required this.fullName,required this.dateOfBirth,required this.phoneNumber}) : super(key: key);

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final StudentManagement studentManagement = StudentManagement();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullName.text = widget.fullName;
    dateOfBirth.text = widget.dateOfBirth;
    phoneNumber.text = widget.phoneNumber;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('تحديث طالب'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: fullName,
                decoration: const InputDecoration(
                  hintText: "Student's full name",
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                readOnly: false,
                controller: dateOfBirth,
                decoration: const InputDecoration(
                  hintText: "Student's date of birth",
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          1950), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    //You can format date as per your need
                    setState(() {
                      dateOfBirth.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    setState(() {
                      dateOfBirth.text =
                      'Please enter a valid date of birth'; //set foratted date to TextField value.
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: phoneNumber,
                decoration: const InputDecoration(
                  hintText: 'Parent phone number',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextButton(
                onPressed: () {
                  Student oldStudent = Student(fullName: widget.fullName, dateOfBirth: widget.dateOfBirth, phoneNumber: widget.phoneNumber);
                  Student newStudent = Student(
                      fullName: fullName.text,
                      dateOfBirth: dateOfBirth.text,
                      phoneNumber: phoneNumber.text);
                  studentManagement.updateStudent(newStudent,oldStudent);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomePage()),
                          (route) => false);
                },
                child: const Text(
                  'تحديث الطالب',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
