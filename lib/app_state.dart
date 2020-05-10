import 'package:meta/meta.dart';
import 'package:eatit/settings_state.dart';
import 'package:eatit/fridge/store/fridge_items_state.dart';

@immutable
class AppState {
  final FridgeItemState fridgeState;
  //final SettingsState settingsState;

  const AppState({@required this.fridgeState});

  @override
  String toString() {
    return 'AppState: {$fridgeState}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              fridgeState == other.fridgeState;

  @override
  int get hashCode => fridgeState.hashCode;

  factory AppState.initialState() => AppState(
      fridgeState: FridgeItemState(fridgeItems: List())
  );
}