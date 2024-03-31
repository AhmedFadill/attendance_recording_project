import 'dart:io';

import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';

class PageShow extends StatelessWidget {
  PageShow({super.key});

  dynamic databaseHelper2;

  Future<List<Map>> getStudentPresent() async {
    if (Platform.isAndroid) {
      databaseHelper2 = SqLite();
    } else if (Platform.isWindows) {
      databaseHelper2 = SqlWin();
    }

    List<Map> data1 =
        await databaseHelper2.readData("SELECT * FROM Student_absences");

    return data1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 62, 109),
        title: Text("عرض سجل الحضور"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: FutureBuilder(
          future: getStudentPresent(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: DataTable(
                  columns: [
                    DataColumn(label: Text("الاسم")),
                    DataColumn(label: Text("المرحلة")),
                    DataColumn(label: Text("الحضور"))
                  ],
                  rows: snapshot.data!
                      .map((e) => DataRow(cells: [
                            DataCell(Text('${e['Name_student']}')),
                            DataCell(Text('الثالثة')),
                            DataCell(
                                Text(e['Is_Present'] == 'true' ? 'حاظر' : 'غائب'))
                          ]))
                      .toList()),
            );
          },
        ),
      ),
    );
  }
}
