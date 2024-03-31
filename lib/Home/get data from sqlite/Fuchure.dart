import 'dart:io';

import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




Provider User = Provider((ref) => DataUser);
var data;
var DataUser;

FutureBuilder receve_data(future, table) {
  return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          data = snapshot.data;
          DataUser = data;
          print(DataUser);
        }
        
        return Text("data");
      });
}

class Newtest extends StatefulWidget {
  const Newtest({super.key});

  @override
  State<Newtest> createState() => _NewtestState();
}

class _NewtestState extends State<Newtest> {
  dynamic databaseHelper2;
  TextEditingController NameStudent = TextEditingController();

  void initState() {
    super.initState();
    // تحديد البلاتفورم واختيار الكلاس المناسب
    if (Platform.isAndroid) {
      databaseHelper2 = SqLite();
    } else if (Platform.isWindows) {
      databaseHelper2 = SqlWin();
    }
    setState(() {
      getData().then((value) => data=value);
    }); 
  }

  Future<List<Map>> getData() async {
    List<Map> data1 = await databaseHelper2.readData("SELECT * FROM Student");
    return data1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        print(data);
      }),
      body: SafeArea(
          child: Column(
        children: [Text("$data"),Consumer(builder: (context, ref, child) => Text(ref.watch(User).toString()),)],
      )),
    );
  }
}
