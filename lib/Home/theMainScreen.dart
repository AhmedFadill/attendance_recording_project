import 'dart:io';

import 'package:attendance_recording_project/Home/HomeScreen.dart';
import 'package:attendance_recording_project/Home/floating.dart';
import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TheMainScreen extends StatefulWidget {
  const TheMainScreen({super.key});

  @override
  State<TheMainScreen> createState() => _TheMainScreenState();
}

class _TheMainScreenState extends State<TheMainScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "القائمة الرئيسية",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 3, 62, 109),
          centerTitle: true,
        ),
        body: Home(),
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
                              setState(() {
                                databaseHelper2.insertData(
                                    '''INSERT INTO Student (Name,Stage_id,Card_number,Is_delete,Note)  VALUES('${NameStudent.text}','2','123','0','')''');
                              });
                              print("insert done");
                              TheMainScreen();
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
            ListTile(
              leading: Icon(Icons.insert_drive_file_rounded),
              title: Text(
                'Show List',
                style: TextStyle(fontSize: 17),
                
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.pushNamed(context, 'show');
              },
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
                    //setData();
                  });

                  print("database added");
                }),
          ],
        ),
      ),
        );
        
  }
}
