import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../logic/controllers/gates_selected_controller.dart';
import '../../logic/gate.dart';

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
                    CircuitPane1(),
                    SizedBox(width: 16.0),
                    GateChoosingPane(),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: checkGates(
                              1,
                              Provider.of<GatesSelectedController>(context,
                                      listen: false)
                                  .gatesSelected)
                          ? Text(
                              "Correct! ${Provider.of<GatesSelectedController>(
                              context,
                              listen: false,
                            ).gatesSelected}")
                          : Text(
                              "Incorrect! ${Provider.of<GatesSelectedController>(
                              context,
                              listen: false,
                            ).gatesSelected}"),
                    ),
                  );
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
                        .setSelected(
                      [data.gateName],
                    );
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
