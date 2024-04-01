import 'dart:io';

import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';

class PageShow extends StatefulWidget {
  PageShow({super.key});

  @override
  State<PageShow> createState() => _PageShowState();
}

class _PageShowState extends State<PageShow> {
  DateTime now = DateTime.now();
  dynamic databaseHelper2;

  Future<List<Map>> getStudentPresent() async {
    if (Platform.isAndroid) {
      databaseHelper2 = SqLite();
    } else if (Platform.isWindows) {
      databaseHelper2 = SqlWin();
    }

    List<Map> data1 = await databaseHelper2.readData(
        "SELECT * FROM Student_absences WHERE Date = '${now.year}-${now.month}-${now.day}'");

    return data1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 3, 62, 109),
          title: Text("عرض سجل الحضور"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  final DateTime? Date = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(2024, 1, 1),
                      lastDate: DateTime(2024, 6, 1));
                  if (Date != null) {
                    setState(() {
                      now = Date;
                    });
                    print(now);
                  }
                },
                icon: Icon(Icons.date_range_outlined)),
          ]),
      body: Container(
        width: double.infinity,
        child: FutureBuilder(
          future: getStudentPresent(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [
                    DataColumn(label: Text("الاسم")),
                    DataColumn(label: Text("المرحلة")),
                    DataColumn(label: Text("الحضور")),
                    DataColumn(label: Text("التاريخ"))
                  ],
                  rows: snapshot.data!
                      .map((e) => DataRow(cells: [
                            DataCell(Text('${e['Name_student']}')),
                            DataCell(Text('الثالثة')),
                            DataCell(Text(
                                e['Is_Present'] == 'true' ? 'حاظر' : 'غائب')),
                            DataCell(Text('${e['Date']}'))
                          ]))
                      .toList()),
            );
          },
        ),
      ),
    );
  }
}
