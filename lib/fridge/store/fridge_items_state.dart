import 'package:meta/meta.dart';
import 'package:eatit/fridge_item.dart';
import 'package:collection/collection.dart';

@immutable
class FridgeItemState {
  final List<FridgeItem> fridgeItems;

  const FridgeItemState({@required this.fridgeItems});

  static FridgeItemState initial() {
    return new FridgeItemState(fridgeItems: new List<FridgeItem>());
  }

  @override
  String toString() {
    return 'DetailState: {photoUrl: $fridgeItems}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FridgeItemState &&
              runtimeType == other.runtimeType &&
              ListEquality().equals(fridgeItems, other.fridgeItems);

  @override
  int get hashCode => fridgeItems.hashCode;
}