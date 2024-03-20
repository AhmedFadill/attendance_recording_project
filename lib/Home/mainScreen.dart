import 'dart:io';

import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  dynamic data;
  dynamic databaseHelper2;

  void initState() {
    super.initState();
    // تحديد البلاتفورم واختيار الكلاس المناسب
    if (Platform.isAndroid) {
      databaseHelper2 = SqLite();
    } else if (Platform.isWindows) {
      databaseHelper2 = SqlWin();
    }
    data = getData();
  }

  Future<List<Map>> getData() async {
    List<Map> data1 = await databaseHelper2.readData("SELECT * FROM User");
    return data1;
  }

  setData() async {
    int d = databaseHelper2.insertData('''
      INSERT INTO User (name,email,password)  VALUES('Mohamed','mohamed@gmail.com','123456'),('Ahmed','ahmed@gmail.com','123')
                      
''');
  }

  bool check = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 62, 109),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(children: [
          FutureBuilder(
              future: getData(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.hasData) {
                  return DataTable(
                      columns: [
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("email")),
                        DataColumn(label: Text("password")),
                      ],
                      rows: snapshot.data!
                          .map(
                            (e) => DataRow(
                              cells: [
                                DataCell(
                                  Text(e['name'].toString()),
                                ),
                                DataCell(
                                  Text(e['email'].toString()),
                                ),
                                DataCell(
                                  Text(e['password'].toString()),
                                ),
                              ],
                            ),
                          )
                          .toList());
                }
                return Center(child: CircularProgressIndicator());
              })
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setData(),
      ),
    );
  }
}
