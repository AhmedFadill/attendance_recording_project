import 'dart:io';

import 'package:attendance_recording_project/SQlite/android.dart';
import 'package:attendance_recording_project/SQlite/windows.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Model(),
        child: Consumer<Model>(
          builder: (context, value, child) {
            value.fetch_and_conect();
            return Scaffold(
              floatingActionButton: FloatingActionButton(onPressed: () {
                print(value.data);
                value.fetch_and_conect();
              }),
              body: Column(children: [Text("${value.data}")]),
            );
          },
        ));
  }
}

class Model extends ChangeNotifier {
  List<Map>? data;
  dynamic databaseHelper2;

  void fetch_and_conect() {
    // تحديد البلاتفورم واختيار الكلاس المناسب
    if (Platform.isAndroid) {
      databaseHelper2 = SqLite();
    } else if (Platform.isWindows) {
      databaseHelper2 = SqlWin();
    }
  }

  receve() async {
    data = await databaseHelper2.readData("SELECT * FROM Student");
    notifyListeners();
  }

  aa(x)async{
    data= await x;
    notifyListeners();
  }
}
