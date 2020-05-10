
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

import './fridge_item.dart';
import 'package:eatit/fridge/actions/fridge_actions.dart';
import 'package:eatit/app_state.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class AddItemPage extends StatefulWidget {
  AddItemPage({Key key, this.fridgeItemToEdit}) : super(key: key);

  final FridgeItem fridgeItemToEdit;

  @override
  _AddItemPageState createState() => _AddItemPageState(fridgeItemToEdit);
}

class _AddItemPageState extends State<AddItemPage> {

  FridgeItem modelItem;
  bool isCreating;
  TextEditingController nameController = new TextEditingController();
  int inputNumber = 0;

  _AddItemPageState([FridgeItem fridgeItemToEdit]) :super() {
    if (fridgeItemToEdit != null) {
      modelItem = new FridgeItem.of(fridgeItemToEdit.id, fridgeItemToEdit.name, fridgeItemToEdit.startDate, fridgeItemToEdit.expireDate);
      if (fridgeItemToEdit.dateOfNotification != null) {
        print('AAAAAAA');
        print(fridgeItemToEdit.expireDate.toString());
        print(fridgeItemToEdit.dateOfNotification.toString());
        inputNumber = fridgeItemToEdit.expireDate.difference(fridgeItemToEdit.dateOfNotification).inDays;
      }
      nameController.text = modelItem.name;
      isCreating = false;
    } else {
      modelItem = new FridgeItem("",
          DateTime.now(),
          new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, DateTime.now().hour, DateTime.now().minute)
      );
      isCreating = true;
    }
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: modelItem.startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != modelItem.startDate)
      setState(() {
        modelItem.startDate = picked;
      });
  }

  Future<Null> _selectExpireDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: modelItem.expireDate,
        firstDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != modelItem.expireDate)
      setState(() {
        modelItem.expireDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(this.isCreating ? "Add item to the fridge" : "Edit fridge item"),
      ),
      backgroundColor: Color(0xffc3e7f4),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                    controller: new TextEditingController()..text = "${modelItem.startDate.toLocal()}".split(' ')[0],
                    readOnly: true,
                    onTap: () => _selectStartDate(context),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Start date',
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: new TextEditingController()..text = "${modelItem.expireDate.toLocal()}".split(' ')[0],
                    readOnly: true,
                    onTap: () => _selectExpireDate(context),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Expire date',
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                ],
              ),
              this.getNotificationButton(),
              RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  if (this.isCreating) {
                    FridgeItem fridgeItem = new FridgeItem(this.nameController.text, modelItem.startDate, modelItem.expireDate);
                    fridgeItem.dateOfNotification = this.getNotificationDate();
                    StoreProvider.of<AppState>(context)
                        .dispatch(CreateFridgeItem(fridgeItem: fridgeItem));
                  } else {
                    FridgeItem fridgeItem = FridgeItem.of(modelItem.id, this.nameController.text, modelItem.startDate, modelItem.expireDate);
                    fridgeItem.dateOfNotification = this.getNotificationDate();
                    StoreProvider.of<AppState>(context)
                        .dispatch(UpdateFridgeItem(fridgeItem: fridgeItem));
                  }
                  Navigator.pop(context);
                },
                child: Text(this.isCreating ? 'Add' : 'Save', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
        ),),
      ),
      floatingActionButton: Visibility(
        visible: !this.isCreating,
        child: FloatingActionButton(
          onPressed: () {
            StoreProvider.of<AppState>(context)
                .dispatch(DeleteFridgeItem(fridgeItem: modelItem));
            Navigator.pop(context);
          },
          child: Icon(Icons.delete),
          backgroundColor: Colors.red,
      ),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  DateTime getNotificationDate() {
    if (this.inputNumber != 0) {
      DateTime result = new DateTime.fromMillisecondsSinceEpoch(this.modelItem.expireDate.millisecondsSinceEpoch);
      result = result.subtract(new Duration(days: this.inputNumber));
      return result;
    }
    return null;
  }

  Future _showIntDialog() async {
    DateTime startDate = this.modelItem.startDate;
    DateTime expireDate = this.modelItem.expireDate;
    Duration duration = expireDate.difference(startDate);
    int maxDays = duration.inDays;
    maxDays = maxDays < 0 ? 0 : maxDays;
    if (maxDays == 0) {
      Fluttertoast.showToast(
        msg: "There is no point to add notification if days between start and expire date is equal to 1 or less",
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: maxDays,
          initialIntegerValue: inputNumber,
          title: Text(
              'How many days before expire date do yow want to be notificated?',
              textAlign: TextAlign.center
          ),
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => inputNumber = value);
      }
    });
  }

  Widget getNotificationButton() {
    if (this.inputNumber == 0) {
      return RaisedButton(
        color: Colors.blue,
        onPressed: () {
          this._showIntDialog();
        },
        child: Text('Add notification', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      );
    } else {
      return new GestureDetector(
        onTap: () {
          this._showIntDialog();
        },
        child: Container(
          height: 80,
          color: Colors.white,
          child: Center(child: Text('Days before notification: ${inputNumber.toString()}')),
        ),
      );
    }
  }

  /*Future<void> _showNotification() async {
    var maxProgress = 5;
    for (var i = 0; i <= maxProgress; i++) {
      await Future.delayed(Duration(seconds: 1), () async {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'progress channel',
            'progress channel',
            'progress channel description',
            channelShowBadge: false,
            importance: Importance.Max,
            priority: Priority.High,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }*/
}
