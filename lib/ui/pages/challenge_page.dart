import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../logic/controllers/gates_selected_controller.dart';
import '../../logic/gate.dart';
import 'congratz_page.dart';

class ChallengePage extends StatelessWidget {
  final int questionNumber;

  const ChallengePage({
    Key? key,
    required this.questionNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 88.0,
          vertical: 32.0,
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                'Challenge $questionNumber/6',
                style: GoogleFonts.firaSans(
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
              Text(
                'Construct the circuit for this boolean expression:',
                style: GoogleFonts.firaSans(
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              ExpressionLabel(
                expression: questionNumber == 1
                    ? "AB"
                    : questionNumber == 2
                        ? "A' + B"
                        : questionNumber == 3
                            ? "A'BC' + AB + AB'C"
                            : questionNumber == 4
                                ? "A'C + AB + AB'C'"
                                : questionNumber == 5
                                    ? "A' + B'"
                                    : questionNumber == 6
                                        ? "AB'C' + A'BC"
                                        : "Code broke lol",
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    questionNumber == 1
                        ? CircuitPane1()
                        : questionNumber == 2
                            ? CircuitPane2()
                            : questionNumber == 3
                                ? CircuitPane3()
                                : questionNumber == 4
                                    ? CircuitPane4()
                                    : questionNumber == 5
                                        ? CircuitPane5()
                                        : questionNumber == 6
                                            ? CircuitPane6()
                                            : Container(),
                    SizedBox(width: 16.0),
                    GateChoosingPane(),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  bool isCorrect = false;
                  final String? gate1 = Provider.of<GatesSelectedController>(
                          context,
                          listen: false)
                      .gate1;
                  final String? gate2 = Provider.of<GatesSelectedController>(
                          context,
                          listen: false)
                      .gate2;
                  final String? gate3 = Provider.of<GatesSelectedController>(
                          context,
                          listen: false)
                      .gate3;
                  final String? gate4 = Provider.of<GatesSelectedController>(
                          context,
                          listen: false)
                      .gate4;
                  switch (questionNumber) {
                    case 1:
                      if (gate1 == null) break;
                      isCorrect = checkGates(1, [gate1]);
                      break;
                    case 2:
                      if (gate1 == null || gate2 == null) break;
                      isCorrect = checkGates(2, [gate1, gate2]);
                      break;
                    case 3:
                      if (gate1 == null ||
                          gate2 == null ||
                          gate3 == null ||
                          gate4 == null) break;
                      isCorrect = checkGates(3, [gate1, gate2, gate3, gate4]);
                      break;
                    case 4:
                      if (gate1 == null || gate2 == null || gate3 == null)
                        break;
                      isCorrect = checkGates(4, [gate1, gate2, gate3]);
                      break;
                    case 5:
                      if (gate1 == null) break;
                      print(gate1);
                      isCorrect = checkGates(5, [gate1]);
                      break;
                    case 6:
                      if (gate1 == null || gate2 == null || gate3 == null)
                        break;
                      isCorrect = checkGates(6, [gate1, gate2, gate3]);
                      break;
                    default: // do nothing
                  }
                  if (!isCorrect) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            isCorrect ? "Correct!" : "Incorrect! Try again."),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          questionNumber == 6
                              ? "You have completed all six challenges!"
                              : "Yes, that's right!",
                          style: GoogleFonts.firaSans(
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ),
                        content: Text(
                          questionNumber == 6
                              ? ""
                              : "You selected the correct gates, proceed to the next challenge.",
                        ),
                        actionsPadding: const EdgeInsets.all(16.0),
                        titlePadding: const EdgeInsets.all(16.0),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              if (questionNumber == 6) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CongratzPage(),
                                  ),
                                );
                                Provider.of<GatesSelectedController>(context,
                                        listen: false)
                                    .setQuestionNumber(1);
                              } else {
                                Provider.of<GatesSelectedController>(context,
                                        listen: false)
                                    .setQuestionNumber(questionNumber + 1);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChallengePage(
                                        questionNumber: Provider.of<
                                                    GatesSelectedController>(
                                                context,
                                                listen: false)
                                            .questionNumber),
                                  ),
                                );
                              }
                            },
                            child: Text(questionNumber == 6 ? "Click for surprise" : "Next challenge"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Check circuit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpressionLabel extends StatelessWidget {
  final String expression;

  const ExpressionLabel({
    Key? key,
    required this.expression,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF9F0D0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        expression,
        style: GoogleFonts.firaCode(
          textStyle: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class GateChoosingPane extends StatelessWidget {
  const GateChoosingPane({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFF5C82A)),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ListView(
          children: [
            SizedBox(height: 8.0),
            Text(
              'Available',
              textAlign: TextAlign.center,
              style: GoogleFonts.firaSans(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(height: 24.0),
            DraggableGate(name: 'AND'),
            SizedBox(height: 24.0),
            DraggableGate(name: 'OR'),
            SizedBox(height: 24.0),
            DraggableGate(name: 'NOT'),
            SizedBox(height: 24.0),
            DraggableGate(name: 'NAND'),
            SizedBox(height: 24.0),
            DraggableGate(name: 'NOR'),
            SizedBox(height: 24.0),
            DraggableGate(name: 'XOR'),
            SizedBox(height: 24.0),
            DraggableGate(name: 'XNOR'),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}

class DraggableGate extends StatelessWidget {
  final String name;

  const DraggableGate({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<GateInfo>(
      data: GateInfo(
        gateName: name,
      ),
      child: SizedBox(
        height: 60.0,
        width: 80.0,
        child: Center(
          child: Image.asset('assets/$name.png'),
        ),
      ),
      feedback: SizedBox(
        height: 60.0,
        width: 80.0,
        child: Center(
          child: Image.asset('assets/$name.png'),
        ),
      ),
    );
  }
}

class GateInfo {
  final String gateName;

  GateInfo({required this.gateName});
}

// CIRCUIT PANES

class CircuitPane1 extends StatefulWidget {
  const CircuitPane1({
    Key? key,
  }) : super(key: key);

  @override
  State<CircuitPane1> createState() => _CircuitPane1State();
}

class _CircuitPane1State extends State<CircuitPane1> {
  String? currentGate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFF5C82A)),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/Circuit1.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    'Your circuit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaSans(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                height: 80.0 * MediaQuery.of(context).size.width / 1100.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1100.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return currentGate != null
                        ? Image.asset(
                            'assets/$currentGate.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        currentGate = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate1(data.gateName);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CircuitPane2 extends StatefulWidget {
  const CircuitPane2({
    Key? key,
  }) : super(key: key);

  @override
  State<CircuitPane2> createState() => _CircuitPane2State();
}

class _CircuitPane2State extends State<CircuitPane2> {
  String? gate1;
  String? gate2;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFF5C82A)),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/Circuit2.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    'Your circuit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaSans(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // 1st Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  0.0,
                  0.0,
                  MediaQuery.of(context).size.width * 0.185,
                  MediaQuery.of(context).size.width * 0.075,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate1 != null
                        ? Image.asset(
                            'assets/$gate1.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName == 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate1 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate1(data.gateName);
                  },
                ),
              ),
            ),
            // 2nd Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.175,
                  MediaQuery.of(context).size.width * 0.073,
                  0.0,
                  0.0,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate2 != null
                        ? Image.asset(
                            'assets/$gate2.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate2 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate2(data.gateName);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CircuitPane3 extends StatefulWidget {
  const CircuitPane3({
    Key? key,
  }) : super(key: key);

  @override
  State<CircuitPane3> createState() => _CircuitPane3State();
}

class _CircuitPane3State extends State<CircuitPane3> {
  String? gate1;
  String? gate2;
  String? gate3;
  String? gate4;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFF5C82A)),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/Circuit3.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    'Your circuit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaSans(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // 1st Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  0.0,
                  MediaQuery.of(context).size.width * 0.105,
                  MediaQuery.of(context).size.width * 0.31,
                  0.0,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate1 != null
                        ? Image.asset(
                            'assets/$gate1.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName == 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate1 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate1(data.gateName);
                  },
                ),
              ),
            ),
            // 2nd Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  0.0,
                  0.0,
                  MediaQuery.of(context).size.width * 0.18,
                  MediaQuery.of(context).size.width * 0.075,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate2 != null
                        ? Image.asset(
                            'assets/$gate2.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate2 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate2(data.gateName);
                  },
                ),
              ),
            ),
            // 3rd Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.03,
                  MediaQuery.of(context).size.width * 0.0425,
                  0.0,
                  0.0,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate3 != null
                        ? Image.asset(
                            'assets/$gate3.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate3 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate3(data.gateName);
                  },
                ),
              ),
            ),
            // 4th Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.31,
                  MediaQuery.of(context).size.width * 0.015,
                  0.0,
                  0.0,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate4 != null
                        ? Image.asset(
                            'assets/$gate4.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate4 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate4(data.gateName);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircuitPane4 extends StatefulWidget {
  const CircuitPane4({
    Key? key,
  }) : super(key: key);

  @override
  State<CircuitPane4> createState() => _CircuitPane4State();
}

