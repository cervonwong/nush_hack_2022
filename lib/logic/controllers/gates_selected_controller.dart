import 'package:flutter/cupertino.dart';

class GatesSelectedController extends ChangeNotifier {
  List<String> gatesSelected = [];

  void setSelected(List<String> selected) {
    gatesSelected = List.from(selected);
    notifyListeners();
  }
}
