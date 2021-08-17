import 'package:apps/otherWidgets/loading.dart';
import 'package:flutter/material.dart';
import 'otherWidgets/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: { //sets up two different kind of pages that the app uses. home simply sets up the bottom navigation bar with a variety of widgets that get used to create "pages"
      '/home': (context) => home(),
      '/loading': (context) => loading(), //default loading screen
    },

  ));
}


