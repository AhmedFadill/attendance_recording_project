import 'dart:io';

import 'package:attendance_recording_project/Home/HomeScreen.dart';
import 'package:attendance_recording_project/Home/floating.dart';
import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    print(
        "welcome in the main screeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الصفحة الرئيسية",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 80, 98, 189),
        centerTitle: true,
        leading: IconButton(
            onPressed: () async {
              final DateTime? Date = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(2024, 1, 1),
                  lastDate: DateTime(2050, 6, 1));
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
        backgroundColor: Color.fromARGB(255, 76, 95, 193),
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
                        height: 50,
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
                                NameStudent.clear();
                                CardStudent.clear();
                              } else {}
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
          SpeedDialChild(
            child: Icon(Icons.qr_code_scanner_outlined),
            label: "Scanner",
            onTap: () {
              Navigator.pushReplacementNamed(context, 'scan');
            },
          )
        ],
      ),
      endDrawer: Drawer(
        elevation: 8,
        child: Container(
          child: ListView(
            children: [
              Container(
                color: Colors.amber,
                width: double.infinity,
                child: const UserAccountsDrawerHeader(
                    decoration:
                        BoxDecoration(color: Color.fromARGB(255, 3, 62, 109)),
                    accountName: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("الاستاذ مرتجى جلوخان"),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    accountEmail: Text("mortja@gmail.com"),
                    currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image(
                          image: AssetImage("images/T.png"),
                        ))),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file_rounded),
                title: Text(
                  'البيانات المسجلة',
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
                  'الاعدادات',
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
                    'حذف كل البيانات',
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    setState(() {
                      databaseHelper2.deleteDatabase1();
                    });
                    date = 0;
                    print("database deleted");
                  }),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                  leading: Icon(Icons.add_circle_outline_sharp),
                  title: Text(
                    'اضافة بيانات للتجربة',
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    final name = [
                      "احمد فاضل",
                      "محمد علي",
                      "مهدي حيدر",
                      "عقيل علي",
                      "علي قاسم",
                      "حيدر حسن",
                      "محمد منتظر",
                      "طه صفاء",
                      "مهمين عامر",
                      "عباس عزيز",
                      "محمد رضا",
                      "براق توفيق",
                      "ندى كاظم",
                      "مريم علي",
                      "مريم عبد الحسين",
                      "جواد حيدر",
                      "رضا شاذل",
                      "عباس مهدي",
                    ];
                    final number = [
                      "1211701004",
                      "1211701045",
                      "1211701046",
                      "1211701029",
                      "1211701031",
                      "2211701009",
                      "1211701044",
                      "2211701011",
                      "1211701047",
                      "1211701026",
                      "1211701043",
                      "2221701002",
                      "1211701049",
                      "2211701017",
                      "2211701016",
                      "2211701005",
                      "1211701015",
                      "1211701028"
                    ];

                    setState(() {
                      for (var i = 0; i < name.length; i++) {
                        databaseHelper2.insertData(
                            '''INSERT INTO Student (Name,Stage_id,Card_number,Is_delete,Note)  VALUES('${name[i]}','2','${number[i]}','0','')''');
                      }
                    });

                    print("database added");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
