import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasati_el_quraniyah/screens/EditStudent.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:madrasati_el_quraniyah/model/StudentManagement.dart';
import '../model/Student.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  StudentManagement studentManagement = StudentManagement();
  bool isLoading = true;
  List searchList = [];
  List<bool> checkBoxes = [];
  void initState() {
    super.initState();
    studentManagement.fetchData().then((_) {
      searchList = studentManagement.students;
      setState(() {
        for (int i = 0; i < studentManagement.students.length; i++) {
          checkBoxes.add(false);
        }
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return studentManagement.students.isEmpty
        ? SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                const Center(
                  child: Text('لا يوجد طلبة .. جاري التحميل'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/AddStudent");
                        },
                        child: const Icon(Icons.add),
                      )),
                ),
              ],
            ),
          )
        : (isLoading
            ? const Center(
                child: Text('جاري تحميل الطلبة'),
              )
            : Scaffold(
                backgroundColor: Colors.grey[200],
                body: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            onChanged: (value) => search(value),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'بحث',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Consumer<StudentManagement>(
                              builder: (context, instance, child) {
                                return ListView.builder(
                                    itemCount: searchList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: CheckboxListTile(
                                            value: checkBoxes[index],
                                            activeColor: Colors.red,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (val) {
                                              setState(() {
                                                checkBoxes[index] = val!;
                                              });
                                            },
                                            title: Text(
                                                searchList[index]['fullName']),
                                            subtitle: Text(searchList[index]
                                                ['dateOfBirth']),
                                            secondary: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => EditStudent(
                                                              id: index,
                                                              fullName: searchList[
                                                                      index]
                                                                  ['fullName'],
                                                              dateOfBirth:
                                                                  searchList[
                                                                          index]
                                                                      [
                                                                      'dateOfBirth'],
                                                              phoneNumber:
                                                                  searchList[
                                                                          index]
                                                                      [
                                                                      'phoneNumber'])));
                                                    },
                                                    icon: Icon(Icons.edit)),
                                                IconButton(
                                                    onPressed: () async {
                                                      AlertDialog alertDialog =
                                                          AlertDialog(
                                                        title: const Text(
                                                            "هل أنت متأكد من أنك تريد حذف هذا الطالب ؟"),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("نعم"),
                                                            onPressed:
                                                                () async {
                                                              int response = await studentManagement.deleteStudent(
                                                                  studentManagement
                                                                              .students[
                                                                          index]
                                                                      [
                                                                      'fullName'],
                                                                  studentManagement
                                                                              .students[
                                                                          index]
                                                                      [
                                                                      'dateOfBirth'],
                                                                  studentManagement
                                                                              .students[
                                                                          index]
                                                                      [
                                                                      'phoneNumber']);
                                                              if (response >
                                                                  0) {
                                                                studentManagement
                                                                    .students
                                                                    .removeWhere((element) =>
                                                                        element[
                                                                            'id'] ==
                                                                        studentManagement.students[index]
                                                                            [
                                                                            'id']);
                                                                setState(() {});
                                                              }
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              // Do something when the user clicks on the "Yes" button.
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text("لا"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              // Do something when the user clicks on the "No" button.
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return alertDialog;
                                                          });
                                                    },
                                                    icon: Icon(Icons.delete)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      decoration:
                                          BoxDecoration(color: Colors.blue),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          try {
                                            int index = checkBoxes.indexOf(
                                                checkBoxes.firstWhere(
                                                    (element) =>
                                                        element == true));
                                            studentManagement.reportAsAbsent(
                                                studentManagement
                                                    .students[index]['id']);
                                            // List<String> recipient = [];
                                            // recipient.add(studentManagement.students[index]['phoneNumber']);
                                            String currentDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(DateTime.now());
                                            String message =
                                                'تعلمكم_إدارة_المدرسة_القرآنية_بأن_ابنكم:${studentManagement.students[index]['fullName'].toString().replaceAll(' ', '_')}_قد_تغيب_بتاريخ:${currentDate}';

                                            final Uri smsLaunchUri = Uri(
                                                scheme: 'sms',
                                                path:
                                                    '${studentManagement.students[index]['phoneNumber']}',
                                                queryParameters: {
                                                  'body': message,
                                                });
                                            if (await canLaunchUrlString(
                                                smsLaunchUri.toString())) {
                                              await launchUrlString(
                                                  smsLaunchUri.toString());
                                            } else {
                                              print('could not launch the uri');
                                            }
                                          } catch (e) {
                                            AlertDialog alertDialog =
                                                AlertDialog(
                                              title: const Text(
                                                  "الرجاء تحديد طالب"),
                                              actions: [
                                                TextButton(
                                                  child: Text("حسنا"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    // Do something when the user clicks on the "No" button.
                                                  },
                                                ),
                                              ],
                                            );
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return alertDialog;
                                                });
                                          }
                                        },
                                        child: const Text(
                                          'إبلاغ عن غياب',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    FloatingActionButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed("/AddStudent");
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }

  void search(String searchWord) {
    List results = [];
    if (searchList.isEmpty) {
      results = studentManagement.students;
    } else {
      results = studentManagement.students
          .where((element) => element['fullName'].contains(searchWord))
          .toList();
    }
    setState(() {
      searchList = results;
    });
  }
}
