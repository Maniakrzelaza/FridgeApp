import 'package:eatit/fridge_item.dart';
import 'package:uuid/uuid.dart';

import './actions.dart';

var uuid = Uuid();

class FridgeState {
  List<FridgeItem> fridgeItems = new List();

  FridgeState(this.fridgeItems);

  var a  = {
    'b': 'c'
  };
}

FridgeState appReducers(FridgeState fridgeState, dynamic action) {
  if (action is CreateFridgeItemAction) {
    return createFridgeItem(fridgeState, action);
  }/* else if (action is ReadFridgeItemAction) {
    return readFridgeItem(fridgeState, action);
  }*/ else if (action is UpdateFridgeItemAction) {
    return updateFridgeItem(fridgeState, action);
  } else if (action is DeleteFridgeItemAction) {
    return deleteFridgeItem(fridgeState, action);
  }
  return fridgeState;
}

FridgeState createFridgeItem(FridgeState fridgeState, CreateFridgeItemAction action) {
  return new FridgeState(List.from(fridgeState.fridgeItems..add(action.item)));
}

/*FridgeState readFridgeItem(FridgeState fridgeState, ReadFridgeItemAction action) {
  return new FridgeState(fridgeState.fridgeItems.map((item) => item.id == action.item.id ?
    action.item : item).toList());
}*/

FridgeState updateFridgeItem(FridgeState fridgeState, UpdateFridgeItemAction action) {
  return new FridgeState(fridgeState.fridgeItems.map((item) => item.id == action.item.id ?
  action.item : item).toList());
}

FridgeState deleteFridgeItem(FridgeState fridgeState, DeleteFridgeItemAction action) {
  return new FridgeState(fridgeState.fridgeItems.where((item) => item.id != action.item.id).toList());
}

