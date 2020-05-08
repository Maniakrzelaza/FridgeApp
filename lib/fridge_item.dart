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

  String toString() {
    return "Name: ${this.name} ";
  }
}