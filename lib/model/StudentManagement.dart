import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasati_el_quraniyah/model/StudentDatabase.dart';
import 'package:madrasati_el_quraniyah/model/Student.dart';

class StudentManagement with ChangeNotifier{

    StudentDatabase database = StudentDatabase();
    List students = [];
    List present = [];
    List absentList = [];
    List absent = [];

    Future retrieveData(String date) async {
        fetchData().then((_) async {
            // This code block will execute after fetchData() is completed.
           await database
                .readData('''
      SELECT * FROM 'attendance' 
      WHERE currentDate = "${date}"
      AND status = "ABSENT"
    ''')
                .then((response2) {
                absent.addAll(response2);
                print(absent);
                for (var student in students) {
                    var studentId = student['id'];
                    if (!absent.any((absentStudent) => absentStudent['student_id'] == studentId)) {
                        present.add(student);
                    }
                }
                for (var student in students) {
                    var studentId = student['id'];
                    if (absent.any((absentStudent) => absentStudent['student_id'] == studentId)) {
                        absentList.add(student);
                    }
                }
                print(absentList);
                notifyListeners();
            });
        });
    }
    Future fetchData() async{
        List<Map> response = await database.readData("SELECT * FROM students");
        students.addAll(response);
    }
    void addStudent(Student student){
        database.insertData("INSERT INTO 'students'('fullName','dateOfBirth','phoneNumber') VALUES ('${student.fullName}','${student.dateOfBirth}','${student.phoneNumber}')");
        notifyListeners();
    }

    void updateStudent(Student updatedStudent,Student oldStudent){
        database.insertData('''
                      UPDATE students SET 
                      fullName = "${updatedStudent.fullName}",
                      dateOfBirth = "${updatedStudent.dateOfBirth}",
                      phoneNumber = "${updatedStudent.phoneNumber}"
                      WHERE fullName = "${oldStudent.fullName}"
                      AND dateOfBirth = "${oldStudent.dateOfBirth}"
                      AND phoneNumber = "${oldStudent.phoneNumber}"
                      ''');
        notifyListeners();
    }
    Future deleteStudent(String fullName,String dateOfBirth,String phoneNumber) async {
        var response = await database.deleteData('''
        DELETE FROM students 
        WHERE fullName = "${fullName}"
        AND dateOfBirth = "${dateOfBirth}"
        AND phoneNumber = "${phoneNumber}"
        ''');
        notifyListeners();
        return response;
    }
    void reportAsAbsent(int student_id) async {
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        var response = await database.insertData('''
        INSERT INTO 'attendance'('student_id','currentDate','status') 
        VALUES (${student_id},'${currentDate}','ABSENT')
        ''');

    }

}