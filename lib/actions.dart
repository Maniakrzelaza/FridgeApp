
import 'package:eatit/fridge_item.dart';

enum Actions {
  CreateFridgeItem,
  ReadFridgeItem,
  DeleteFridgeItem,
  UpdateFridgeItem
}

class CreateFridgeItemAction {
  final FridgeItem item;

  CreateFridgeItemAction(this.item);
}

class ReadFridgeItemAction {
  final FridgeItem item;

  ReadFridgeItemAction(this.item);
}

class DeleteFridgeItemAction {
  final FridgeItem item;

  DeleteFridgeItemAction(this.item);
}

class UpdateFridgeItemAction {
  final FridgeItem item;

  UpdateFridgeItemAction(this.item);
}