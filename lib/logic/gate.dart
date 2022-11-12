import 'dart:math';

abstract class Gate {
  List<Gate> inputs;

  Gate(this.inputs);

  bool output();
}

class Signal extends Gate {
  bool signal;

  Signal(List<Gate> inputs, this.signal) : super(inputs);

  bool output() {
    return signal;
  }
}

class And extends Gate {
  And(List<Gate> inputs) : super(inputs);

  bool output() {
    bool out = true;
    for (Gate i in inputs) {
      out &= i.output();
    }
    return out;
  }
}

class Or extends Gate {
  Or(List<Gate> inputs) : super(inputs);

  bool output() {
    bool out = false;
    for (Gate i in inputs) {
      out |= i.output();
    }
    return out;
  }
}

class Not extends Gate {
  Not(List<Gate> inputs)
      : assert(inputs.length == 1),
        super(inputs);

  bool output() {
    return !inputs[0].output();
  }
}

class Nand extends Gate {
  Nand(List<Gate> inputs) : super(inputs);

  bool output() {
    var temp = And(inputs);
    return !temp.output();
  }
}

class Nor extends Gate {
  Nor(List<Gate> inputs) : super(inputs);

  bool output() {
    var temp = Or(inputs);
    return !temp.output();
  }
}

class Xor extends Gate {
  Xor(List<Gate> inputs) : super(inputs);

  bool output() {
    var temp = false;
    for (Gate i in inputs) {
      temp = (temp != i.output());
    }
    return temp;
  }
}

class Xnor extends Gate {
  Xnor(List<Gate> inputs) : super(inputs);

  bool output() {
    var temp = true;
    for (Gate i in inputs) {
      temp = (temp == i.output());
    }
    return temp;
  }
}

class Circuit {
  List<Signal> signals;
  Gate out_gate;

  Circuit(this.signals, this.out_gate);

  bool evaluate(List<bool> inputs) {
    assert(inputs.length == signals.length);
    for (int i = 0; i < inputs.length; ++i) {
      signals[i].signal = inputs[i];
    }
    return out_gate.output();
  }
}

bool solve_expression(String expression, List<bool> inputs) {
  var products = expression.split("+");
  bool output = false;
  for (String i in products) {
    var temp = i.split('*');
    var tempOut = true;
    for (String j in temp) {
      if (j.length == 1) {
        tempOut &= inputs[j.codeUnitAt(0) - 65];
      } else {
        tempOut &= !inputs[j.codeUnitAt(1) - 65];
      }
    }
    output |= tempOut;
  }
  return output;
}



bool verifyEquality(Circuit circuit, String expression, int num_vars) {
  for (int i = 0; i < pow(2, num_vars); ++i) {
    var binary_string = i.toRadixString(2);
    var inputs = List<bool>.filled(num_vars, false);
    while(binary_string.length != num_vars){
      binary_string = '0' + binary_string;
    }
    for (int j = 0; j < binary_string.length; ++j) {
      inputs[j] = (binary_string[j] == '0' ? false : true);
    }
    print(inputs);
    if (circuit.evaluate(inputs) != solve_expression(expression, inputs)) {
      return false;
    }
  }
  return true;
}

Gate wordToGate(String expression, List<Gate> inputs){
  switch(expression) {
    case "AND": {
      return And(inputs);
    }
    case "OR": {
      return Or(inputs);
    }
    case "NOT": {
      return Not(inputs);
    }
    case "NAND": {
      return Nand(inputs);
    }
    case "NOR": {
      return Nor(inputs);
    }
    case "XOR": {
      return Xor(inputs);
    }
    case "XNOR": {
      return Xnor(inputs);
    }
  }
  return And(inputs);
}

bool checkGates(int questionNumber, List<String> gates) {
  var a = Signal([], false);
  var b = Signal([], false);
  var c = Signal([], false);
  switch(questionNumber){
    case 1: {
      return verifyEquality(Circuit([a, b], wordToGate(gates[0],[a, b])), "A*B", 2);
    }
    case 2: {
      return verifyEquality(Circuit([a, b], wordToGate(gates[1],[wordToGate(gates[0],[a]), b])), "!A+B", 2);
    }
    case 3: {
      var not_c = wordToGate(gates[0], [c]);
      var a_and_b = wordToGate(gates[1], [a,b]);
      var b_and_not_c = wordToGate(gates[2], [b, not_c]);
      var out_gate = wordToGate(gates[3], [a_and_b, b_and_not_c]);
      return verifyEquality(Circuit([a, b, c], out_gate), 'A*C+B*!C', 3);
    }
    case 4: {
      var a_xor_c = wordToGate(gates[0], [a,c]);
      var b_and_c = wordToGate(gates[1], [b,c]);
      var out_gate = wordToGate(gates[2], [a_xor_c, b_and_c]);
      return verifyEquality(Circuit([a, b, c], out_gate), 'A*!C+!A*C+B*C', 3);
    }
    case 5: {
      return verifyEquality(Circuit([a, b], wordToGate(gates[0],[a, b])), "!A+!B", 2);
    }
    case 6: {
      var a_xor_b = wordToGate(gates[0], [a,b]);
      var a_xor_c = wordToGate(gates[1], [a,c]);
      var out_gate = wordToGate(gates[2], [a_xor_c, a_xor_b]);
      return verifyEquality(Circuit([a, b, c], out_gate), 'A*!B*!C+!A*B*C', 3);
    }
  }
  return false;
}

Gate circuit(Signal a, Signal b) {
  var not_a = Not([a]);
  var not_b = Not([b]);
  var and_one = And([a, not_b]);
  var and_two = And([b, not_a]);
  var out_circuit = Or([and_one, and_two]);
  return out_circuit;
}

void main() {
  print(checkGates(1, ["AND"]));
}
