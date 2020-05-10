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
import 'package:eatit/fridge_list.dart';
import 'package:eatit/settings_page.dart';
import 'package:eatit/app_state.dart';

class App extends StatefulWidget {
  final Store<AppState> store;

  App(this.store, {Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState(store);
}

class _AppState extends State<App> {
  final Store<AppState> store;

  int _selectedIndex = 0;
  _AppState(this.store);

  Widget getNavigatedOption(int option) {
    List<Widget> options = [
      FridgeList(),
      Settings()
    ];
    return options[option];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cron = new Cron();
    cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
      print('every minute12');
      await _showNotification(context);
    });
    return Scaffold(
      backgroundColor: Color(0xffc3e7f4),
      body: this.getNavigatedOption(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Fridge'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        backgroundColor: Color(0xff00708D),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _showNotification(BuildContext context) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print('tera wyswietle state1234');
    final store = StoreProvider.of<AppState>(context);
    print(store.state.fridgeState.fridgeItems.length);
    store.state..fridgeState.fridgeItems.forEach((it) {
      print(it.toString());
    });
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

}