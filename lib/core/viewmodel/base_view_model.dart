import 'package:flutter/material.dart';

enum ViewStatus { ready, busy }

class BaseViewModel extends ChangeNotifier {
  ViewStatus _status = ViewStatus.ready;

  ViewStatus get status => _status;

  bool get isBusy => _status == ViewStatus.busy;

  void setStatus(ViewStatus value) {
    _status = value;
    notifyListeners();
  }
}
