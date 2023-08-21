import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasati_el_quraniyah/model/StudentManagement.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({Key? key}) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController dateOfBirth = TextEditingController();
  StudentManagement studentManagement = StudentManagement();

  @override
  void initState() {
    // TODO: implement initState

    studentManagement.retrieveData(currentDate).then((_){
      setState(() {

      });
    }

    );
    //print(studentManagement.present);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      backgroundColor: Colors.grey[200],
      body:SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/50,),
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
                    hintText: "الرجاء تحديد التاريخ",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), //get today's date
                        firstDate: DateTime(
                            1950), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now());
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
                        'الرجاء تحديد تاريخ صحيح'; //set foratted date to TextField value.
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/50,),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child:MaterialButton(
                child: Text('بحث',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                onPressed: (){
                    if (dateOfBirth.text != '' &&  dateOfBirth.text != 'الرجاء تحديد تاريخ ميلاد للطالب'){
                      studentManagement = StudentManagement();
                      studentManagement.retrieveData(dateOfBirth.text).then((_){
                        setState(() {

                        });
                      });

                    }else{
                      Fluttertoast.showToast(
                          msg: "Please enter a valid date",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 10,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );

                    }
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/50,),
            const TabBar(indicatorColor: Colors.grey,tabs: [
              Tab(
                icon: Icon(Icons.add,color: Colors.black,),
                child: Text('الحضور',style: TextStyle(color: Colors.black,
                    fontWeight: FontWeight.bold),),

              ),
              Tab(
                icon: Icon(Icons.remove,color: Colors.black,),
                child: Text('الغياب',style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold
                ),),

              ),

            ]),
            SizedBox(height: MediaQuery.of(context).size.height/60,),
            Expanded(child: TabBarView(
              children: [
                Consumer<StudentManagement>(builder:(context,instance,child){
                  return ListView.builder(itemCount: studentManagement.absentList.length,itemBuilder: (context,index){
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: ListTile(
                                title: Text(studentManagement.absentList[index]['fullName'])        ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                      ],
                    );
                  });
                }),
                Consumer<StudentManagement>(builder:(context,instance,child){
                  return ListView.builder(itemCount: studentManagement.present.length,itemBuilder: (context,index){
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: ListTile(
                                title: Text(studentManagement.present[index]['fullName'])        ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                      ],
                    );
                  });
                }),
              ],
            )),
          ],
        ),
      ),
    ));
  }
}
