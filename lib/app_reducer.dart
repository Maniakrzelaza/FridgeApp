import 'package:eatit/app_state.dart';
import 'package:eatit/fridge/reducer/fridge_items_redcer.dart';

AppState appReducer(AppState currentState, action) {
  return AppState(
      fridgeState: fridgeReducer(currentState.fridgeState, action));
}