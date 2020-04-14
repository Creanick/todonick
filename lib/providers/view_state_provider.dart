import 'package:flutter/foundation.dart';

enum ViewState { initial, initialLoading, loading, idle }

class ViewStateProvider with ChangeNotifier {
  ViewState _state = ViewState.initial;
  ViewState get state => _state;
  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  void startInitialLoader() {
    setState(ViewState.initialLoading);
  }

  void startLoader() {
    setState(ViewState.loading);
  }

  void stopLoader() {
    setState(ViewState.idle);
  }
}
