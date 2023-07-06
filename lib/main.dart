import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_table/json_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List jsonData = [
    {
      "id": "0001",
      "type": "donut",
      "name": "Cake",
      "ppu": 0.55,
      "batters": {
        "batter": [
          {"id": "1001", "type": "Regular"},
          {"id": "1002", "type": "Chocolate"},
          {"id": "1003", "type": "Blueberry"}
        ]
      },
      "topping": [
        {"id": "5001", "type": "None"},
        {"id": "5002", "type": "Glazed"},
        {"id": "5005", "type": "Sugar"},
        {"id": "5007", "type": "Powdered Sugar"}
      ]
    },
    {
      "id": "0002",
      "type": "donut",
      "name": "Cake",
      "ppu": 0.55,
      "batters": {
        "batter": [
          {"id": "1001", "type": "Blueberry"}
        ]
      },
      "topping": [
        {"id": "5001", "type": "None"},
        {"id": "5002", "type": "Glazed"}
      ]
    }
  ];
  List jsonData1 = [];
  String jsonString = '';
  var jsonFinal;
  @override
  void initState() {
    super.initState();
    setState(() {
      jsonData1 = [];
    });
    formatData();
  }

  formatData() {
    setState(() {
      jsonData = jsonData
          .map((item) async => {batterValue(item, item['batters']["batter"])})
          .toList();
    });
  }

  batterValue(item, batterItem) async {
    dynamic batterFormat;
    dynamic toppingFormat;
    var formattedObject = {};
    List toppingList = [];
    toppingFormat = item['topping']
        .map((topping) => {toppingList.add(topping['type'])})
        .toList();
    batterFormat = await batterItem
        .map((batterValue) => {
              formattedObject = {
                "id": item['id'].toString(),
                "type": item["type"].toString(),
                "name": item["name"].toString(),
                "ppu": item["ppu"].toString(),
                "batters": batterValue['type'].toString(),
                "toppings": toppingList.join(',')
              },
              jsonData1.add(jsonEncode(formattedObject))
            })
        .toList();
    setState(() {
      jsonData = jsonData1;
      jsonString = jsonData.toString();
      jsonFinal = jsonDecode(jsonString);
    });
    print("jsonFinal $jsonFinal");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Table View")),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            jsonFinal != null
                ? JsonTable(
                    jsonFinal,
                  )
                : Center(child: Text("No table available")),
          ],
        ),
      )),
    );
  }
}
