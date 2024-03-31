import 'package:attendance_recording_project/Home/HomeScreen.dart';
import 'package:attendance_recording_project/Home/get%20data%20from%20sqlite/Fuchure.dart';
import 'package:attendance_recording_project/Home/get%20data%20from%20sqlite/notfier.dart';
import 'package:attendance_recording_project/Home/mainScreen.dart';
import 'package:attendance_recording_project/Home/table.dart';
import 'package:attendance_recording_project/Home/theMainScreen.dart';
import 'package:attendance_recording_project/Page/PageShow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      routes: {
        '/':(context) => TheMainScreen(),
        'show':(context) =>  PageShow(),
      },
    );
  }
}
