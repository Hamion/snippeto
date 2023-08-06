import 'package:flutter/foundation.dart';

class ExtendedScaffoldController extends ChangeNotifier {
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
}
