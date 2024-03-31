import 'dart:io';

import 'package:attendance_recording_project/Home/get%20data%20from%20sqlite/notfier.dart';
import 'package:attendance_recording_project/Home/table.dart';
import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Map> data;

  dynamic databaseHelper2;
  int date = 0;
  List<bool> hh = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<int> a = [];
  List<String> name = [];

  void initState() {
    super.initState();
    // تحديد البلاتفورم واختيار الكلاس المناسب
    if (Platform.isAndroid) {
      databaseHelper2 = SqLite();
    } else if (Platform.isWindows) {
      databaseHelper2 = SqlWin();
    }
  }

  getName() async {
    List<Map> data1 = await databaseHelper2.readData("SELECT * FROM Student");
    for (var element in data1) {
      if (!a.contains(element['Id'])) {
        name.add(element['Name']);
        a.add(element['Id']);
        hh.add(false);
      }
    }
  }

  Future<List<Map>> getStudentPresent() async {
    List<Map> data1 =
        await databaseHelper2.readData("SELECT * FROM Student_absences");
    List<Map> data2 = await databaseHelper2.readData("SELECT * FROM Student");

    for (var element in data1) {
      if (element['Date'] == 2024) {
        date = 1;
        print(data1);
        return data1;
      }
    }
    return data2;
  }

  Future<List<Map>> getData() async {
    List<Map> data1 = await databaseHelper2.readData("SELECT * FROM Student");

    return data1;
  }

  @override
  Widget build(BuildContext context) {
    getName();

    return Container(
      width: double.infinity,
      child: FutureBuilder(
        future: getStudentPresent(),
        builder: (context, AsyncSnapshot<List<Map>> snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: DataTable(
                columns: [
                  DataColumn(label: Text("الاسم")),
                  DataColumn(label: Text("المرحلة")),
                  DataColumn(label: Text("حظور"))
                ],
                rows: snapshot.data!.map((e) {
                  print(e);
                  return DataRow(cells: [
                    DataCell(Text(date == 1
                        ? '${name[name.indexOf(e['Name_student'] != null ? e['Name_student'] : 'احمد فاضل')]}'
                        : e['Name'])),
                    DataCell(Text('ثالثة')),
                    DataCell(
                      Checkbox(
                          value: date == 0
                              ? hh[name.indexOf(e['Name'])]
                              : e['Is_Present'] == 'true'
                                  ? true
                                  : false,
                          onChanged: (value) {
                            setState(() {
                              if (date == 0) {
                                hh[a.indexOf(e['Id'])] = value!;
                                for (var i = 0; i < a.length; i++) {
                                  setState(() {
                                    databaseHelper2.insertData(
                                        '''INSERT INTO Student_absences (Name_student, Is_Present, Date, Note, Type) VALUES ("${name[i]}", "${hh[i]}", "${2024}", '', '')''');
                                  });
                                }
                                date = 1;
                                print('insert done');
                              } else {
                                setState(() {
                                  hh[name.indexOf(e['Name_student'])] = value!;
                                  databaseHelper2
                                      .updateData('''UPDATE Student_absences
                                                    SET Is_Present = "${hh[name.indexOf(e['Name_student'])]}"
                                                    WHERE Name_student = "${e['Name_student']}";''');
                                });
                              }
                            });
                            print(hh);
                          }),
                    )
                  ]);
                }).toList()),
          );
        },
      ),
    );
  }
}
