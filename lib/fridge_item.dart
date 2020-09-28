import 'dart:collection';

import 'package:uuid/uuid.dart';

class FridgeItem {
  String id;
  String name;
  DateTime startDate;
  DateTime expireDate;
  DateTime dateOfNotification;

  FridgeItem(this.name, this.startDate, this.expireDate) {
    this.id = new Uuid().v4();
  }

  FridgeItem.of(this.id, this.name, this.startDate, this.expireDate);

  FridgeItem.fromJson(LinkedHashMap json) {
    this.id = json['id'];
    this.name = json['name'];
    this.startDate = DateTime.parse(json['startDate'].toString());
    print('startdate' + this.startDate.toString());
    this.expireDate = DateTime.parse(json['expireDate'].toString());
    print('expireDate' + this.expireDate.toString());
    this.dateOfNotification = DateTime.parse(json['endDate'].toString());
    print('dateOfNotification' + this.dateOfNotification.toString());
  }

  String toString() {
    return "Name: ${this.name} Start date: ${this.startDate}";
  }
}