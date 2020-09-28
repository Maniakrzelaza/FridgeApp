import 'package:redux/redux.dart';
import 'package:eatit/fridge_item.dart';
import 'package:eatit/fridge/actions/fridge_actions.dart';
import 'package:eatit/fridge/store/fridge_items_state.dart';

final fridgeReducer = combineReducers<FridgeItemState>([
  TypedReducer<FridgeItemState, CreateFridgeItem>(_createFridgeItem),
  TypedReducer<FridgeItemState, UpdateFridgeItem>(_updateFridgeItem),
  TypedReducer<FridgeItemState, DeleteFridgeItem>(_deleteFridgeItem),
  TypedReducer<FridgeItemState, ResetFridgeItem>(_resetFridgeItem),

]);

FridgeItemState _createFridgeItem(FridgeItemState state, CreateFridgeItem action) {
  return FridgeItemState(fridgeItems: List.from(state.fridgeItems..add(action.fridgeItem)));
}

FridgeItemState _updateFridgeItem(FridgeItemState state, UpdateFridgeItem action) {
  return FridgeItemState(fridgeItems: state.fridgeItems
      .map((item) => item.id == action.fridgeItem.id ?
  action.fridgeItem : item).toList());
}

FridgeItemState _deleteFridgeItem(FridgeItemState state, DeleteFridgeItem action) {
  return FridgeItemState(fridgeItems: state.fridgeItems
      .where((item) => item.id != action.fridgeItem.id).toList());
}

FridgeItemState _resetFridgeItem(FridgeItemState state, ResetFridgeItem resetFridgeItem) {
  return FridgeItemState.initial();
}