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
  bool output(){
    bool out = true;
    for(Gate i in inputs){
      out &= i.output();
    }
    return out;
  }
}

class Or extends Gate{
  Or(List<Gate> inputs) : super(inputs);
  bool output(){
    bool out = false;
    for(Gate i in inputs){
      out |= i.output();
    }
    return out;
  }
}

class Not extends Gate{
  Not(List<Gate> inputs) : assert(inputs.length == 1), super(inputs);
  bool output(){
    return !inputs[0].output();
  }
}

class Nand extends Gate{
  Nand(List<Gate> inputs) : super(inputs);
  bool output(){
    var temp = And(inputs);
    return !temp.output();
  }
}

class Nor extends Gate{
  Nor(List<Gate> inputs) : super(inputs);
  bool output(){
    var temp = Or(inputs);
    return !temp.output();
  }
}

class Xor extends Gate{
  Xor(List<Gate> inputs) : super(inputs);
  bool output(){
    var temp = false;
    for(Gate i in inputs) {
      temp = (temp != i.output());
    }
    return temp;
  }
}

class Xnor extends Gate{
  Xnor(List<Gate> inputs) : super(inputs);
  bool output(){
    var temp = true;
    for(Gate i in inputs) {
      temp = (temp == i.output());
    }
    return temp;
  }
}

class Circuit{
  List<Signal> signals;
  Gate out_gate;
  Circuit(this.signals, this.out_gate);
  bool evaluate(List<bool> inputs){
    assert(inputs.length == signals.length);
    for(int i = 0; i < inputs.length; ++i){
      signals[i].signal = inputs[i];
    }
    return out_gate.output();
  }
}

bool solve_expression(String expression, List<bool> inputs){
  var products = expression.split("+");
  bool output = false;
  for(String i in products){
    var temp = i.split('*');
    var tempOut = true;
    for(String j in temp){
      if(j.length == 1){
        tempOut &= inputs[j.codeUnitAt(0)-65];
      }
      else{
        tempOut &= !inputs[j.codeUnitAt(1)-65];
      }
    }
    output |= tempOut;
  }
  return output;
}

bool verifyEquality(Circuit circuit, String expression, int num_vars){
  for(int i = 0; i < pow(2, num_vars); ++i){
    var binary_string = num_vars.toRadixString(2);
    var inputs = List<bool>.filled(num_vars, false);
    for(int i = 0; i < binary_string.length; ++i){
      inputs[num_vars - i - 1] = (binary_string[i] == '0' ? false : true);
    }
    if(circuit.evaluate(inputs) != solve_expression(expression, inputs)){
      return false;
    }
  }
  return true;
}

Gate circuit(Signal a, Signal b){
  var not_a = Not([a]);
  var not_b = Not([b]);
  var and_one = And([a, not_b]);
  var and_two = And([b, not_a]);
  var out_circuit = Or([and_one, and_two]);
  return out_circuit;
}

void main(){
  var a = Signal([], false);
  var b = Signal([], false);
  print(solve_expression("!A*B+!B*A", [false,true]));
  print(verifyEquality(Circuit([a,b], Xnor([a, b])), "A*B+!A*!B", 2));
}