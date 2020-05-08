import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:async';
import 'package:cron/cron.dart';

import './add_item_page.dart';
import './fridge_item.dart';
import './reducer.dart';
import 'package:eatit/actions.dart';
import 'package:eatit/reducer.dart';

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: Text("Settings"),),
      ),
      backgroundColor: Color(0xffc3e7f4),
      body: StoreConnector<FridgeState, FridgeState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Text('Laaaaaa'),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<Null> _selectNotificationTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }

}