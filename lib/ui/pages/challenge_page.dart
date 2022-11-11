import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../logic/controllers/gates_selected_controller.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({Key? key}) : super(key: key);

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
              ExpressionLabel(),
              SizedBox(height: 24.0),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircuitPane(),
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
                      content: Provider.of<GatesSelectedController>(context,
                                      listen: false)
                                  .gatesSelected[0] ==
                              'OR'
                          ? Text("Correct!")
                          : Text("Incorrect!"),
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
  const ExpressionLabel({Key? key}) : super(key: key);

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
        "A+B",
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

class CircuitPane extends StatefulWidget {
  const CircuitPane({
    Key? key,
  }) : super(key: key);

  @override
  State<CircuitPane> createState() => _CircuitPaneState();
}

class _CircuitPaneState extends State<CircuitPane> {
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
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(5.0, 27.0, 0.0, 0.0),
                height: 80.0 * MediaQuery.of(context).size.width / 1100.0,
                width: 144.0 * MediaQuery.of(context).size.width / 1100.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFCBCBCB)),
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
                    return true;
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
          child: Column(
            children: [
              DraggableAnd(),
              Draggable<GateInfo>(
                data: GateInfo(
                  gateName: 'OR',
                ),
                child: Container(
                  height: 120.0,
                  width: 120.0,
                  child: Center(
                    child: Image.asset('assets/OR.png'),
                  ),
                ),
                feedback: Container(
                  height: 120.0,
                  width: 120.0,
                  child: Center(
                    child: Image.asset('assets/OR.png'),
                  ),
                ),
              ),
              Draggable<GateInfo>(
                data: GateInfo(
                  gateName: 'NAND',
                ),
                child: Container(
                  height: 120.0,
                  width: 120.0,
                  child: Center(
                    child: Image.asset('assets/NAND.png'),
                  ),
                ),
                feedback: Container(
                  height: 120.0,
                  width: 120.0,
                  child: Center(
                    child: Image.asset('assets/NAND.png'),
                  ),
                ),
              ),
              Draggable<GateInfo>(
                data: GateInfo(
                  gateName: 'NOR',
                ),
                child: Container(
                  height: 120.0,
                  width: 120.0,
                  child: Center(
                    child: Image.asset('assets/NOR.png'),
                  ),
                ),
                feedback: Container(
                  height: 120.0,
                  width: 120.0,
                  child: Center(
                    child: Image.asset('assets/NOR.png'),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class DraggableAnd extends StatelessWidget {
  const DraggableAnd({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<GateInfo>(
      data: GateInfo(
        gateName: 'AND',
      ),
      child: Container(
        height: 120.0,
        width: 120.0,
        child: Center(
          child: Image.asset('assets/AND.png'),
        ),
      ),
      feedback: Container(
        height: 120.0,
        width: 120.0,
        child: Center(
          child: Image.asset('assets/AND.png'),
        ),
      ),
    );
  }
}

class GateInfo {
  final String gateName;

  GateInfo({required this.gateName});
}
