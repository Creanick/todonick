import 'package:flutter/foundation.dart';

enum ViewState { initial, loading, idle }

class ViewStateProvider with ChangeNotifier {
  ViewState _state = ViewState.initial;
  ViewState get state => _state;
  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  void startLoader() {
    setState(ViewState.loading);
  }

  void stopLoader() {
    setState(ViewState.idle);
  }
}
