import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class loading extends StatefulWidget { //the loading page so we don't have to repeat this code.
  const loading({Key? key}) : super(key: key);

  @override
  _loadingState createState() => _loadingState();
}

class _loadingState extends State<loading> {

  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!.settings.arguments as Map; //the only argument that is passed is loadingTime for the spinner
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFc2e59c), Colors.yellow[700]!],
              begin: Alignment(0.0, 0.0),
              end: Alignment(0, -1),

            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(150),
            child: SleekCircularSlider(
                min: 0,
                max: 100,
                initialValue: 100,
                appearance: CircularSliderAppearance(
                  //spinnerMode: true,
                  animDurationMultiplier: arguments == null ? 20 : arguments['loadingTime'],
                  customWidths: CustomSliderWidths(handlerSize: 10, trackWidth: 10, shadowWidth: 5),
                  infoProperties: InfoProperties(topLabelText: "Loading")
                )),
          ),
        ),
      ),
    );
  }
}