class _CircuitPane4State extends State<CircuitPane4> {
  String? gate1;
  String? gate2;
  String? gate3;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFF5C82A)),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/Circuit4.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    'Your circuit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaSans(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // 2nd Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  0.0,
                  0.0,
                  MediaQuery.of(context).size.width * 0.18,
                  MediaQuery.of(context).size.width * 0.075,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate1 != null
                        ? Image.asset(
                            'assets/$gate1.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate1 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate1(data.gateName);
                  },
                ),
              ),
            ),
            // 3rd Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.03,
                  MediaQuery.of(context).size.width * 0.0425,
                  0.0,
                  0.0,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate2 != null
                        ? Image.asset(
                            'assets/$gate2.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate2 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate2(data.gateName);
                  },
                ),
              ),
            ),
            // 4th Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.31,
                  MediaQuery.of(context).size.width * 0.015,
                  0.0,
                  0.0,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate3 != null
                        ? Image.asset(
                            'assets/$gate3.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate3 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate3(data.gateName);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircuitPane5 extends StatefulWidget {
  const CircuitPane5({
    Key? key,
  }) : super(key: key);

  @override
  State<CircuitPane5> createState() => _CircuitPane5State();
}

class _CircuitPane5State extends State<CircuitPane5> {
  String? currentGate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFF5C82A)),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/Circuit1.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    'Your circuit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaSans(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                height: 80.0 * MediaQuery.of(context).size.width / 1100.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1100.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return currentGate != null
                        ? Image.asset(
                            'assets/$currentGate.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        currentGate = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate1(data.gateName);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CircuitPane6 extends StatefulWidget {
  const CircuitPane6({
    Key? key,
  }) : super(key: key);

  @override
  State<CircuitPane6> createState() => _CircuitPane6State();
}

