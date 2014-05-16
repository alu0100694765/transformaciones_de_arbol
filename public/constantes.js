
var ambitos = [];

function buscarConstante (n_simbol, ambito) {
	
  for (i = (ambitos.length - 1); i >= 0; i--) {

    if (ambitos[i].name == ambito && ambitos[i].symbol_table[n_simbol] != undefined) {
      if (ambitos[i].symbol_table[n_simbol].type == "const")
        return [true, ambitos[i].symbol_table[n_simbol].value];
      break;
    }
  }

	return [false];
};

function recorrido (arbol) {
	
	if (typeof arbol == "object") {
		
		if (arbol.type == "program")
			ambitos.push( { name: "global", symbol_table: arbol.symbol_table } );
		if (arbol.type == "prodecure")
      ambitos.push( { name: arbol.id, symbol_table: arbol.symbol_table } );
    
    if (arbol.type == "ID") {
      
      var res = buscarConstante(arbol.value, arbol.declared_in);
      
      if (res[0]) {
        arbol["type"] = "NUM";
        arbol["value"] = res[1];
        arbol["declared_in"] = undefined;
      }
    }
    
		$.each(arbol, function(k,v) {
			//console.log(k + ": " + v);
			recorrido(v);
		})
		
		if (arbol.type == "program" || arbol.type == "procedure")
		  ambitos.pop();
      
		if (arbol.type == "+" || arbol.type == "-" || arbol.type == "*" || arbol.type == "/") {

      var resultado;
      if (typeof arbol.left == "object" && arbol.left.type == "NUM"
       && typeof arbol.right == "object" && arbol.right.type == "NUM") {
        switch (arbol.type) {
      
          case "+":
            resultado = parseFloat(arbol.left.value) + parseFloat(arbol.right.value);
          break;
      
          case "-":
            resultado = parseFloat(arbol.left.value) - parseFloat(arbol.right.value);
          break;
      
          case "*":
            resultado = parseFloat(arbol.left.value) * parseFloat(arbol.right.value);
          break;
          
          case "/":
            resultado = parseFloat(arbol.left.value) / parseFloat(arbol.right.value);
          break;
        }
      
        arbol.left = undefined;
        arbol.right = undefined;
        arbol.type = "NUM";
        arbol.value = resultado.toString();
      }
    }
	}
};
  

