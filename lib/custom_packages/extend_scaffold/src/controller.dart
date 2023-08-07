import 'package:flutter/foundation.dart';

class ExtendScaffoldController extends ChangeNotifier {
  bool _sideSheetVisible = false;
  bool get sideSheetVisible => _sideSheetVisible;

  void showSideSheet() {
    if (!_sideSheetVisible) {
      _sideSheetVisible = true;
      notifyListeners();
    }
  }

  void hideSideSheet() {
    if (_sideSheetVisible) {
      _sideSheetVisible = false;
      notifyListeners();
    }
  }

  int _drawerIndex = 0;
  int get drawerIndex => _drawerIndex;
  set drawerIndex(int index) {
    _drawerIndex = index;
    if (_sideSheetVisible) {
      hideSideSheet();
    } else {
      notifyListeners();
    }
  }
}
