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

DateTime now = DateTime.now();

class _TheMainScreenState extends State<TheMainScreen> {
  dynamic databaseHelper2;

  late String Time;

  TextEditingController NameStudent = TextEditingController();
  TextEditingController CardStudent = TextEditingController();

  void initState() {
    super.initState();
    // تحديد البلاتفورم واختيار الكلاس المناسب
    if (Platform.isAndroid) {
      databaseHelper2 = SqLite();
    } else if (Platform.isWindows) {
      databaseHelper2 = SqlWin();
    }
    Time = "${now.year}-${now.month}-${now.day}";
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
        leading: IconButton(
            onPressed: () async {
              final DateTime? Date = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(2024, 1, 1),
                  lastDate: DateTime(2024, 6, 1));
              if (Date != null) {
                setState(() {
                  now = Date;
                  Time = "${now.year}-${now.month}-${now.day}";
                });
                print(now);
              }
            },
            icon: Icon(Icons.date_range)),
      ),
      body: Home(
        now,
      ),
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          textAlign: TextAlign.right,
                          controller: NameStudent,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_pin_rounded),
                              label: Text(
                                "اسم الطالب",
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          textAlign: TextAlign.right,
                          controller: CardStudent,
                          decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.branding_watermark_outlined),
                              label: Text(
                                "رقم الهوية",
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 315,
                        height: 50,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 3, 62, 109)),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))))),
                            onPressed: () {
                              if (NameStudent.text != "" &&
                                  CardStudent.text != "") {
                                setState(() {
                                  databaseHelper2.insertData(
                                      '''INSERT INTO Student (Name,Stage_id,Card_number,Is_delete,Note)  VALUES('${NameStudent.text}','2','${CardStudent.text}','0','')''');
                                });
                                print("insert done");
                                TheMainScreen();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green,
                                        content: Text(
                                          "تم الاضافة بنجاح",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "لم تتم الاضافة",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )));
                              }
                            },
                            child: Text("اضافة الى القوائم")),
                      )
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
          SpeedDialChild(child: Icon(Icons.qr_code_scanner_outlined),label: "Scanner",onTap: () => Navigator.pushNamed(context, 'scan'),)
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
              onTap: () {
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
