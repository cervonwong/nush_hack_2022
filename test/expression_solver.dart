// Must be in SOP form !A*B*C + A*!B*!C
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

void main(){
  var x = true;
  x &= false;
  print(x);
}