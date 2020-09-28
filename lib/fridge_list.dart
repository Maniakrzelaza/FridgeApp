import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:async';
import 'package:cron/cron.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import './add_item_page.dart';
import './fridge_item.dart';
import 'package:eatit/app_state.dart';
import 'package:eatit/fridge/actions/fridge_actions.dart';

class FridgeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: Text("Your fridge"),),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              print('aaaaaaa');
              var url = 'https://kdondziak.pl/api/fridgeItem';

              Dio dio = new Dio();
              (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
                  (HttpClient client) {
                client.badCertificateCallback =
                    (X509Certificate cert, String host, int port) => true;
                return client;
              };
              Response response = await dio.get(url);
              this.saveSyncedItems(context, response);

             // Response response = await dio.post(url, data: {'name': 'name1', 'startDate': '2008-12-03T10:15:30', 'endDate': '2009-12-03T10:15:30', 'expireDate' : '2007-12-03T10:15:30'});

            },
          ),
        ],
      ),
      backgroundColor: Color(0xffc3e7f4),
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: state.fridgeState.fridgeItems.length,
                separatorBuilder: (BuildContext context, int index) => const Divider(height: 8),
                itemBuilder: (BuildContext context, int index) {
                  return this.getWrappedItem(context, index, state.fridgeState.fridgeItems);
                }
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemPage(context: context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void saveSyncedItems(BuildContext context, Response response) {

    print(response.data);
    List<dynamic> aaa = response.data;
    StoreProvider.of<AppState>(context)
        .dispatch(ResetFridgeItem());

    for (LinkedHashMap item in aaa) {
      print('aa');
      print(item);
      FridgeItem fridgeItem = FridgeItem.fromJson(item);
      print(fridgeItem);
          StoreProvider.of<AppState>(context)
        .dispatch(CreateFridgeItem(fridgeItem: fridgeItem));
    }

  }

  Widget getWrappedItem(BuildContext context, int index, List<FridgeItem> items) {
    var item = items[index];
    return Dismissible(
      // Show a red background as the item is swiped away.
      key: Key(item.name),
      confirmDismiss: (DismissDirection direction) => this._showDialog(direction, context),
      onDismissed: (direction) {
        StoreProvider.of<AppState>(context)
            .dispatch(DeleteFridgeItem(fridgeItem: item));
        Scaffold
            .of(context)
            .showSnackBar(SnackBar(content: Text("${item.name} removed")));
      },
      child: GestureDetector(
        onTap: () {
          this._showAddItemPage(context: context, fridgeItemToEdit: item);
        },
        child: Container(
          height: 80,
          color: Colors.white,
          child: Center(child: this.fridgeItemToWidget(items[index], context: context)),
        ),
      ),
    );
  }

  void _showAddItemPage({BuildContext context, FridgeItem fridgeItemToEdit}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemPage(fridgeItemToEdit: fridgeItemToEdit)),
    );
  }

  Widget fridgeItemToWidget(FridgeItem fridgeItem, { BuildContext context }) {
    Duration daysBetweenStartAndExpire = fridgeItem.expireDate.difference(fridgeItem.startDate);
    Duration daysBetweenExpireAndNow = fridgeItem.expireDate.difference(DateTime.now());
    double diff = daysBetweenExpireAndNow.inMinutes / daysBetweenStartAndExpire.inMinutes;
    print("AAAAA" + diff.toString());
    diff = diff > 0.0 ? diff : -1.0;
    diff = diff > 1.0 ? 1.0 : diff;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(fridgeItem.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        Text("Buy date: ${new DateFormat.yMMMd().add_Hm().format(fridgeItem.startDate.toLocal())}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        Text("Expire Date: ${new DateFormat.yMMMd().add_Hm().format(fridgeItem.expireDate.toLocal())}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        Padding(padding: EdgeInsets.all(5.0), child: new LinearPercentIndicator(
          width: MediaQuery.of(context).size.width / 1.5,
          lineHeight: 10.0,
          percent: diff.abs(),
          progressColor: this.getValidityBarColor(diff),
          alignment: MainAxisAlignment.center,
        ),),
      ],
    );
  }

  MaterialColor getValidityBarColor(double val) {
    if (val <= 0.0) {
      return Colors.brown;
    }
    if (val > 0.8) {
      return Colors.green;
    }
    if (val > 0.5) {
      return Colors.yellow;
    }
    if (val > 0.3) {
      return Colors.orange;
    }
    return Colors.red;
  }

  Future<bool>  _showDialog(DismissDirection direction, BuildContext context) async {
    if (direction == DismissDirection.endToStart) {
      final bool res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content: const Text("Are you sure you wish to delete this item?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("DELETE")
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("CANCEL"),
              ),
            ],
          );
        },
      );
      return res;
    }

    return false;
  }

}