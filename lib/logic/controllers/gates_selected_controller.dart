import 'package:flutter/cupertino.dart';

class GatesSelectedController extends ChangeNotifier {
  int questionNumber = 1;
  List<String> gatesSelected = [];

  void setSelected(List<String> selected) {
    gatesSelected = List.from(selected);
    notifyListeners();
  }

  void setQuestionNumber(int number) {
    questionNumber = number;
    notifyListeners();
  }
}
