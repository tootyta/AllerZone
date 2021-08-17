import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class hourCard extends StatelessWidget { //the widget for each hour's forecast for pollen
  late Map attributes;
  hourCard({Key? key, required this.attributes}) : super(key: key); //we GOTS TO MAKE PARAMETERS AAAA!!! also attributes r things like time, grass_pollen, risk, etc!

  late String datee;
  late String time;



  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(attributes['time'] * 1000);
    datee = DateFormat('MM/dd').format(date);
    time = DateFormat('hh:mm a').format(date);


    return Container(
      //child: Text(attributes['time']!.toString()),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(0.0)),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("AllerZone"),
                  content: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Grass Pollen Levels on " + datee + " at " + time + ": " +
                            attributes["Count"]["grass_pollen"].toString() +
                            " pollen particles/m3\n\nRisk Level: ", style: TextStyle(color: Colors.black)),
                        TextSpan(text: attributes["Risk"]["grass_pollen"].toString() + "\n\n", style: TextStyle(color: _getRiskColor(attributes["Risk"]["grass_pollen"].toString()))),
                        TextSpan(text: "Weed Pollen Levels on " + datee + " at " + time + ": " +
                            attributes["Count"]["weed_pollen"].toString() +
                            " pollen particles/m3\n\nRisk Level: ", style: TextStyle(color: Colors.black)),
                        TextSpan(text: attributes["Risk"]["weed_pollen"].toString() + "\n\n", style: TextStyle(color: _getRiskColor(attributes["Risk"]["weed_pollen"].toString()))),
                        TextSpan(text: "Tree Pollen Levels on " + datee + " at " + time + ": " +
                            attributes["Count"]["tree_pollen"].toString() +
                            " pollen particles/m3\n\nRisk Level: ", style: TextStyle(color: Colors.black)),
                        TextSpan(text: attributes["Risk"]["tree_pollen"].toString() + "\n\n", style: TextStyle(color: _getRiskColor(attributes["Risk"]["tree_pollen"].toString()))),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton( //should simplify this tbh b/c its overly repetitive
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
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.yellow[700]!,
                  Colors.yellow[100]!,
                ]
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(width:10),
                Column(
                  children: [
                    Text(
                        datee,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                    ),
                    Text(
                        time,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                  ],
                ),
                Container(width:125),
                Column(
                  children: [
                    Text(
                      "Grass Pollen: " + attributes["Count"]["grass_pollen"].toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      "Weed Pollen: " + attributes["Count"]["weed_pollen"].toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      "Tree Pollen: " + attributes["Count"]["tree_pollen"].toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color? _getRiskColor(String risk) {
    switch (risk) {
      case "Low":
        return Colors.green;
      case "Moderate":
        return Colors.yellow[700];
      case "High":
        return Colors.red;
      default:
        return Colors.red[700];
    }
  }
}
