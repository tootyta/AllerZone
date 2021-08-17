
import 'dart:convert';

import 'package:apps/services/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class prediction extends StatefulWidget {
  late Location attr;
  prediction({Key? key, required this.attr}) : super(key: key);

  @override
  _predictionState createState() => _predictionState();
}

class _predictionState extends State<prediction> {
  Map<String, String> _listOfDays = {};
  String contentDefined = "";
  List<DropdownMenuItem<String>> dropDownItems = <String>['Yes', 'No']
      .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 20),
            Text("Want an estimate on what type of pollen you might be allergic to? Simply fill in whether you had bad allergies for the past seven days and we'll give you our thoughts."),
            Container(height: 10),
            Text(
                "Note: As these predictions are only based on 7 days of data, they may be inaccurate. Consult your doctor for more accurate results.",
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            scripted(),
            ElevatedButton(
              onPressed: () async {
                await _predict();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("AllerZone"),
                        content: Text(contentDefined == "" ? "You don't appear to be allergic to any pollen. Consult a doctor for more accurate results." : contentDefined),
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
              child: Text("PREDICT!"),

            ),
          ],
        ),
      ),
    );
  }

  Widget scripted() { //all the formatting for setting up the questions to ask whether the user had bad allergies.
    List<Widget> widgets = [];
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    for(int i = 0; i < 7; i++) {
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Bad Allergies on " + formatter.format(now) + "?"),
          Container(width: 20),
          Container(
            width: 75,
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
                contentPadding: EdgeInsets.all(3),
              ),
              child: DropdownButton<String>(
                value: _listOfDays['day' + (i+1).toString()],
                icon: const Icon(Icons.nature),
                iconEnabledColor: Colors.green,
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    _listOfDays['day' + (i+1).toString()] = newValue!;
                  });
                },
                items: dropDownItems,
              ),
            ),
          )
        ],
      ),
      );
      widgets.add(Container(height:15));
      now = now.subtract(const Duration(hours : 24));
    }
    return Column(
      children: widgets,
    );
  }

  Future<void> _predict() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushNamed(context, '/loading', arguments: {"loadingTime": 20.00});
    });
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 30);
    int totalGrass = 0, totalTree = 0, totalWeed = 0;
    double marginGrass = 0, marginTree = 0, marginWeed = 0;
    bool riskGrass = false, riskTree = false, riskWeed = false; //so many primitives aaUGH!
    for(int i = 1; i<=7; i++) {
      DateTime later = now.add(const Duration(hours: 1));
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String date = formatter.format(now);
      String dated = formatter.format(later);
      double lat = await widget.attr.getLatitude(); // done to use home location and not literal android location -- why are we in CA ?
      double long = await widget.attr.getLongitude();
      Response response = await get(Uri.parse("https://api.ambeedata.com/history/pollen/by-lat-lng?lat=" + lat.toString() + "&lng=" + long.toString() + "&from=" + date + "&to=" + dated), headers: headers);
      Map datapast = jsonDecode(response.body);
      //redundant yet proportional checks for allergies with considered Risk.
      totalGrass += int.parse(datapast['data'][0]["Count"]["grass_pollen"].toString());
      if(_listOfDays['day' + i.toString()] == "Yes") {
        if(datapast['data'][0]["Risk"]["grass_pollen"] != "Low") { riskGrass = true; }
        marginGrass += int.parse(datapast['data'][0]["Count"]["grass_pollen"].toString());
      }
      totalTree += int.parse(datapast['data'][0]["Count"]["tree_pollen"].toString());
      if(_listOfDays['day' + i.toString()] == "Yes") {
        if(datapast['data'][0]["Risk"]["tree_pollen"] != "Low") { riskTree = true; }
        marginTree += int.parse(datapast['data'][0]["Count"]["tree_pollen"].toString());
      }
      totalWeed += int.parse(datapast['data'][0]["Count"]["weed_pollen"].toString());
      if(_listOfDays['day' + i.toString()] == "Yes") {
        if(datapast['data'][0]["Risk"]["weed_pollen"] != "Low") { riskWeed = true; }
        marginWeed += int.parse(datapast['data'][0]["Count"]["weed_pollen"].toString());
      }

      print("done request" + i.toString()); //just debugging :D
      now = now.subtract(const Duration(hours: 24)); //go back past 1 day per call.
    }
    //printWrapped(days.toString());
    if(marginGrass/totalGrass >= 0.5) {
      contentDefined += "You might be allergic to grass pollen.";
      if(!riskGrass == true) { //each risk[PollenType] variable is just a way of making the algorithm  more accurate b/c it tends to have false positives
        contentDefined += " However, grass pollen was not high at all this week, so take these results with caution.";
      }
    }
    if(marginWeed/totalWeed >= 0.5) {
      contentDefined += "\n\nYou might be allergic to weed pollen.";
      if(!riskWeed == true) {
        contentDefined += " However, weed pollen was not high at all this week, so take these results with caution.";
      }
    }
    if(marginTree/totalTree >= 0.5) {
      contentDefined += "\n\nYou might be allergic to tree pollen.";
      if(!riskTree == true) {
        contentDefined += " However, tree pollen was not high at all this week, so take these results with caution.";
      }
    }
    Navigator.pop(context);



  }
}
