import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madrasati_el_quraniyah/model/StudentManagement.dart';
import 'package:madrasati_el_quraniyah/screens/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:madrasati_el_quraniyah/model/Student.dart';
import 'package:intl/intl.dart';

class AddStudent extends StatefulWidget {
  AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController fullName = TextEditingController();

  final TextEditingController dateOfBirth = TextEditingController();

  final TextEditingController phoneNumber = TextEditingController();

  final StudentManagement studentManagement = StudentManagement();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('إضافة طالب'),
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
                  hintText: "الإسم الكامل للطالب",
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
                readOnly: true,
                controller: dateOfBirth,
                decoration: const InputDecoration(
                  hintText: "تاريخ ميلاد الطالب",
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
                          'الرجاء تحديد تاريخ ميلاد للطالب'; //set foratted date to TextField value.
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
                  hintText: 'رقم هاتف ولي الأمر',
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
                          Student newStudent = Student(
                              fullName: fullName.text,
                              dateOfBirth: dateOfBirth.text,
                              phoneNumber: phoneNumber.text);
                          studentManagement.addStudent(newStudent);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false);
                        },
                        child: const Text(
                          'إضافة طالب',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        )),
              ),
        ],
      ),
    );
  }
}
