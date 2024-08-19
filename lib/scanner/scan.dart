import 'dart:io';

import 'package:attendance_recording_project/Home/theMainScreen.dart';
import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String barcodeScanResult = 'Waiting for scan...';
  String a = '';

  dynamic databaseHelper2;
  int date = 0;
  List<bool> hh = [];

  void initState() {
    super.initState();
    // تحديد البلاتفورم واختيار الكلاس المناسب
    if (Platform.isAndroid) {
      databaseHelper2 = SqLite();
    } else if (Platform.isWindows) {
      databaseHelper2 = SqlWin();
    }
    print('${now.year}-${now.month}-${now.day}');
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on FormatException {
      barcodeScanRes = 'Faild  to scan Barcode';
    }
    if (!mounted) return;
    setState(() {
      barcodeScanResult = barcodeScanRes;
    });
    if (barcodeScanRes != '-1') {
      getStudentPresent();
      updatWitScan();
    }
  }

  List<int> id = [];
  List<String> names = [];
  getName() async {
    List<Map> data1 = await databaseHelper2.readData("SELECT * FROM Student");
    for (var element in data1) {
      if (!id.contains(element['Id'])) {
        names.add(element['Name']);
        id.add(element['Id']);
        hh.add(false);
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
        print(data1);
        print("now date is 1 --------------------------------");
        List<Map> dataOfappppp = await databaseHelper2.readData(
            "SELECT * FROM Student_absences WHERE DATE='${now.year}-${now.month}-${now.day}'");
        return dataOfappppp;
      } else {
        date = 0;
        for (int i = 0; i < hh.length; i++) {
          hh[i] = false;
        }
      }
    }
    return data2;
  }

  String name = '';
  String card = '';

  Future updatWitScan() async {
    List<Map> Student = await databaseHelper2.readData(
        "Select Id,Name,Card_number FROM Student WHERE Card_number='${barcodeScanResult}'");
    print(Student);
    name = Student[0]['Name'];
    card = Student[0]['Card_number'];

    if (date == 1) {
      databaseHelper2.updateData(
          "UPDATE Student_absences SET Is_Present='true' WHERE Student_absences.Name_student='${Student[0]['Id']}' AND Date='${now.year}-${now.month}-${now.day}' ");
    } else {
      print("the date is 0  --------------------------");
      for (var i = 0; i < names.length; i++) {
        if (names[i]==name){ databaseHelper2.insertData(
            '''INSERT INTO Student_absences (Name_student, Is_Present, Date, Note, Type) VALUES ("${id[i]}", "true", "${now.year}-${now.month}-${now.day}", '', '')''');}
       else{
         databaseHelper2.insertData(
            '''INSERT INTO Student_absences (Name_student, Is_Present, Date, Note, Type) VALUES ("${id[i]}", "${hh[i]}", "${now.year}-${now.month}-${now.day}", '', '')''');
       }
        print('insert done');
      }

      setState(() {
        date = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getName();
    return Scaffold(
        appBar: AppBar(
          title: Text("تسجيل باستعمال الباركود"),
          backgroundColor: const Color.fromARGB(255, 3, 62, 109),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/");
              },
              icon: Icon(Icons.arrow_back)),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getStudentPresent(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              print("---------------------------------------------");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "اسم الطالب : $name",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "رقم الهوية : $card",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(10)),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 3, 62, 109))),
                        onPressed: () {
                          scanBarcode();
                        },
                        child: Text(
                          "فتح الكامرة لبدء التسجيل",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                  ],
                ),
              );
            }
          },
        ));
  }
}
