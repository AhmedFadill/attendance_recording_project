import 'dart:io';

import 'package:attendance_recording_project/Home/get%20data%20from%20sqlite/notfier.dart';
import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableStudent extends StatefulWidget {
  const TableStudent({super.key});

  @override
  State<TableStudent> createState() => _TableStudentState();
}

class _TableStudentState extends State<TableStudent> {
  dynamic databaseHelper2;

  void initState() {
    super.initState();
    // تحديد البلاتفورم واختيار الكلاس المناسب
    if (Platform.isAndroid) {
      databaseHelper2 = SqLite();
    } else if (Platform.isWindows) {
      databaseHelper2 = SqlWin();
    }
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Model(),
        child: Scaffold(
          body: Center(
            child: Consumer<Model>(
              builder: (context, value, child) {
                value.aa(databaseHelper2.readData("SELECT * FROM Student"));
                print(value.data);
                print("تم انشاء الجدول");
                return DataTable(
                    columns: [
                      DataColumn(
                          label: SizedBox(width: 50, child: Text("الاسم")),
                          numeric: true),
                      DataColumn(label: Text("المرحلة"), numeric: false),
                      DataColumn(label: Text("الحظور"), numeric: false),
                    ],
                    rows: value.data != null
                        ? value.data!.map(
                            (e) {
                              if (e is Map) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(e['Name'].toString()),
                                      onTap: () => print(e),
                                    ),
                                    DataCell(
                                      Text(e['Stage_id'].toString() == "2"
                                          ? "الثالثة"
                                          : ""),
                                    ),
                                    DataCell(Checkbox(
                                      value: true,
                                      onChanged: null,
                                    )),
                                  ],
                                );
                              } else {
                                return DataRow(
                                    cells: [DataCell(Text(e.toString()))]);
                              }
                            },
                          ).toList()
                        : []);
              },
            ),
          ),
        ));
  }
}
