import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'reducer.dart';

final _initialState = FridgeState(new List());

class SingletonStore {
  static final SingletonStore _singleton = new SingletonStore._internal();
  Store<FridgeState> _store;

  factory SingletonStore() {
    return _singleton;
  }

  SingletonStore._internal() {
    _store = Store<FridgeState>(appReducers, initialState: _initialState);
  }

  Store<FridgeState> getStore() {
    return _store;
  }

}
