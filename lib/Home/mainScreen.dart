import 'dart:io';

import 'package:attendance_recording_project/Home/HomeScreen.dart';
import 'package:attendance_recording_project/Home/get%20data%20from%20sqlite/notfier.dart';
import 'package:attendance_recording_project/Home/table.dart';
import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Map> data;
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
    //data = getData();
  }

  Future<List<Map>> getData() async {
    List<Map> data1 = await databaseHelper2.readData("SELECT * FROM Student");
    return data1;
  }

  setData() async {
    int d = await databaseHelper2.insertData('''
      INSERT INTO Student (Name,Stage_id,Card_number,Is_delete,Note)  VALUES('احمد فاضل لفته','2','123','0','')
''');
    return d;
  }

  var lstbool = [true, false, true, false, false, true];
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
          child: null),
      floatingActionButton: SpeedDial(
        spacing: 15,
        spaceBetweenChildren: 10,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 3, 62, 109),
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: "Add",
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  color: Colors.lightBlue,
                  child: Column(
                    children: [
                      TextField(controller: NameStudent),
                      ElevatedButton(
                          onPressed: () {
                            int c = 0;
                            for (int i = 0; i < data.length; i++) {
                              if (NameStudent.text == data[i]['Name'] ||
                                  NameStudent.text.isEmpty) {
                                c++;
                              }
                            }
                            if (c > 0) {
                              print("Name already exists");
                              return;
                            } else {
                              setState(() {
                                databaseHelper2.insertData(
                                    '''INSERT INTO Student (Name,Stage_id,Card_number,Is_delete,Note)  VALUES('${NameStudent.text}','2','123','0','')''');
                              });
                            }
                          },
                          child: Text("Save"))
                    ],
                  ),
                );
              },
            ),
          ),
          SpeedDialChild(
              child: Icon(
                Icons.edit,
              ),
              label: "Edit"),
        ],
      ),
      endDrawer: Drawer(
        elevation: 8,
        child: ListView(
          children: [
            Container(
              color: Colors.amber,
              child: const UserAccountsDrawerHeader(
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 3, 62, 109)),
                  accountName: Text("Name"),
                  accountEmail: Text("mohamed@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: FlutterLogo(
                      size: 42,
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            const ListTile(
              leading: Icon(Icons.insert_drive_file_rounded),
              title: Text(
                'Show List',
                style: TextStyle(fontSize: 17),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(
              height: 20,
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 17),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
                leading: Icon(Icons.delete),
                title: Text(
                  'Delet all data',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  setState(() {
                    databaseHelper2.deleteDatabase1();
                  });

                  print("database deleted");
                }),
            const SizedBox(
              height: 20,
            ),
            ListTile(
                leading: Icon(Icons.add_circle_outline_sharp),
                title: Text(
                  'Add data ',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  setState(() {
                    setData();
                  });

                  print("database added");
                }),
          ],
        ),
      ),
    );
  }
}
