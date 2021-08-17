import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:apps/otherWidgets/forecast.dart';
import 'package:apps/services/location.dart';
import 'package:http/http.dart';
import 'package:apps/otherWidgets/predictions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final Map<String, String> headers = {
  "Content-type": "application/json",
  "x-api-key": "da372c8581f5137c79fa7dc4bfdfc266f2221571105b9321e70a112e9384905f" //put ambee api key here.
}; //ohter api key: da372c8581f5137c79fa7dc4bfdfc266f2221571105b9321e70a112e9384905f, a866fbdb00103c8aae0785ba0b7b17102cb4c9aa0d20b25efaa9abc3025ba2dc

class home extends StatefulWidget { //the body widget that includes the bottom navigation bar to decide which page the user decides to get on.
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  int _currentIndex = 0;
  static late Location passed = new Location(); //location attribute so that app doesn't re-request location multiple times

  static List<Widget> _listOfWidgets = [
    getPollen(attr: passed),
    prediction(attr: passed),
    forecast(attr: passed),
    Text("hi"),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient:
            LinearGradient(colors: [Color(0xFFc2e59c), Color(0xFF64b3f4)]),
          ),
        ),
        title: Text('AllerZone'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(55, 189, 68, 100),
      ),
      body: Container(
        child: IndexedStack(
          children: _listOfWidgets,
          index: _currentIndex,
        ),
        decoration: BoxDecoration(
          gradient:
          LinearGradient(colors: [Color(0xFFc2e59c), Colors.white]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // because with 4+ items the type of the bottomnavbar changes to shifting -> meaning it uses default colors and such so it defualts to white
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        items: <BottomNavigationBarItem>[ //different pages
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Daily Pollen",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit),
            label: "Prediction",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart_outlined),
            label: "Forecast",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_outlined),
            label: "Need Help?",
          ),
        ],
        onTap: (int i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
    );
  }
}

class PollenData { //data objects to be used for graphing
  PollenData(this.species, this.pl);
  final String species;
  final int pl;
}


class getPollen extends StatefulWidget { //default page to get daily pollen levels at current moment
  late Location attr;
  getPollen({Key? key, required this.attr}) : super(key: key);

  @override
  _getPollenState createState() => _getPollenState();
}

class _getPollenState extends State<getPollen> {

  Map data = {};
  final myController = TextEditingController();
  RichText loading = new RichText(text: TextSpan(text: "loading", style: TextStyle(color: Colors.black)));
  String dropVal = "Grass"; //default dropdown value for daily pollen
  List<PollenData> dataToGraph = [];


  Future<void> getData(double lat, double lng) async { //actually grabs data from API for current pollen data
    Response response = await get(Uri.parse("https://api.ambeedata.com/latest/pollen/by-lat-lng?lat=" + lat.toString() + "&lng=" + lng.toString()), headers: headers);
    data = jsonDecode(response.body);
    print(data);
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container( //all design stuff for the homepage
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 30),
          Text("What type of pollen levels do you want?"),
          Container(height: 30),
          Container(
              width: 65,
              child: DropdownButton<String>(
                value: dropVal,
                icon: const Icon(Icons.nature),
                iconEnabledColor: Colors.green,
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.lightGreen,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropVal = newValue!;
                  });
                },
                items: <String>['Grass', 'Tree', 'Weed']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
          ),
          Container(height: 30),
          ElevatedButton(
            onPressed: () async {
              dataToGraph.clear();
              await _getCurrentPollen();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("AllerZone"),
                      content: loading,
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("AllerZone"),
                                    content: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Low ',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                          TextSpan(
                                              text: '- Mild risk to those with severe respiratory issues. No risk for the general public.\n\n',
                                              style: TextStyle(color: Colors.black)
                                          ),
                                          TextSpan(
                                            text: 'Moderate ',
                                            style: TextStyle(color: Colors.yellow[700]),
                                          ),
                                          TextSpan(
                                              text: '- Risky for those with severe respiratory problems. Mild risk for the general public.\n\n',
                                              style: TextStyle(color: Colors.black)
                                          ),
                                          TextSpan(
                                            text: 'High ',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          TextSpan(
                                              text: '- Risky for all groups of people.\n\n',
                                              style: TextStyle(color: Colors.black)
                                          ),
                                          TextSpan(
                                            text: 'Very High ',
                                            style: TextStyle(color: Colors.red[700]),
                                          ),
                                          TextSpan(
                                              text: '- Highly risky for all groups of people.',
                                              style: TextStyle(color: Colors.black)
                                          ),
                                        ],

                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  );
                                }
                            );

                          },
                          child: Text(
                            "What does risk level mean?",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green[400],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  }
              );
            },
            child: Text("Submit!"),

          ),
          Container(height: 40),
          Container(
            height:250,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: "Species"),
                ),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(text: "Pollen Level (pollen particles/m3)")
                ),
                title: ChartTitle(text: 'Pollen Levels by Species'),
                series: <BarSeries<PollenData, String>>[
                  BarSeries<PollenData, String>(
                      dataSource:  dataToGraph,
                      xValueMapper: (PollenData data, _) => data.species,
                      yValueMapper: (PollenData data, _) => data.pl,
                      // Enable data label
                      dataLabelSettings: DataLabelSettings(isVisible: true)
                  )
                ]
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _getCurrentPollen() async { //parses the api data and shows a popup with the data in a readable format
    Map<String, String> pollen_ref = {
      "Grass": "grass_pollen",
      "Tree": "tree_pollen",
      "Weed": "weed_pollen",
    };
    if (data.isEmpty) { //basically checks if we've already requested data from the API
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/loading', arguments: {"loadingTime" : 5.00});
      });
      await getData(await widget.attr.getLatitude(), await widget.attr.getLongitude());
      Navigator.pop(context);
    }
    setState(() {
      Color? colord;
      String risk = data['data'][0]["Risk"][pollen_ref[dropVal]].toString();
      switch (risk) {
        case "Low":
          colord = Colors.green;
          break;
        case "Moderate":
          colord = Colors.yellow[700];
          break;
        case "High":
          colord = Colors.red;
          break;
        default:
          colord = Colors.red[700];

      }

      loading = RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Current " + dropVal + " Pollen Levels: " +
                data['data'][0]["Count"][pollen_ref[dropVal]].toString() +
                " pollen particles/m3\n\nRisk Level: ", style: TextStyle(color: Colors.black)),
            TextSpan(text: risk, style: TextStyle(color: colord)),
          ],
        ),
      );
      data['data'][0]["Species"][dropVal].forEach((key, value) {
        dataToGraph.add(PollenData(key, value));
      });
    });
  }



}