class _CircuitPane6State extends State<CircuitPane6> {
  String? gate1;
  String? gate2;
  String? gate3;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFF5C82A)),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/Circuit6.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    'Your circuit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaSans(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // 2nd Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  0.0,
                  0.0,
                  MediaQuery.of(context).size.width * 0.18,
                  MediaQuery.of(context).size.width * 0.075,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate1 != null
                        ? Image.asset(
                            'assets/$gate1.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate1 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate1(data.gateName);
                  },
                ),
              ),
            ),
            // 3rd Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.03,
                  MediaQuery.of(context).size.width * 0.0425,
                  0.0,
                  0.0,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate2 != null
                        ? Image.asset(
                            'assets/$gate2.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate2 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate2(data.gateName);
                  },
                ),
              ),
            ),
            // 4th Gate
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.31,
                  MediaQuery.of(context).size.width * 0.015,
                  0.0,
                  0.0,
                ),
                height: 80.0 * MediaQuery.of(context).size.width / 1150.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCBCBCB),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DragTarget<GateInfo>(
                  builder: (
                    BuildContext context,
                    List<GateInfo?> accepted,
                    List<dynamic> rejected,
                  ) {
                    return gate3 != null
                        ? Image.asset(
                            'assets/$gate3.png',
                            fit: BoxFit.fill,
                          )
                        : Container();
                  },
                  onWillAccept: (data) {
                    return data?.gateName != 'NOT' ? true : false;
                  },
                  onAccept: (data) {
                    setState(
                      () {
                        gate3 = data.gateName;
                      },
                    );
                    Provider.of<GatesSelectedController>(context, listen: false)
                        .setGate3(data.gateName);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
