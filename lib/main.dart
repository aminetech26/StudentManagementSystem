import 'package:flutter/material.dart';
import 'package:madrasati_el_quraniyah/screens/AddStudent.dart';
import 'package:madrasati_el_quraniyah/screens/EditStudent.dart';
import 'package:provider/provider.dart';
import 'package:madrasati_el_quraniyah/model/StudentManagement.dart';
import 'package:madrasati_el_quraniyah/screens/HomePage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
void main() {
runApp(MultiProvider(providers: [
  ChangeNotifierProvider(create: (context)=>StudentManagement()),
],child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/' : (context) => HomePage(),
            '/AddStudent' : (context) => AddStudent(),

          },
        );
      },
    );
  }
}