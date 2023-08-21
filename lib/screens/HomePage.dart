import 'package:flutter/material.dart';
import 'package:madrasati_el_quraniyah/screens/StudentList.dart';
import 'package:madrasati_el_quraniyah/screens/AttendanceHistory.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> widgetList = <Widget>[StudentList(),AttendanceHistory()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'رئيسي'),
          BottomNavigationBarItem(icon: Icon(Icons.history),label: 'تاريخ'),
        ],
      ),
    );
  }
}
