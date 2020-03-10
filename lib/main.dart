import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save Operation value to Phone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(
        storage: Storage(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final Storage storage;
  Home({Key key, @required this.storage}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController num1 = TextEditingController();
  TextEditingController num2 = TextEditingController();
  String result;
  Future<Directory> _appDirectory;

  @override
  void initState() {
    super.initState();
    widget.storage.readData().then((String value) {
      setState(() {
        result = value;
      });
    });
  }

  Future<File> operationData() async {
    setState(() {
      int firstNum = int.parse(num1.text);
      int secondNum = int.parse(num2.text);
      int total = firstNum + secondNum;
      int multiplication = firstNum * secondNum;
      int subtraction = firstNum - secondNum;
      double division = firstNum / secondNum;
      result = "\n \n \n Sum is: ${total.toString()} \n" +
          "Subtraction is: ${subtraction.toString()} \n" +
          "Multiplication is: ${multiplication.toString()} \n" +
          "Division is: ${division.toString()} \n";
      num1.text = "";
      num2.text = "";
    });
    return widget.storage.writeData(result);
  }

  void getAppDirectory() {
    setState(() {
      _appDirectory = getApplicationDocumentsDirectory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Read and Write Data locally"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 400,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('\t \t \t ${result ?? "File Is Empty"}',textAlign: TextAlign.center,)),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: num1,
                      decoration: InputDecoration(
                        hintText: "Num 1...",
                        contentPadding: const EdgeInsets.all(20),
                        errorBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: num2,
                    decoration: InputDecoration(
                      hintText: "Num 2...",
                      contentPadding: const EdgeInsets.all(20),
                      errorBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            ButtonTheme(
              minWidth: 200,
              height: 40,
              child: RaisedButton(
                onPressed: operationData,
                child: Text("Post Operation to File"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              minWidth: 200,
              buttonColor: Colors.grey,
              child: RaisedButton(
                onPressed: getAppDirectory,
                child: Text("Get Directory Path"),
              ),
            ),
            FutureBuilder<Directory>(
              future: _appDirectory,
              builder:
                  (BuildContext context, AsyncSnapshot<Directory> snapshot) {
                Text text = Text("");
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    text = Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    text = Text("Path: ${snapshot.data.path}");
                  } else {
                    text = Text("Unavailable");
                  }
                }
                return new Container(
                  child: text,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class Storage {
  Future<String> get localPath async {
    final dir = await getExternalStorageDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/Get opertaion.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString('$data');
  }
}
