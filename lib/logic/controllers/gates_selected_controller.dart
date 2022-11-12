import 'package:flutter/cupertino.dart';

class GatesSelectedController extends ChangeNotifier {
  int questionNumber = 6;
  String? gate1;
  String? gate2;
  String? gate3;
  String? gate4;

  void setGate1(String name) {
    gate1 = name;
  }

  void setGate2(String name) {
    gate2 = name;
  }

  void setGate3(String name) {
    gate3 = name;
  }

  void setGate4(String name) {
    gate4 = name;
  }

  void setQuestionNumber(int number) {
    questionNumber = number;
    gate1 = null;
    gate2 = null;
    gate3 = null;
    gate4 = null;
    notifyListeners();
  }
}
