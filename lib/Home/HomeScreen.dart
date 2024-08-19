import 'dart:io';

import 'package:attendance_recording_project/Home/get%20data%20from%20sqlite/notfier.dart';
import 'package:attendance_recording_project/Home/table.dart';
import 'package:attendance_recording_project/Home/theMainScreen.dart';
import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home(data, {super.key, this.Time});
  final Time;

  @override
  State<Home> createState() => HomeState(Time);
}

int date = 0;
List<bool> hdor = [];

class HomeState extends State<Home> {
  HomeState(this.Time);
  final Time;
  late List<Map> data;

  dynamic databaseHelper2;


  List<int> id = [];
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
      if (!id.contains(element['Id'])) {
        name.add(element['Name']);
        id.add(element['Id']);
        hdor.add(false);
      }
      print("name of student form table student :$name");
    }
  }

  Future<List<Map>> getStudentPresent() async {
    List<Map> data1 =
        await databaseHelper2.readData("SELECT * FROM Student_absences");
    print(data1);
    List<Map> data2 = await databaseHelper2.readData("SELECT * FROM Student");

    for (var element in data1) {
      if (element['Date'] == "${now.year}-${now.month}-${now.day}") {
        date = 1;
        print("data1 : $data1");
        print("now date is 1 --------------------------------");
        List<Map> dataOfappppp = await databaseHelper2.readData(
            "SELECT * FROM Student_absences WHERE DATE='${now.year}-${now.month}-${now.day}'");
        return dataOfappppp;
      } else {
        date = 0;
        for (int i = 0; i < hdor.length; i++) {
          hdor[i] = false;
        }
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
    print("${now.year}-${now.month}-${now.day}" +
        '---------------------------------------------------------------');

    return Container(
      width: double.infinity,
      child: FutureBuilder(
        future: getStudentPresent(),
        builder: (context, AsyncSnapshot<List<Map>> snapshot) {
          print(name);
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
                        ? '${name[id.indexOf(e['Name_student'] != null ? e['Name_student'] : id[0])]}'
                        : e['Name'])),
                    DataCell(Text('ثالثة')),
                    DataCell(
                      Checkbox(
                          //checkColor: Color(0xFFFF6477db),
                          activeColor: Color(0xFFFF6477db),
                          value: date == 0
                              ? hdor[name.indexOf(e['Name'])]
                              : e['Is_Present'] == 'true'
                                  ? true
                                  : false,
                          onChanged: (value) {
                            if (date == 0) {
                              hdor[id.indexOf(e['Id'])] = value!;
                              print(name);
                              for (var i = 0; i < name.length; i++) {
                                databaseHelper2.insertData(
                                    '''INSERT INTO Student_absences (Name_student, Is_Present, Date, Note, Type) VALUES ("${id[i]}", "${hdor[i]}", "${now.year}-${now.month}-${now.day}", '', '')''');
                                print('insert done');
                              }

                              setState(() {
                                date = 1;
                              });
                            } else {
                              setState(() {
                                hdor[id.indexOf(e['Name_student'])] = value!;
                                databaseHelper2
                                    .updateData('''UPDATE Student_absences
                                                    SET Is_Present = "${hdor[id.indexOf(e['Name_student'])]}"
                                                    WHERE Name_student = "${e['Name_student']}" AND DATE = "${now.year}-${now.month}-${now.day}";''');
                              });
                            }
                            ;
                            print(hdor);
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
